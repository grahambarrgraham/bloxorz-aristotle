This project was edited by [Aristotle](https://aristotle.harmonic.fun).

To cite Aristotle:
- Tag @Aristotle-Harmonic on GitHub PRs/issues
- Add as co-author to commits:
```
Co-authored-by: Aristotle (Harmonic) <aristotle-harmonic@harmonic.fun>
```

# bloxorz
This is an attempt to (optimally) solve the bloxorz puzzle game using an algorithm. The solver currently solves all levels in 2002
moves. The code was written in 2009 for the game as it was then (with 33 levels). A solution has been posted with 1999 moves, so the solver needs a bit more work!

# Algorithm
The program uses a simple implementation of the [A*](https://en.wikipedia.org/wiki/A*_search_algorithm) graph traversal algorithm. The tricky bit was to model 
the switches (which toggle the presence/absence of one or more tiles), as this effectively changes the shape of the graph being searched.

# Level Models
Each level in the game is modelled in a resource file in `/src/main/resources/level<x>.txt`. These files contain an array of characters/codes which map to the tiles on the level. The characters/codes are intepretted according to this table :

    x = missing (i.e. no tile)
    p = plain tile
    s = starting point
    e = end point (target)
    t = teleport
    S = strong switch ( i.e. block needs to be end-on)
    W = weak switch (i.e. any contact will trigger)
    w = weak tile (i.e. will break if arrived at end on)

Where a tile type is followed by a number, the number identifies a switch. 

Example:

    x  x  p  p  x  x  x  x  x  x  x  x  x  x
    x  x  p  p  x  x  x  x  x  x  x  x  x  x
    x  x  p  p  p  x  x  x  x  x  x  x  x  x
    x  x  p  p  W1 x  x  x  x  x  p  p  p  x4
    x  x  x  p  p  p  p  x3 x  x  p  e  p  x4
    x  x  x  x  x  x  p  p  x2 x2 p  p  p  x
    x  p  p  x  x  x  p  p  x  x  x  x  x  x
    p  p  S1 p  p1 p1 p  p  x  x  x  x  x  x
    p  s  p2 x  x  x  p  p  x  x  x  p  p  p
    p  p  p2 x  x  x  p  p  W2 p  p  p  p  p
    x  x  x  x  x  x  x  x  x  x  x  p  p  p
    W1 toggles x2, x4
    W2 closes p1
    W2 opens x3
    S1 opens x2
    
# 1999 Moves

The solver currently fails to find the following shorter sequences :

Level 15 : [R4, U2, S, U5, R3, U2, R4, D2, S, L4, S, U, D, U, L, U, L3, D, S, L5, D, L2, D3, L, D, R, U, R7] : 57 : 556

Level 21 : [R, D, L, U, L, D, R, U, R2, U, R3, U, L, D3, U3, R, D, L3, D, L2, D, L, U, R, D, R, U, L, D, R, U, L, D, R, D2, R, D2, R3, U2, D2, L2, U, L, D, R3, U4, R3] : 71 : 969

# Is 1999 optimal?  (formally verified answer: no, 2000 is)

The claim that the whole game can be played in 1999 moves has been checked
against the level descriptions in `src/main/resources`, and it does not hold.
The optimum is **2000 moves**, and this is now proved in Lean 4 (in
`RequestProject/Blox/`), so the solver can still be improved by two moves, but
not by three.

What is proved:

* for each of the 33 levels, an explicit play is exhibited and it is proved that
  no play of that level is shorter (`Blox.minCost_levelOf`, and the individual
  statements `Blox.optimal_level1` ... `Blox.optimal_level33`);
* the whole game therefore needs exactly 2000 moves
  (`Blox.min_total_moves : IsLeast Achievable 2000`);
* 1999 moves cannot be achieved (`Blox.not_achievable_1999`).

As in the move counts above, a move is one of `U`, `D`, `L`, `R`; switching
between the two half blocks after a teleport is free.

Where the current solver loses its moves: it is optimal on 32 of the 33 levels,
and loses exactly two moves on level 15 (it finds 59, the optimum is 57).

The 1999 figure comes from the two sequences quoted in the section above.  The
level 15 sequence is genuine: it is a legal play with 57 moves, and it is
optimal.  The level 21 sequence is not a legal play at all: its first 58 moves
can be played, but the 59th would roll the block onto a missing tile
(`Blox.readme21_fails_at_59`).  The optimum for level 21 is 72 moves, exactly
what the solver already finds, so 2002 - 2 = 2000 is the best possible total.

As a sanity check on the formal model, the walkthrough in
`src/main/resources/postedSolution.txt` was replayed in it: 31 of its 33 plays
win their level in the model (`Blox.postedPlays_results`); the two exceptions are
the sequences recorded for level 21 and level 24, which also roll the block onto
missing tiles.

Per-level results:

| level | solver (`log/blox.log`) | optimal |
| --- | --- | --- |
| 1 | 7 | 7 |
| 2 | 17 | 17 |
| 3 | 19 | 19 |
| 4 | 28 | 28 |
| 5 | 33 | 33 |
| 6 | 35 | 35 |
| 7 | 44 | 44 |
| 8 | 10 | 10 |
| 9 | 24 | 24 |
| 10 | 57 | 57 |
| 11 | 47 | 47 |
| 12 | 65 | 65 |
| 13 | 46 | 46 |
| 14 | 67 | 67 |
| 15 | 59 | 57 |
| 16 | 28 | 28 |
| 17 | 106 | 106 |
| 18 | 85 | 85 |
| 19 | 67 | 67 |
| 20 | 56 | 56 |
| 21 | 72 | 72 |
| 22 | 65 | 65 |
| 23 | 75 | 75 |
| 24 | 57 | 57 |
| 25 | 55 | 55 |
| 26 | 104 | 104 |
| 27 | 71 | 71 |
| 28 | 100 | 100 |
| 29 | 104 | 104 |
| 30 | 114 | 114 |
| 31 | 91 | 91 |
| 32 | 129 | 129 |
| 33 | 65 | 65 |
| **total** | **2002** | **2000** |


`OPTIMAL_SOLUTIONS.md` lists an optimal play for every level.

## The Lean development

| file | contents |
| --- | --- |
| `RequestProject/Blox/Model.lean` | the game semantics (tiles, switches, teleports, moves, what it means to win) |
| `RequestProject/Blox/Compile.lean` | turning a transcribed level file into a level |
| `RequestProject/Blox/Data.lean` | verbatim transcriptions of the 33 level files, and an optimal play for each |
| `RequestProject/Blox/Search.lean` | breadth-first search, and the certificate that turns its output into a proof of a lower bound |
| `RequestProject/Blox/Optimal.lean` | the per-level optima and the 2000-move result |
| `RequestProject/Blox/Validation.lean` | replaying the published solutions in the model |

Build it with `lake build`.
