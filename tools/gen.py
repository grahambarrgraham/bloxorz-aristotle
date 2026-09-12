#!/usr/bin/env python3
"""Generate RequestProject/Blox/Data.lean from the level files.

The successor function implemented here mirrors `Blox.step` of the Lean model
exactly; it is used to produce optimal move sequences (witnesses) for each level.
The Lean proof does not trust these witnesses: it checks them.
"""
import sys, collections
sys.path.insert(0, 'tools')
from solve import Level as PyLevel, TYPES

DIRS = 'UDLR'
DELTA = {'U': (0, 1), 'D': (0, -1), 'L': (-1, 0), 'R': (1, 0)}


def big_move(o, x, y, d):
    if d == 'U':
        return {'h': ('h', x, y + 1), 'v': ('z', x, y + 2), 'z': ('v', x, y + 1)}[o]
    if d == 'D':
        return {'h': ('h', x, y - 1), 'v': ('z', x, y - 1), 'z': ('v', x, y - 2)}[o]
    if d == 'L':
        return {'h': ('z', x - 1, y), 'v': ('v', x - 1, y), 'z': ('h', x - 2, y)}[o]
    return {'h': ('z', x + 2, y), 'v': ('v', x + 1, y), 'z': ('h', x + 1, y)}[o]


def big_cells(o, x, y):
    if o == 'z':
        return [(x, y)]
    if o == 'h':
        return [(x, y), (x + 1, y)]
    return [(x, y), (x, y + 1)]


def ltpos(a, b):
    return a[0] < b[0] or (a[0] == b[0] and a[1] < b[1])


def mk_blocks(a, b):
    """`a` is the half block that just moved (the active one)."""
    p, q = (a, b) if ltpos(a, b) else (b, a)
    if q[0] - p[0] == 1 and p[1] == q[1]:
        return ('big', 'h', p[0], p[1])
    if p[0] == q[0] and q[1] - p[1] == 1:
        return ('big', 'v', p[0], p[1])
    return ('split', p[0], p[1], q[0], q[1], not ltpos(a, b))


def type_at(lev, cfg, c):
    return lev.typ(cfg, c)


def cell_ok(lev, cfg, standing, c):
    t = lev.typ(cfg, c)
    if t == 'missing':
        return False
    if t == 'weak':
        return not standing
    return True


def fire(lev, cfg, standing, cs):
    return __import__('solve').apply_switches(lev, cfg, cs, standing)


def step(lev, st, m):
    kind = st[0]
    cfg = st[-1]
    if m == 'S':
        if kind != 'split':
            return None
        _, x1, y1, x2, y2, sec, cfg = st
        return ('split', x1, y1, x2, y2, not sec, cfg)
    if kind == 'big':
        _, o, x, y, cfg = st
        o2, x2, y2 = big_move(o, x, y, m)
        cs = big_cells(o2, x2, y2)
        standing = (o2 == 'z')
        if not all(cell_ok(lev, cfg, standing, c) for c in cs):
            return None
        tel = []
        if standing and lev.tile.get((x2, y2), ('missing', None))[0] == 'teleport':
            rid = lev.tile[(x2, y2)][1]
            for verb, objs in lev.rules[rid]:
                if verb == 'teleports':
                    coords = set()
                    for o_ in objs:
                        coords |= lev.objs[o_]
                    tel = sorted(coords)
                    break
        if len(tel) == 2:
            a, b = tel
            nb = mk_blocks(a, b)
            ncfg = fire(lev, cfg, False, [a])
            return nb + (ncfg,)
        return ('big', o2, x2, y2, fire(lev, cfg, standing, cs))
    else:
        _, x1, y1, x2, y2, sec, cfg = st
        active = (x2, y2) if sec else (x1, y1)
        other = (x1, y1) if sec else (x2, y2)
        dx, dy = DELTA[m]
        np_ = (active[0] + dx, active[1] + dy)
        if np_ == other:
            return None
        if not cell_ok(lev, cfg, False, np_):
            return None
        nb = mk_blocks(np_, other)
        return nb + (fire(lev, cfg, False, [np_]),)


