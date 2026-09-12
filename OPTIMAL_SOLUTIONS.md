# Optimal solutions

One optimal play for each level, in the notation of the level walkthroughs:
`U`/`D`/`L`/`R` are moves (with a repeat count), `S` switches between the two
half blocks after a teleport and does not count as a move.  Each play is
checked in `RequestProject/Blox/Data.lean` / `Optimal.lean`, where it is also
proved that no shorter play exists.

| level | optimal moves | play |
| --- | --- | --- |
| 1 | 7 | `R,D2,R2,D,R` |
| 2 | 17 | `U,R,D,R4,U2,D,R,D,R2,U,R,U` |
| 3 | 19 | `U,L,D,R,U,R4,U2,R3,D3,R,U` |
| 4 | 28 | `U,L,U,R2,U,R6,D,R,D5,R,U,L6,D` |
| 5 | 33 | `L4,R,L4,D,R,D2,R4,D,R4,L4,D,L6` |
| 6 | 35 | `R3,D2,R,D2,R,D,R,U,L3,U2,L,U3,R2,D,R2,U,L,D2,R2,D2,R` |
| 7 | 44 | `D,L,U,R5,D,R,L,U,L5,D,R,D,R,D,R3,U2,R,D,L,U,R,U2,R3,D,R,D,R,D,L,U` |
| 8 | 10 | `R2,U4,S,D2,R2` |
| 9 | 24 | `R,D,R6,U,R,D,R5,U,S,D,L5,D` |
| 10 | 57 | `R2,D2,R2,D,R,D5,L4,U,L3,D,U,R3,D,R3,U,S,L,D3,R,D3,L,D,U,R,U4,L2,U,L,D,L5` |
| 11 | 47 | `R4,U,L,D3,R3,D,L,U,L3,U2,R,U,R2,D,R,U,L3,D2,L3,U2,R,U2,L,D,R,U,R,D,L` |
| 12 | 65 | `L,D,R,U,R,U,R,U,L,D,R,U,R,U,R3,D3,L,U,R,U3,L3,R3,D3,L,D,R,U,R,D,L,U3,R2,U,D,L,D3,L,U,R,U,L,U,L3,D2,L` |
| 13 | 46 | `U2,L,D,R,D,R,D,L,U4,L7,D3,R,U,L,D,R,D2,R,D2,R,U,R5,U,L,D,L,U2` |
| 14 | 67 | `R4,U,L2,D,R3,D4,L3,D,R,U,R2,U2,D2,L2,D,R,D,R2,L2,U,L2,U,R3,U4,L6,U,R,D,L5,D3,R,D,R` |
| 15 | 57 | `R4,U7,R3,U2,R3,D,R,D,S,L3,S,U,D,U2,L4,D,S,L6,D,L2,D3,L,D,R,U,R7` |
| 16 | 28 | `R5,D,R,U,R,L3,R4,L4,S,L,D,R,U,R4` |
| 17 | 106 | `D5,L,U,R5,U,R3,L3,D,L4,U6,R4,D,R4,D,L,U,R,D,U,R,D,L,U2,R,D,L2,U,R,D,L4,U,L4,D6,R4,U,R3,D2,U,L,U,L3,D,L3,U3,L,U,R5,D,R3` |
| 18 | 85 | `U,L,D,R4,U2,D2,L3,U,R,D,L2,U,R,D,R3,D2,U2,L3,U,L,D,R,U,L2,D4,R2,L2,U4,R2,D,L,U,R,D2,L,U,R,D,R,U,R5,D3,L,U,R,D2,L,U,R,D,L,U,R` |
| 19 | 67 | `R8,D,R,U,L6,D,R,U,R5,D5,L5,D,L,U,R6,U,L,D,L5,D4,R3,L6,U2` |
| 20 | 56 | `D,L,D,R,D,L,U2,R,U2,L3,D,L2,U,R,D2,L,D2,L,D,U,R,U2,R,U2,R3,D,L,D,U,L,D,S,L4,D5,R4,D` |
| 21 | 72 | `R,D,L,U,L,D,R,U,R2,U,R3,U,L,D3,U3,R,D,L3,D,L2,D,L,U,R,D,R,U,L,D,R,U,L,D,R,D2,R,D2,R3,U,R,D,L4,U,R,D,R3,U4,R3` |
| 22 | 65 | `R,U,R4,D,R,D3,L,D,U,R,U3,L,U,R,D,L,U,L,U,L2,D,L3,D,R,U,R,D,L,D3,R,D,U,L,U3,R,U,L,D,R,U,R,U,R3,D,R4,U` |
| 23 | 75 | `R,D2,R,U,R5,U,L,D,R,S,U,L3,U4,R3,U,R,D,L4,D4,L9,U3,R2,U,D,L,U,R,D2,R,D3,R2,D,R,U6,R,D,L,U` |
| 24 | 57 | `D,L,D,R,D,L,U2,D2,R,U,L,U,R,D,R2,U2,R,U,L,D,R,U,R4,L5,D,R,L,U,R,D,L,U,R7,D,L,R,U,R3` |
| 25 | 55 | `U,R,D,L,U,R,D,L,U,R4,U,L,U,L2,U,R,L,D,R2,D2,L4,D,R2,U,R3,U2,R3,U,L,D,R,U2,L,D,R,U,R,D,L` |
| 26 | 104 | `U2,L3,D,L3,D,R,U,R2,U2,R2,D,R2,D,R2,U5,L3,D,L5,D2,L,D,S,L2,U,L3,D,L5,D2,L,D,U2,R,U,R3,U,R3,D,R2,U5,L3,D,L,D4,R3,S,L2,U,L3,D,L,D4,R2,L` |
| 27 | 71 | `R5,U,L,D,R,U,R,D,L6,U,R,D,L2,U,R,D,R4,U,R4,D3,L,D3,L3,D,L,U4,R,D,L7,U,L,D2,R,U,L,D,R,U,L` |
| 28 | 100 | `L,D3,R,D,L,U,R,D2,R2,D2,R3,U3,L,U,L,U,L,U,L,D,R2,D,R,D,R,D,R2,D,L,D,L2,U3,L,U,L,U,L2,U,L2,D,L,U,R3,D,R,D,R,D,R,D,R,L6,U2,L4,D,S,D,L2,D2,L6,U2,L4,U` |
| 29 | 104 | `L,U,R,D,L,U,R,D,R,D2,R2,L2,U2,L,U,L,D,L,U,R,D,L,U2,L2,R2,D2,R,U,L,D,R,U,R,D,R,U2,R2,L2,D6,R2,L2,U4,L6,R4,D,L,U,R6,L5,U,L,D4,L3,D,R,U,L,D,R,U,L` |
| 30 | 114 | `D,R,D2,R2,U,R2,D,R4,U,D,L4,U,L3,D2,L,U,R5,U2,R,U,R3,U,R,D3,L2,D,L,D,R,U2,R,D,L,D,L4,U,L2,D,L2,U,L,D,L,U,R,U,D,L,D,R,U,R,D,R2,U,L,D2,L,U,R7,U,L,U3,R3,U,R,U,L5,D,L` |
| 31 | 91 | `U,L,D,L2,U4,D4,R3,U,L,D,R,U4,L,U,R,D2,L,U,R,D,L3,D3,L,D2,U2,R,U3,L4,D,R,U,L,D5,L,U,R,L,U,R,D,R,U,R2,U,R2,D,R3,U,L,D,R,U5,R,D,L` |
| 32 | 129 | `U2,L,D,R,U,R,U,R,D,L,R,U,L,D,L,D,L,U,R,D,L,U,R,U,R,U,R,D,L2,D3,L,D,L2,U,L,D,R3,U5,R,U,R2,U,D,L2,D,L,D5,L4,U,R,L,D,R4,U5,R,U,R2,U,D,L2,D,L,D5,L3,U,R,D,R2,U3,R,U,R2,U,L,D,L,D,L,D,R,U,L2,U,L5,D` |
| 33 | 65 | `R4,U,L,D2,L,U,R,U2,R2,D,R,D,R,U,L2,U,R,D,R,D2,R,D,L,D2,R2,U,D,L2,U2,R,U,L,U2,L,U,L,D,R,U,L3,D3,L,D,L2,D,L,U` |
| **total** | **2000** | |
