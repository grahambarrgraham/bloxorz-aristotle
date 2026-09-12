import RequestProject.Blox.Compile

/-!
# The 33 levels of the game, and optimal plays for them

Each `rawN` below is a verbatim transcription of
`src/main/resources/levelN.txt` (grid rows in file order, then the rules).
`solN` is a play of `levelN` of optimal length; the fact that it is a play,
and the fact that no shorter play exists, are both proved in `Optimal.lean`.
-/

namespace Blox

/-- Level 1 of the game (`src/main/resources/level1.txt`). -/
def raw1 : RawLevel where
  rows :=
    [["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "s", "p", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "p", "p", "p", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "p", "p", "p", "p", "p", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "p", "p", "e", "p", "p", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x"]]
  rules := []

def level1 : Level := compile raw1

/-- An optimal play of level 1: 7 moves. -/
def sol1 : List Move := parseMoves "RDDRRDR"

/-- Level 2 of the game (`src/main/resources/level2.txt`). -/
def raw2 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "p", "x", "x", "p", "p", "S2", "p", "x", "x", "p", "e", "p"],
     ["p", "p", "W1", "p", "x", "x", "p", "p", "p", "p", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "p", "x", "x", "p", "p", "p", "p", "x", "x", "p", "p", "p"],
     ["p", "s", "p", "p", "x1", "x1", "p", "p", "p", "p", "x2", "x2", "p", "p", "p"],
     ["p", "p", "p", "p", "x", "x", "p", "p", "p", "p", "x", "x", "x", "x", "x"]]
  rules :=
    [("W1", "toggles", ["x1"]),
     ("S2", "toggles", ["x2"])]

def level2 : Level := compile raw2

/-- An optimal play of level 2: 17 moves. -/
def sol2 : List Move := parseMoves "URDRRRRUUDRDRRURU"

/-- Level 3 of the game (`src/main/resources/level3.txt`). -/
def raw3 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "p", "p", "x", "x"],
     ["p", "p", "p", "p", "x", "x", "p", "p", "p", "x", "x", "p", "p", "x", "x"],
     ["p", "p", "p", "p", "p", "p", "p", "p", "p", "x", "x", "p", "p", "p", "p"],
     ["p", "s", "p", "p", "x", "x", "x", "x", "x", "x", "x", "p", "p", "e", "p"],
     ["p", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"]]
  rules := []

def level3 : Level := compile raw3

/-- An optimal play of level 3: 19 moves. -/
def sol3 : List Move := parseMoves "ULDRURRRRUURRRDDDRU"

/-- Level 4 of the game (`src/main/resources/level4.txt`). -/
def raw4 : RawLevel where
  rows :=
    [["x", "x", "x", "w", "w", "w", "w", "w", "w", "w", "x", "x", "x", "x"],
     ["x", "x", "x", "w", "w", "w", "w", "w", "w", "w", "x", "x", "x", "x"],
     ["p", "p", "p", "p", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "p", "p", "x", "x"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "p", "p", "x", "x"],
     ["p", "s", "p", "x", "x", "p", "p", "p", "p", "w", "w", "w", "w", "w"],
     ["p", "p", "p", "x", "x", "p", "p", "p", "p", "w", "w", "w", "w", "w"],
     ["x", "x", "x", "x", "x", "p", "e", "p", "x", "x", "w", "w", "p", "w"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "w", "w", "w", "w"]]
  rules := []

def level4 : Level := compile raw4

/-- An optimal play of level 4: 28 moves. -/
def sol4 : List Move := parseMoves "ULURRURRRRRRDRDDDDDRULLLLLLD"

/-- Level 5 of the game (`src/main/resources/level5.txt`). -/
def raw5 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p"],
     ["x", "p", "p", "p", "p", "p1", "p1", "p", "W1", "p", "p", "p", "p", "s", "p"],
     ["x", "p", "p", "W2", "p", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "p", "p", "p", "W3", "p", "p", "p", "p", "p", "p", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "W4"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "p"],
     ["p", "e", "p", "p", "p", "p4", "p4", "p", "p", "p", "p", "p", "p", "x", "x"]]
  rules :=
    [("W4", "toggles", ["p4"]),
     ("W3", "closes", ["p4"]),
     ("W2", "opens", ["p4"]),
     ("W1", "toggles", ["p1"])]

def level5 : Level := compile raw5

/-- An optimal play of level 5: 33 moves. -/
def sol5 : List Move := parseMoves "LLLLRLLLLDRDDRRRRDRRRRLLLLDLLLLLL"

/-- Level 6 of the game (`src/main/resources/level6.txt`). -/
def raw6 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "p", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "p", "x", "x", "p", "p", "p", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "p", "x", "x", "p", "p", "p", "p", "p", "x", "x"],
     ["s", "p", "p", "p", "p", "p", "x", "x", "x", "x", "x", "p", "p", "p", "p"],
     ["x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "p", "p", "e", "p"],
     ["x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "p", "x", "x", "p", "p", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"]]
  rules := []

def level6 : Level := compile raw6

/-- An optimal play of level 6: 35 moves. -/
def sol6 : List Move := parseMoves "RRRDDRDDRDRULLLUULUUURRDRRULDDRRDDR"