def solve(lev):
    start = ('big', 'z', lev.start[0], lev.start[1], lev.initcfg())
    dist = {start: 0}
    prev = {start: None}
    dq = collections.deque([start])
    goal = None
    while dq:
        st = dq.popleft()
        if st[0] == 'big' and st[1] == 'z' and (st[2], st[3]) == lev.end:
            goal = st
            break
        for m in ['S'] + list(DIRS):
            ns = step(lev, st, m)
            if ns is None:
                continue
            nd = dist[st] + (0 if m == 'S' else 1)
            if ns not in dist or nd < dist[ns]:
                dist[ns] = nd
                prev[ns] = (st, m)
                if m == 'S':
                    dq.appendleft(ns)
                else:
                    dq.append(ns)
    if goal is None:
        return None, None
    path = []
    cur = goal
    while prev[cur] is not None:
        st, m = prev[cur]
        path.append(m)
        cur = st
    path.reverse()
    return dist[goal], ''.join(path)


def lean_rows(path):
    rows = []
    inrules = False
    rules = []
    for line in open(path):
        line = line.replace('\r', '').rstrip('\n')
        if inrules:
            line = line.strip()
            if line:
                parts = line.split()
                subj, verb = parts[0], parts[1].lower()
                objs = [s.strip() for s in ' '.join(parts[2:]).split(',')]
                objs = [o for o in objs if o]
                rules.append((subj, verb, objs))
        elif line.startswith('-'):
            inrules = True
        else:
            if line.strip():
                rows.append(line.split())
    return rows, rules


def main():
    out = []
    out.append('import RequestProject.Blox.Compile')
    out.append('')
    out.append('/-!')
    out.append('# The 33 levels of the game, and optimal plays for them')
    out.append('')
    out.append('Each `rawN` below is a verbatim transcription of')
    out.append('`src/main/resources/levelN.txt` (grid rows in file order, then the rules).')
    out.append('`solN` is a play of `levelN` of optimal length; the fact that it is a play,')
    out.append('and the fact that no shorter play exists, are both proved in `Optimal.lean`.')
    out.append('-/')
    out.append('')
    out.append('namespace Blox')
    out.append('')
    costs = []
    for n in range(1, 34):
        path = 'src/main/resources/level%d.txt' % n
        rows, rules = lean_rows(path)
        lev = PyLevel(path)
        d, sol = solve(lev)
        costs.append(d)
        print('level', n, d, len(sol), file=sys.stderr)
        out.append('/-- Level %d of the game (`src/main/resources/level%d.txt`). -/' % (n, n))
        out.append('def raw%d : RawLevel where' % n)
        out.append('  rows :=')
        for i, r in enumerate(rows):
            pre = '    [' if i == 0 else '     '
            out.append(pre + '[' + ', '.join('"%s"' % t for t in r) + ']' +
                       (',' if i + 1 < len(rows) else ']'))
        if rules:
            out.append('  rules :=')
            for i, (s, v, objs) in enumerate(rules):
                pre = '    [' if i == 0 else '     '
                out.append(pre + '("%s", "%s", [%s])' % (s, v, ', '.join('"%s"' % o for o in objs)) +
                           (',' if i + 1 < len(rules) else ']'))
        else:
            out.append('  rules := []')
        out.append('')
        out.append('def level%d : Level := compile raw%d' % (n, n))
        out.append('')
        out.append('/-- An optimal play of level %d: %d moves. -/' % (n, d))
        out.append('def sol%d : List Move := parseMoves "%s"' % (n, sol))
        out.append('')
    out.append('/-- The 33 levels. -/')
    out.append('def levels : List Level :=')
    out.append('  [' + ', '.join('level%d' % n for n in range(1, 34)) + ']')
    out.append('')
    out.append('/-- The optimal plays. -/')
    out.append('def sols : List (List Move) :=')
    out.append('  [' + ', '.join('sol%d' % n for n in range(1, 34)) + ']')
    out.append('')
    out.append('/-- The optimal number of moves for each level. -/')
    out.append('def opts : List Nat :=')
    out.append('  [' + ', '.join(str(c) for c in costs) + ']')
    out.append('')
    out.append('end Blox')
    open('RequestProject/Blox/Data.lean', 'w').write('\n'.join(out) + '\n')
    print('total', sum(costs), file=sys.stderr)


if __name__ == '__main__':
    main()
