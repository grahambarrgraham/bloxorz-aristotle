#!/usr/bin/env python3
"""Reference (exploratory) Bloxorz solver, faithful to the Java model in src/main/java.

Cost model: each directional move (U/D/L/R) costs 1; switching the active block
(space) is free, which matches the move counts quoted in the project README.
"""
import re, sys, collections

TYPES = {'p':'plain','s':'start','w':'weak','x':'missing','t':'teleport',
         'S':'strongSwitch','W':'weakSwitch','e':'end','l':'teleportLanding'}

class Level:
    def __init__(self, path):
        lines = []
        rules_raw = []
        inrules = False
        for line in open(path):
            line = line.replace('\r','').rstrip('\n')
            if inrules:
                rules_raw.append(line)
            elif line.startswith('-'):
                inrules = True
            else:
                if line.strip()=='' : continue
                lines.append(line)
        temp = []
        for line in lines:
            toks = re.split(r' +', line.strip())
            temp.append([(TYPES[t[0]], t if len(t)>1 else None) for t in toks])
        H = len(temp); W = len(temp[0])
        for row in temp: assert len(row)==W, (path, len(row), W)
        self.W, self.H = W, H
        self.tile = {}    # (x,y) -> (type,id);  land[x][y] = temp[H-1-y][x]
        for y in range(H):
            for x in range(W):
                self.tile[(x,y)] = temp[H-1-y][x]
        self.rules = collections.defaultdict(list)   # subject id -> [(action, [objectIds])]
        for line in rules_raw:
            line = line.strip()
            if not line: continue
            m = re.fullmatch(r'(\w+)\s+(\w+)\s+(.+)', line)
            if not m: continue
            subj = m.group(1).strip(); verb = m.group(2).strip().lower()
            objs = [s.strip() for s in re.split(r',\s+', m.group(3))]
            self.rules[subj].append((verb, objs))
        self.objs = collections.defaultdict(set)
        self.start = None; self.end = None
        for (x,y),(t,i) in self.tile.items():
            if t=='start':
                self.start=(x,y)
                if i is not None: self.objs[i].add((x,y))
            elif t=='end':
                self.end=(x,y)
            elif t in ('strongSwitch','weakSwitch','teleport'):
                assert i is not None, (path,x,y)
                self.objs[i].add((x,y))
            elif t in ('missing','plain','teleportLanding'):
                if i is not None: self.objs[i].add((x,y))
        assert self.start and self.end
        mut = set()
        for subj, rs in self.rules.items():
            for (verb, objs) in rs:
                if verb=='teleports': continue
                for o in objs:
                    assert o in self.objs, (path, subj, o)
                    mut |= self.objs[o]
        self.mut = sorted(mut)
        self.mutidx = {c:i for i,c in enumerate(self.mut)}

    def typ(self, cfg, c):
        if c not in self.tile: return 'missing'
        i = self.mutidx.get(c)
        if i is None: return self.tile[c][0]
        return 'plain' if cfg[i] else 'missing'

    def initcfg(self):
        return tuple(self.tile[c][0] != 'missing' for c in self.mut)


def cells(b):
    _,o,x,y = b
    if o=='z': return [(x,y)]
    if o=='x': return [(x,y),(x+1,y)]
    return [(x,y),(x,y+1)]

def big_move(b, d):
    _,o,x,y = b
    if d=='U':
        if o=='x': return ('big','x',x,y+1)
        if o=='y': return ('big','z',x,y+2)
        return ('big','y',x,y+1)
    if d=='D':
        if o=='x': return ('big','x',x,y-1)
        if o=='y': return ('big','z',x,y-1)
        return ('big','y',x,y-2)
    if d=='L':
        if o=='x': return ('big','z',x-1,y)
        if o=='y': return ('big','y',x-1,y)
        return ('big','x',x-2,y)
    if d=='R':
        if o=='x': return ('big','z',x+2,y)
        if o=='y': return ('big','y',x+1,y)
        return ('big','x',x+1,y)

def make_split(coords):
    cs = sorted(coords)
    if len(cs)==2:
        (x1,y1),(x2,y2) = cs
        if x2-x1==1 and y1==y2: return ('big','x',x1,y1)
        if x1==x2 and y2-y1==1: return ('big','y',x1,y1)
    return ('split',)+tuple(cs)

def apply_switches(lev, cfg, tiles_cells, standing_big):
    out = list(cfg)
    for c in tiles_cells:
        t = lev.tile[c][0]
        if t=='weakSwitch' or (t=='strongSwitch' and standing_big):
            for (verb, objs) in lev.rules.get(lev.tile[c][1], []):
                if verb=='teleports': continue
                coords = set()
                for o in objs: coords |= lev.objs[o]
                for cc in coords:
                    i = lev.mutidx[cc]
                    if verb=='toggles': out[i] = not out[i]
                    elif verb=='closes': out[i] = False
                    elif verb=='opens': out[i] = True
    return tuple(out)

def successors(lev, st):
    b, cfg = st
    out = []
    if b[0]=='big':
        for d in 'UDLR':
            nb = big_move(b,d)
            cs = cells(nb)
            standing = (nb[1]=='z')
            ok = True
            for c in cs:
                t = lev.typ(cfg,c)
                if t=='missing' or (t=='weak' and standing):
                    ok=False; break
            if not ok: continue
            if standing and lev.tile[cs[0]][0]=='teleport':
                rid = lev.tile[cs[0]][1]
                verb, objs = lev.rules[rid][0]
                assert verb=='teleports'
                coords = set()
                for o in objs: coords |= lev.objs[o]
                nb2 = make_split(coords)
                if nb2[0]=='big':
                    out.append(((nb2, apply_switches(lev,cfg,cells(nb2), nb2[1]=='z')),d))
                else:
                    for c in nb2[1:]:
                        out.append(((nb2, apply_switches(lev,cfg,[c],False)),d))
            else:
                out.append(((nb, apply_switches(lev,cfg,cs,standing)),d))
    else:
        pts = list(b[1:])
        for k in range(len(pts)):
            for d,(dx,dy) in (('U',(0,1)),('D',(0,-1)),('L',(-1,0)),('R',(1,0))):
                np_ = (pts[k][0]+dx, pts[k][1]+dy)
                if lev.typ(cfg,np_)=='missing': continue
                other = [pts[j] for j in range(len(pts)) if j!=k]
                if np_ in other: continue
                nb = make_split([np_]+other)
                out.append(((nb, apply_switches(lev,cfg,[np_],False)),d))
    return out

def solve(path):
    lev = Level(path)
    start = (('big','z',lev.start[0],lev.start[1]), lev.initcfg())
    target_cell = lev.end
    dist = {start:0}
    q = collections.deque([start])
    while q:
        st = q.popleft()
        b,cfg = st
        if b[0]=='big' and b[1]=='z' and (b[2],b[3])==target_cell:
            return dist[st], len(dist)
        for ns,_ in successors(lev,st):
            if ns not in dist:
                dist[ns]=dist[st]+1
                q.append(ns)
    return None, len(dist)

if __name__=='__main__':
    tot=0
    for n in range(1,34):
        d,ns = solve('src/main/resources/level%d.txt'%n)
        print('level %d: %s  (states %d)'%(n,d,ns)); sys.stdout.flush()
        tot+=d
    print('TOTAL', tot)