/-- Level 7 of the game (`src/main/resources/level7.txt`). -/
def raw7 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "x", "x", "x"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "p", "x", "x", "p", "p", "p", "p"],
     ["p", "s", "p", "p", "p", "p", "p", "p", "p", "x", "x", "x", "p", "e", "p"],
     ["p", "p", "p", "x", "x", "x", "x", "p", "p", "S1", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "x", "x", "x", "x", "p", "p", "p", "x", "x", "p", "p", "p"],
     ["x", "p", "p", "x1", "x", "x", "x", "p", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "p", "p", "p", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x"]]
  rules :=
    [("S1", "toggles", ["x1"])]

def level7 : Level := compile raw7

/-- An optimal play of level 7: 44 moves. -/
def sol7 : List Move := parseMoves "DLURRRRRDRLULLLLLDRDRDRRRUURDLURUURRRDRDRDLU"

/-- Level 8 of the game (`src/main/resources/level8.txt`). -/
def raw8 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "l1", "p", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x"],
     ["p", "p", "p", "p", "p", "p", "x", "x", "x", "p", "p", "p", "p", "p", "p"],
     ["p", "s", "p", "p", "t1", "p", "x", "x", "x", "p", "p", "p", "p", "e", "p"],
     ["p", "p", "p", "p", "p", "p", "x", "x", "x", "p", "p", "p", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "l1", "p", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x"]]
  rules :=
    [("t1", "teleports", ["l1"])]

def level8 : Level := compile raw8

/-- An optimal play of level 8: 10 moves. -/
def sol8 : List Move := parseMoves "RRUUUUSDDRR"

/-- Level 9 of the game (`src/main/resources/level9.txt`). -/
def raw9 : RawLevel where
  rows :=
    [["p", "p", "p", "p", "x", "x", "x", "p", "x", "x", "x", "p", "p", "p", "p"],
     ["p", "s", "l2", "p", "x", "x", "x", "p", "x", "x", "x", "p", "l1", "t1", "p"],
     ["p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "p", "e", "p", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x", "x"]]
  rules :=
    [("t1", "teleports", ["l1", "l2"])]

def level9 : Level := compile raw9

/-- An optimal play of level 9: 24 moves. -/
def sol9 : List Move := parseMoves "RDRRRRRRURDRRRRRUSDLLLLLD"

/-- Level 10 of the game (`src/main/resources/level10.txt`). -/
def raw10 : RawLevel where
  rows :=
    [["p", "p", "p", "x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "p"],
     ["p", "e", "p", "x1", "x1", "p", "x2", "x2", "p", "s1", "p", "p", "t1", "p"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "p", "p", "p", "p", "x2", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x2", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "x"],
     ["x", "x", "x", "x", "p", "p", "p", "p", "p", "x", "x", "p", "p", "x"],
     ["x", "x", "x", "x", "p", "W1", "x", "x", "p", "p", "p", "S1", "p", "x"]]
  rules :=
    [("t1", "teleports", ["t1", "s1"]),
     ("W1", "toggles", ["x1"]),
     ("S1", "toggles", ["x2"])]

def level10 : Level := compile raw10

/-- An optimal play of level 10: 57 moves. -/
def sol10 : List Move := parseMoves "RRDDRRDRDDDDDLLLLULLLDURRRDRRRUSLDDDRDDDLDURUUUULLULDLLLLL"

/-- Level 11 of the game (`src/main/resources/level11.txt`). -/
def raw11 : RawLevel where
  rows :=
    [["x", "p", "p", "p", "p1", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "e", "p", "p1", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "x", "x", "x", "p", "p", "p", "p", "p", "p", "x"],
     ["x", "p", "x", "x", "x", "p", "p", "x", "x", "p", "p", "x"],
     ["s", "p", "p", "p", "p", "p", "p", "x", "x", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "p", "W1", "x", "x", "x", "x", "p"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "p", "x", "x", "p"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x"]]
  rules :=
    [("W1", "closes", ["p1"])]

def level11 : Level := compile raw11

/-- An optimal play of level 11: 47 moves. -/
def sol11 : List Move := parseMoves "RRRRULDDDRRRDLULLLUURURRDRULLLDDLLLUURUULDRURDL"

/-- Level 12 of the game (`src/main/resources/level12.txt`). -/
def raw12 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "S2"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "p", "S1", "p", "p", "p", "p", "p", "x2"],
     ["x", "x", "x", "p", "p", "p", "p", "p", "x", "x", "p", "p", "x"],
     ["x", "x", "x", "p", "e", "p", "x1", "x", "x", "x", "p", "p", "x"],
     ["x", "p", "p", "p", "p", "p", "x", "x", "x", "p", "p", "p", "p"],
     ["p", "p", "s", "p", "x", "x", "x", "x", "x", "p", "p", "p", "p"],
     ["p", "p", "p", "p", "x", "x", "p", "p", "p", "p", "p", "x", "x"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"]]
  rules :=
    [("S1", "toggles", ["x2"]),
     ("S2", "toggles", ["x1"])]

def level12 : Level := compile raw12

/-- An optimal play of level 12: 65 moves. -/
def sol12 : List Move := parseMoves "LDRURURULDRURURRRDDDLURUUULLLRRRDDDLDRURDLUUURRUDLDDDLURULULLLDDL"

/-- Level 13 of the game (`src/main/resources/level13.txt`). -/
def raw13 : RawLevel where
  rows :=
    [["p", "p", "p", "w", "p", "p", "p", "p", "w", "p", "p", "p", "p", "x"],
     ["p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x"],
     ["p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "x", "x", "x", "p", "p", "p", "x", "x", "p", "s", "p"],
     ["p", "p", "p", "w", "w", "w", "p", "e", "p", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "x", "x", "w", "p", "p", "p", "x", "x", "p", "x", "x"],
     ["x", "x", "p", "x", "x", "w", "w", "w", "w", "w", "p", "p", "x", "x"],
     ["x", "x", "p", "p", "p", "w", "w", "p", "w", "w", "w", "x", "x", "x"],
     ["x", "x", "x", "p", "p", "w", "w", "w", "w", "w", "w", "x", "x", "x"],
     ["x", "x", "x", "p", "p", "p", "x", "x", "p", "p", "x", "x", "x", "x"]]
  rules := []

def level13 : Level := compile raw13

/-- An optimal play of level 13: 46 moves. -/
def sol13 : List Move := parseMoves "UULDRDRDLUUUULLLLLLLDDDRULDRDDRDDRURRRRRULDLUU"

/-- Level 14 of the game (`src/main/resources/level14.txt`). -/
def raw14 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x"],
     ["x", "x", "x", "p", "p", "p", "x", "x", "p", "p", "p", "x", "x", "x"],
     ["p", "x1", "x1", "p", "s", "p", "p", "p", "p", "p", "p", "p", "p", "p"],
     ["p", "x2", "x2", "p", "p", "p", "x", "x", "x", "x", "x", "x", "S1", "p"],
     ["p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p"],
     ["p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p"],
     ["p", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "p"],
     ["p", "p", "p", "p", "p", "x", "x", "x", "p", "p", "p", "x", "x", "x"],
     ["x", "p", "p", "e", "p", "x", "x", "x", "p", "p", "p", "x", "x", "x"],
     ["x", "x", "p", "p", "p", "x", "x", "x", "p", "p", "p", "p", "p", "S2"]]
  rules :=
    [("S1", "toggles", ["x1"]),
     ("S2", "toggles", ["x2"])]

def level14 : Level := compile raw14

/-- An optimal play of level 14: 67 moves. -/
def sol14 : List Move := parseMoves "RRRRULLDRRRDDDDLLLDRURRUUDDLLDRDRRLLULLURRRUUUULLLLLLURDLLLLLDDDRDR"

/-- Level 15 of the game (`src/main/resources/level15.txt`). -/
def raw15 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "p", "p", "p"],
     ["x", "x", "x", "x", "p", "p2", "p2", "p", "p", "p", "x2", "x2", "S4", "p1", "p"],
     ["p", "p", "x3", "x3", "p", "x", "x", "p", "p", "p", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "p", "p", "x", "x", "x", "W1", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "x", "x", "x", "x", "x", "t1", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "x", "x", "x", "x", "x", "p", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "x", "x", "x", "p", "p", "p", "x", "x", "W2", "p", "p", "x"],
     ["p", "s1", "p", "p", "p", "p", "p", "p", "p", "p3", "p3", "p", "e", "p", "x"],
     ["p", "p", "p", "x", "x", "x", "p", "p", "p", "x", "x", "W3", "p", "p", "x"]]
  rules :=
    [("t1", "teleports", ["p1", "s1"]),
     ("W1", "toggles", ["x2", "p2"]),
     ("W2", "closes", ["p3"]),
     ("W3", "closes", ["p3"]),
     ("S4", "toggles", ["p2", "x3"])]

def level15 : Level := compile raw15

/-- An optimal play of level 15: 57 moves. -/
def sol15 : List Move := parseMoves "RRRRUUUUUUURRRUURRRDRDSLLLSUDUULLLLDSLLLLLLDLLDDDLDRURRRRRRR"

/-- Level 16 of the game (`src/main/resources/level16.txt`). -/
def raw16 : RawLevel where
  rows :=
    [["x", "t1", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"],
     ["t2", "p", "t3", "x1", "x1", "S1", "S2", "p1", "x2", "x2", "p", "e", "p"],
     ["x", "t4", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "p", "p", "p", "x", "x", "x", "p", "p", "p", "x", "x"],
     ["x", "x", "p", "s", "p", "p", "p", "p", "p", "t5", "p", "x", "x"],
     ["x", "x", "p", "p", "p", "x", "x", "x", "p", "p", "p", "x", "x"]]
  rules :=
    [("t1", "teleports", ["p1", "S1"]),
     ("t2", "teleports", ["t3", "t1"]),
     ("t3", "teleports", ["t2", "t3"]),
     ("t4", "teleports", ["t4", "t2"]),
     ("t5", "teleports", ["t1", "t2"]),
     ("S1", "opens", ["x1"]),
     ("S2", "opens", ["x2"])]

def level16 : Level := compile raw16

/-- An optimal play of level 16: 28 moves. -/
def sol16 : List Move := parseMoves "RRRRRDRURLLLRRRRLLLLSLDRURRRR"

/-- Level 17 of the game (`src/main/resources/level17.txt`). -/
def raw17 : RawLevel where
  rows :=
    [["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "s", "p", "p", "p", "p", "p", "p", "p", "x4", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "x", "x", "x", "x", "x1", "p", "p", "p", "p", "p", "e", "p"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "S1", "S2", "p"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "x", "x", "x", "x2", "p", "p", "p", "p", "p", "S3", "x", "x"],
     ["p", "p", "p", "p", "p", "p", "p", "p", "x3", "x", "x", "p", "p", "x", "x"],
     ["p", "W1", "p", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "x", "x"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "p", "S4", "x", "x"]]
  rules :=
    [("S1", "closes", ["x2"]),
     ("S2", "opens", ["x2"]),
     ("S4", "closes", ["x3"]),
     ("S4", "opens", ["x4"]),
     ("S3", "opens", ["x1"]),
     ("W1", "toggles", ["x3"])]

def level17 : Level := compile raw17

/-- An optimal play of level 17: 106 moves. -/
def sol17 : List Move := parseMoves "DDDDDLURRRRRURRRLLLDLLLLUUUUUURRRRDRRRRDLURDURDLUURDLLURDLLLLULLLLDDDDDDRRRRURRRDDULULLLDLLLUUULURRRRRDRRR"

/-- Level 18 of the game (`src/main/resources/level18.txt`). -/
def raw18 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "W1", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "W6", "p", "x", "x", "x", "p", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "p", "p", "x", "x", "p", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "W2", "s", "p", "p", "p", "p", "p", "x1", "x1", "p", "p", "x3", "x3", "p"],
     ["p", "p", "p", "p", "p", "x5", "x", "x", "p", "x", "x", "x", "p", "x", "x"],
     ["p", "p", "W3", "p", "x", "x", "x", "x", "p", "x", "x", "x", "p", "x", "x"],
     ["p", "x", "x", "x", "x", "x", "x", "x", "W4", "x", "x", "p", "p", "p", "x"],
     ["p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "e", "p", "x"],
     ["p", "x6", "x6", "S5", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "x"]]
  rules :=
    [("W6", "closes", ["x6", "x3"]),
     ("W3", "closes", ["x6", "x3"]),
     ("W1", "opens", ["x1"]),
     ("W2", "closes", ["x1"]),
     ("W4", "opens", ["x6", "x3"]),
     ("S5", "toggles", ["x5"])]

def level18 : Level := compile raw18

/-- An optimal play of level 18: 85 moves. -/
def sol18 : List Move := parseMoves "ULDRRRRUUDDLLLURDLLURDRRRDDUULLLULDRULLDDDDRRLLUUUURRDLURDDLURDRURRRRRDDDLURDDLURDLUR"

/-- Level 19 of the game (`src/main/resources/level19.txt`). -/
def raw19 : RawLevel where
  rows :=
    [["x", "s", "p", "p", "p", "p", "p", "p", "p", "p", "W1", "p", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "p", "p", "x", "x", "x", "x", "x", "x", "p", "p"],
     ["x", "x", "x", "x", "x", "p", "p", "x", "x", "x", "x", "x", "x", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p"],
     ["p", "p", "p", "x", "x", "p", "p", "x1", "x1", "p", "W2", "p", "p", "p", "p"],
     ["p", "e", "p", "x", "x", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "x", "x", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "p", "x", "x", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "p2", "p2", "p", "p", "p", "p", "p", "p", "W3", "p", "p", "p", "x"]]
  rules :=
    [("W1", "toggles", ["x1"]),
     ("W2", "closes", ["p2"]),
     ("W3", "opens", ["p2"])]

def level19 : Level := compile raw19

/-- An optimal play of level 19: 67 moves. -/
def sol19 : List Move := parseMoves "RRRRRRRRDRULLLLLLDRURRRRRDDDDDLLLLLDLURRRRRRULDLLLLLDDDDRRRLLLLLLUU"

/-- Level 20 of the game (`src/main/resources/level20.txt`). -/
def raw20 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"],
     ["x", "x", "p", "p", "p", "p3", "p3", "p", "p", "p", "x1", "x1", "p", "l5", "p"],
     ["x", "x", "p", "p", "p", "x", "x", "W1", "s", "p", "x", "x", "p", "p", "p"],
     ["x", "x", "p", "p", "p", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["x", "x", "p", "W2", "p", "x", "x", "t1", "p", "W3", "x", "x", "x", "x", "x"],
     ["x", "x", "p", "p", "p", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "p", "x", "x", "x", "p", "p", "p", "x2", "x2", "W4", "p", "p"],
     ["p", "W5", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "l4", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "e", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"]]
  rules :=
    [("W3", "closes", ["p3"]),
     ("W1", "closes", ["p3"]),
     ("W2", "closes", ["p3"]),
     ("t1", "teleports", ["l5", "l4"]),
     ("W4", "toggles", ["x2"]),
     ("W5", "opens", ["x1"])]

def level20 : Level := compile raw20

/-- An optimal play of level 20: 56 moves. -/
def sol20 : List Move := parseMoves "DLDRDLUURUULLLDLLURDDLDDLDURUURUURRRDLDULDSLLLLDDDDDRRRRD"

/-- Level 21 of the game (`src/main/resources/level21.txt`). -/
def raw21 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["p", "p", "x", "x", "p", "p", "p", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["p", "s", "p", "p", "p", "p", "x", "x", "p", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "p", "x", "x", "x", "x", "p", "x", "x", "x", "p", "p", "p"],
     ["x", "p", "p", "x", "p", "p", "p", "p", "S1", "p", "p", "p", "p", "e", "p"],
     ["x", "x", "p", "x", "x", "x", "x", "x", "S2", "p", "x", "x", "p", "p", "p"],
     ["x", "x", "p", "p", "p", "x", "x", "x", "p", "p", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "p", "p", "p", "x2", "x", "p", "p", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x1", "p", "p", "p", "p", "p", "p", "x", "x", "x", "x", "x"]]
  rules :=
    [("S1", "toggles", ["x1"]),
     ("S2", "toggles", ["x2"])]

def level21 : Level := compile raw21

/-- An optimal play of level 21: 72 moves. -/
def sol21 : List Move := parseMoves "RDLULDRURRURRRULDDDUUURDLLLDLLDLURDRULDRULDRDDRDDRRRURDLLLLURDRRRUUUURRR"

/-- Level 22 of the game (`src/main/resources/level22.txt`). -/
def raw22 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "p", "p", "x", "x", "x", "x", "p", "p", "p"],
     ["x", "x", "x", "p", "p", "p", "p", "p", "p", "x", "x", "p", "e", "p"],
     ["p", "p", "p", "p", "p", "p", "W1", "p", "p", "p", "p", "p", "p", "p"],
     ["p", "s", "p", "p", "W2", "x", "x", "p", "p", "p", "p", "p", "x2", "x"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x"],
     ["x", "p", "x", "x", "x", "x", "x", "x", "x", "x", "p", "x", "x", "x"],
     ["x", "p", "x", "x", "x", "x", "x", "x", "x", "x", "p", "x", "x", "x"],
     ["x", "p", "x1", "x", "x", "x", "x", "x", "x", "p1", "p", "x", "x", "x"],
     ["x", "p", "p", "x", "x", "x", "x", "x", "x", "p", "p", "x", "x", "x"],
     ["x", "x", "S3", "x", "x", "x", "x", "x", "x", "S4", "x", "x", "x", "x"]]
  rules :=
    [("W2", "closes", ["x2", "x1"]),
     ("W1", "closes", ["x2", "x1"]),
     ("S4", "toggles", ["x1"]),
     ("S3", "toggles", ["x2"])]

def level22 : Level := compile raw22

/-- An optimal play of level 22: 65 moves. -/
def sol22 : List Move := parseMoves "RURRRRDRDDDLDURUUULURDLULULLDLLLDRURDLDDDRDULUUURULDRURURRRDRRRRU"

/-- Level 23 of the game (`src/main/resources/level23.txt`). -/
def raw23 : RawLevel where
  rows :=
    [["x", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"],
     ["x", "p", "S1", "p", "x", "x", "x", "x", "x", "x", "x", "x", "p", "W1", "p"],
     ["x", "p", "p2", "p", "x", "x", "x", "p", "p", "p", "p1", "p1", "p", "p", "p"],
     ["x3", "p", "p", "p", "x4", "x", "x", "p", "e", "p", "x", "x", "p", "p", "W2"],
     ["p", "x", "x", "x", "p", "x", "x", "p", "p", "p", "x", "x", "x", "x", "p1"],
     ["W3", "x", "x", "x", "p", "x", "x", "w", "w", "w", "x", "x", "x", "x", "p"],
     ["p", "x2", "x2", "p", "p", "p", "w", "w", "w", "w", "w", "p", "p", "p", "p"],
     ["x", "x", "x", "p", "s", "p", "w", "w", "w", "w", "w", "p", "t1", "p", "x"],
     ["x", "x", "x", "p", "p", "p", "w", "w", "w", "w", "w", "p", "p", "p", "x"],
     ["x", "x", "x", "p", "p", "p", "p", "p", "x1", "x", "x", "x", "x", "x", "x"]]
  rules :=
    [("W2", "closes", ["p1"]),
     ("W1", "toggles", ["x1"]),
     ("W1", "opens", ["x2"]),
     ("t1", "teleports", ["t1", "p2"]),
     ("W3", "opens", ["x3"]),
     ("W3", "closes", ["x2"]),
     ("S1", "opens", ["x4"])]

def level23 : Level := compile raw23

/-- An optimal play of level 23: 75 moves. -/
def sol23 : List Move := parseMoves "RDDRURRRRRULDRSULLLUUUURRRURDLLLLDDDDLLLLLLLLLUUURRUDLURDDRDDDRRDRUUUUUURDLU"

/-- Level 24 of the game (`src/main/resources/level24.txt`). -/
def raw24 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p"],
     ["x", "x", "x", "x2", "p", "p", "p", "p", "p", "p", "p", "S1", "p", "t1"],
     ["x", "s", "x1", "x1", "p", "S2", "p", "x", "x", "x", "p", "p", "p", "p"],
     ["S3", "p", "x", "x", "p", "p", "x", "x", "x", "x", "x", "x", "p", "x"],
     ["p", "p", "x", "x", "p", "x", "x", "x", "x", "x", "x", "x", "p", "x"],
     ["p", "p", "p", "p", "p", "x", "x", "x", "x", "x", "p", "p", "p", "x"],
     ["p", "p", "p", "x", "x", "l1", "p", "l2", "x4", "x4", "p", "e", "p", "x"],
     ["x", "x", "x", "x", "x", "S4", "p", "x3", "x", "x", "p", "p", "p", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"]]
  rules :=
    [("t1", "teleports", ["l1", "l2"]),
     ("S1", "toggles", ["x1"]),
     ("S3", "opens", ["x2"]),
     ("S2", "opens", ["x3"]),
     ("S4", "opens", ["x4"])]

def level24 : Level := compile raw24

/-- An optimal play of level 24: 57 moves. -/
def sol24 : List Move := parseMoves "DLDRDLUUDDRULURDRRUURULDRURRRRLLLLLDRLURDLURRRRRRRDLRURRR"

/-- Level 25 of the game (`src/main/resources/level25.txt`). -/
def raw25 : RawLevel where
  rows :=
    [["x", "x", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "x", "p", "p", "W1", "x", "x", "x", "x", "x", "p", "p", "p", "x4"],
     ["x", "x", "x", "p", "p", "p", "p", "x3", "x", "x", "p", "e", "p", "x4"],
     ["x", "x", "x", "x", "x", "x", "p", "p", "x2", "x2", "p", "p", "p", "x"],
     ["x", "p", "p", "x", "x", "x", "p", "p", "x", "x", "x", "x", "x", "x"],
     ["p", "p", "S1", "p", "p1", "p1", "p", "p", "x", "x", "x", "x", "x", "x"],
     ["p", "s", "p2", "x", "x", "x", "p", "p", "x", "x", "x", "p", "p", "p"],
     ["p", "p", "p2", "x", "x", "x", "p", "p", "W2", "p", "p", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"]]
  rules :=
    [("W1", "toggles", ["x2", "x4"]),
     ("W2", "closes", ["p1"]),
     ("W2", "opens", ["x3"]),
     ("S1", "opens", ["x2"])]

def level25 : Level := compile raw25

/-- An optimal play of level 25: 55 moves. -/
def sol25 : List Move := parseMoves "URDLURDLURRRRULULLURLDRRDDLLLLDRRURRRUURRRULDRUULDRURDL"

/-- Level 26 of the game (`src/main/resources/level26.txt`). -/
def raw26 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "p", "p", "p", "p", "x", "x", "x", "x", "t1"],
     ["x", "x", "x", "x", "x", "p", "p", "W1", "p", "p", "p", "x", "x", "p"],
     ["x", "x", "x", "x", "p", "p", "p", "p", "p", "p", "p", "x", "x", "p"],
     ["p", "p", "p1", "p1", "p", "p", "p", "p", "x", "x", "p", "p", "p2", "p"],
     ["p", "p", "p", "x3", "x", "x", "p", "x", "x", "x", "p", "p", "x", "x"],
     ["p", "p", "p", "x", "x", "x", "p", "x", "x", "x", "s1", "x", "x", "x"],
     ["x", "p", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["x", "S1", "x", "x", "x", "x", "p", "e", "p", "x3", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"]]
  rules :=
    [("W1", "closes", ["p1"]),
     ("t1", "teleports", ["p2", "s1"]),
     ("S1", "opens", ["x3"])]

def level26 : Level := compile raw26

/-- An optimal play of level 26: 104 moves. -/
def sol26 : List Move := parseMoves "UULLLDLLLDRURRUURRDRRDRRUUUUULLLDLLLLLDDLDSLLULLLDLLLLLDDLDUURURRRURRRDRRUUUUULLLDLDDDDRRRSLLULLLDLDDDDRRL"

/-- Level 27 of the game (`src/main/resources/level27.txt`). -/
def raw27 : RawLevel where
  rows :=
    [["p", "p", "p", "x", "x", "x", "x", "p", "p", "p", "p", "p", "p", "p", "p"],
     ["p", "s", "p", "p", "p", "p", "p", "p", "p", "p", "p", "x", "x", "p", "p"],
     ["p", "p", "p", "x", "x", "x", "x", "p", "p", "x", "x", "x", "x", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "S1", "p"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "x"],
     ["p", "p", "p", "x", "x", "w", "w", "w", "w", "p", "x", "x", "W1", "W2", "x"],
     ["p", "e", "p", "w", "w", "w", "w", "w", "w", "w", "x", "x", "p", "p", "p"],
     ["p", "p", "p", "w", "w", "w", "w", "w", "w", "w", "w", "w", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "w", "w", "w", "w", "w", "w", "w", "p", "p", "p"],
     ["x", "x", "x", "x", "x", "x", "p1", "p", "p", "p2", "x", "x", "x", "x", "x"]]
  rules :=
    [("S1", "closes", ["p1", "p2"]),
     ("W2", "closes", ["p2"]),
     ("W1", "closes", ["p1"])]

def level27 : Level := compile raw27

/-- An optimal play of level 27: 71 moves. -/
def sol27 : List Move := parseMoves "RRRRRULDRURDLLLLLLURDLLURDRRRRURRRRDDDLDDDLLLDLUUUURDLLLLLLLULDDRULDRUL"

/-- Level 28 of the game (`src/main/resources/level28.txt`). -/
def raw28 : RawLevel where
  rows :=
    [["x", "p", "p", "p1", "p1", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x"],
     ["x", "p", "p", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x"],
     ["w", "w", "s", "x", "x", "p", "p", "p", "p", "x", "x", "x", "x", "x", "x"],
     ["w", "w", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["w", "w", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x", "x"],
     ["w", "p", "p", "p", "x", "x", "x", "x", "x", "p", "p", "t1", "x", "x", "x"],
     ["x", "p", "e", "p", "x", "x", "x", "x", "x", "x", "p", "p", "p", "p", "p2"],
     ["x", "p", "p", "p", "p", "p", "p", "x", "x", "x", "p", "W1", "p", "p", "p"],
     ["x", "x", "p", "x", "x", "p", "p", "x", "x", "x", "p", "p", "p", "x", "x"],
     ["x", "x", "p", "x", "x", "p", "p", "p", "p1", "p1", "p", "p", "p3", "x", "x"]]
  rules :=
    [("W1", "closes", ["p1"]),
     ("t1", "teleports", ["p2", "p3"])]

def level28 : Level := compile raw28

/-- An optimal play of level 28: 100 moves. -/
def sol28 : List Move := parseMoves "LDDDRDLURDDRRDDRRRUUULULULULDRRDRDRDRRDLDLLUUULULULLULLDLURRRDRDRDRDRLLLLLLUULLLLDSDLLDDLLLLLLUULLLLU"

/-- Level 29 of the game (`src/main/resources/level29.txt`). -/
def raw29 : RawLevel where
  rows :=
    [["x", "x", "W1", "p1", "p1", "p", "x", "x", "x", "p", "x1", "x1", "S1", "x", "x"],
     ["x", "x", "x", "x", "x", "p", "x", "x", "x", "p", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["S2", "x2", "x2", "p", "p", "p", "p", "s", "p", "p", "p", "p", "x3", "x3", "S3"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x6", "p", "x", "x", "p", "x", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x6", "p", "x", "x", "p", "p2", "p2", "W2", "x", "x"],
     ["p", "p", "p", "x", "x", "p", "p", "x", "x", "p", "x", "x", "x", "x", "x"],
     ["p", "e", "p", "x4", "x4", "p", "x", "x", "x", "p", "x", "x", "x", "x", "x"],
     ["p", "p", "p", "x5", "x", "x", "x", "x", "x", "p", "p3", "p3", "W3", "x", "x"]]
  rules :=
    [("W2", "opens", ["x2"]),
     ("W3", "opens", ["x3"]),
     ("W3", "closes", ["p2", "x1", "p1"]),
     ("S2", "opens", ["x4"]),
     ("W1", "closes", ["p2"]),
     ("S2", "closes", ["p3"]),
     ("S3", "opens", ["x5"]),
     ("W1", "opens", ["x1"]),
     ("S1", "opens", ["x6"])]

def level29 : Level := compile raw29

/-- An optimal play of level 29: 104 moves. -/
def sol29 : List Move := parseMoves "LURDLURDRDDRRLLUULULDLURDLUULLRRDDRULDRURDRUURRLLDDDDDDRRLLUUUULLLLLLRRRRDLURRRRRRLLLLLULDDDDLLLDRULDRUL"

/-- Level 30 of the game (`src/main/resources/level30.txt`). -/
def raw30 : RawLevel where
  rows :=
    [["x", "x", "x", "p", "p", "p", "p", "p", "w", "w", "p", "p", "p", "p", "x"],
     ["x", "x", "x", "p", "e", "p", "p", "x", "x", "x", "x", "x", "w", "p", "x"],
     ["x", "x", "x", "p", "p", "p", "x", "x", "x", "x", "x", "x", "w", "p", "S1"],
     ["x", "x", "x", "x", "x", "x", "x", "w", "p", "p", "p1", "p1", "p", "p", "p"],
     ["x", "x", "s", "x", "x", "x", "x", "w", "w", "x", "x", "x", "x", "x", "p"],
     ["x", "S2", "p", "w", "x", "x", "x", "w", "w", "x", "x", "x", "x", "x", "p"],
     ["w", "w", "w", "w", "x", "x", "x", "p", "p", "x2", "x", "x", "x2", "p", "p"],
     ["w", "w", "w", "p", "w", "p", "w", "w", "p", "w", "x", "x", "S3", "p", "x1"],
     ["p", "w", "w", "w", "w", "w", "w", "w", "w", "w", "w", "w", "p", "x", "x"],
     ["x", "w", "p", "w", "w", "w", "x", "x", "w", "w", "w", "w", "p", "x", "x"]]
  rules :=
    [("S3", "toggles", ["x1"]),
     ("S1", "closes", ["p1"]),
     ("S1", "opens", ["x2"]),
     ("S2", "opens", ["p1"])]

def level30 : Level := compile raw30

/-- An optimal play of level 30: 114 moves. -/
def sol30 : List Move := parseMoves "DRDDRRURRDRRRRUDLLLLULLLDDLURRRRRUURURRRURDDDLLDLDRUURDLDLLLLULLDLLULDLURUDLDRURDRRULDDLURRRRRRRULUUURRRURULLLLLDL"

/-- Level 31 of the game (`src/main/resources/level31.txt`). -/
def raw31 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p", "x1"],
     ["x", "p", "p", "p", "x", "x", "x", "x", "S1", "x", "x", "p", "e", "p", "x1"],
     ["x", "p", "p", "p", "p3", "p3", "p", "p", "p", "x3", "x3", "p", "p", "p", "x1"],
     ["x", "p", "p", "p", "x", "x", "p", "p", "p", "x", "x", "x", "p", "x", "x"],
     ["x", "w", "w", "w", "x", "x", "W1", "p", "p", "x", "x", "x", "w", "x", "x"],
     ["x", "x", "w", "x", "x", "x", "p", "p", "p", "x", "x", "w", "w", "w", "x"],
     ["x", "x", "p", "x", "x", "x", "p", "p", "p", "x", "x", "p", "p", "p", "x"],
     ["p2", "p", "p", "p", "x2", "x2", "p", "W2", "p", "p1", "p1", "p", "s", "p", "x"],
     ["p2", "p", "S2", "p", "x", "x", "S3", "x", "x", "x", "x", "p", "p", "p", "x"],
     ["p2", "p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x"]]
  rules :=
    [("W2", "closes", ["p1", "x2", "p3", "x3"]),
     ("W1", "closes", ["p1", "x2", "p3", "x3"]),
     ("S1", "toggles", ["x3"]),
     ("S3", "toggles", ["x2"]),
     ("S2", "opens", ["x1"]),
     ("S2", "closes", ["p3"])]

def level31 : Level := compile raw31

/-- An optimal play of level 31: 91 moves. -/
def sol31 : List Move := parseMoves "ULDLLUUUUDDDDRRRULDRUUUULURDDLURDLLLDDDLDDUURUUULLLLDRULDDDDDLURLURDRURRURRDRRRULDRUUUUURDL"

/-- Level 32 of the game (`src/main/resources/level32.txt`). -/
def raw32 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "S1"],
     ["x", "x", "p", "p", "p1", "p1", "p", "p", "x", "x", "x", "p", "p", "p"],
     ["x", "p", "p", "p", "x3", "x3", "p", "p", "x", "x", "p", "S2", "p", "p"],
     ["x", "p", "e", "p", "x", "x", "x", "p", "p", "p", "p", "p", "x", "x"],
     ["x", "p", "p", "p", "x", "x", "x", "x", "p", "p", "p", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "x", "x", "x"],
     ["x", "x", "x", "x", "p", "p", "p", "x", "x", "p", "s", "x", "x", "x"],
     ["p", "p", "x1", "x1", "p", "S3", "p", "x", "x", "p", "p", "x", "x", "x"],
     ["p", "p", "x2", "x2", "p", "p", "p", "p", "p", "p", "p", "x", "x", "x"]]
  rules :=
    [("S1", "toggles", ["p1", "x1"]),
     ("S2", "toggles", ["x2"]),
     ("S3", "toggles", ["x3"])]

def level32 : Level := compile raw32

/-- An optimal play of level 32: 129 moves. -/
def sol32 : List Move := parseMoves "UULDRURURDLRULDLDLURDLURURURDLLDDDLDLLULDRRRUUUUURURRUDLLDLDDDDDLLLLURLDRRRRUUUUURURRUDLLDLDDDDDLLLURDRRUUURURRULDLDLDRULLULLLLLD"

/-- Level 33 of the game (`src/main/resources/level33.txt`). -/
def raw33 : RawLevel where
  rows :=
    [["x", "x", "x", "x", "x", "p", "p", "W1", "p", "p", "p", "x", "x", "x", "x"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "p", "x1", "x", "x", "x"],
     ["p", "p", "p", "x", "x", "W2", "p", "p", "W3", "p", "p", "p", "p", "p", "x"],
     ["p", "s", "p", "p1", "p1", "p", "p", "p", "p", "W4", "W5", "p", "p", "W6", "x"],
     ["x", "x", "x", "x", "x", "p", "p", "W7", "p", "p", "W8", "p", "p", "p", "x"],
     ["x", "x", "x", "x", "x", "p", "p", "p", "p", "p", "p", "W9", "p", "p", "x"],
     ["p", "p", "p", "x", "x", "p", "p", "p", "p", "p", "p", "Wa", "p", "p", "p"],
     ["p", "e", "p", "p2", "p2", "p", "Wc", "p", "x", "x", "p", "p", "p", "Wb", "S1"],
     ["p", "p", "p", "x", "x", "p", "p", "p", "x", "x", "x", "p", "p", "p", "p"],
     ["p", "p", "p", "x", "x", "x", "x", "x", "x", "x", "x", "x", "p", "p", "p"]]
  rules :=
    [("S1", "opens", ["x1"]),
     ("W1", "closes", ["p2"]),
     ("W2", "closes", ["p2"]),
     ("W3", "closes", ["p2"]),
     ("W4", "closes", ["p2"]),
     ("W5", "closes", ["p2"]),
     ("W6", "closes", ["p2"]),
     ("W7", "closes", ["p2"]),
     ("W8", "closes", ["p2"]),
     ("W9", "closes", ["p2"]),
     ("Wa", "closes", ["p2"]),
     ("Wb", "closes", ["p2"]),
     ("Wc", "closes", ["p2"])]

def level33 : Level := compile raw33

/-- An optimal play of level 33: 65 moves. -/
def sol33 : List Move := parseMoves "RRRRULDDLURUURRDRDRULLURDRDDRDLDDRRUDLLUURULUULULDRULLLDDDLDLLDLU"

/-- The 33 levels. -/
def levels : List Level :=
  [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, level11, level12, level13, level14, level15, level16, level17, level18, level19, level20, level21, level22, level23, level24, level25, level26, level27, level28, level29, level30, level31, level32, level33]

/-- The optimal plays. -/
def sols : List (List Move) :=
  [sol1, sol2, sol3, sol4, sol5, sol6, sol7, sol8, sol9, sol10, sol11, sol12, sol13, sol14, sol15, sol16, sol17, sol18, sol19, sol20, sol21, sol22, sol23, sol24, sol25, sol26, sol27, sol28, sol29, sol30, sol31, sol32, sol33]

/-- The optimal number of moves for each level. -/
def opts : List Nat :=
  [7, 17, 19, 28, 33, 35, 44, 10, 24, 57, 47, 65, 46, 67, 57, 28, 106, 85, 67, 56, 72, 65, 75, 57, 55, 104, 71, 100, 104, 114, 91, 129, 65]

end Blox
