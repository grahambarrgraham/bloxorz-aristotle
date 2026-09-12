import RequestProject.Blox.Data
import RequestProject.Blox.Search

/-!
# Validating the model against published solutions

The plays below are the walkthrough of `src/main/resources/postedSolution.txt`
and the two sequences quoted in the `README.md`, transcribed move by move.

Switching between the two half blocks is free and can be done at any time, so a
published sequence only prescribes the directional moves; `solvesDirs` below
asks whether a sequence of directional moves can be played (with the free
switches inserted wherever needed) so as to win the level.

Checking the walkthrough against the model is independent evidence that the
formal semantics of `Model.lean` agrees with the game: 31 of the 33 walkthrough
plays win their level in the model.  The two that do not are the ones recorded
for level 21 and level 24, where the block would have to roll onto a tile that
is missing in the level description.

The `README.md` quotes a 57-move play of level 15 and a 71-move play of level 21,
which together with the solver's own results would give a total of 1999 moves.
The 57-move play of level 15 is legal (and optimal, see `Optimal.lean`), but the
71-move sequence for level 21 is not a legal play: its first 58 moves are fine,
the 59th would roll the block onto a missing tile.  The optimum of level 21 is
72 moves, which is why the true optimum for the whole game is 2000, not 1999.
-/

namespace Blox

/-- The states reachable from `s` using only free switches. -/
def swapClosure (L : Level) (s : St) : List St :=
  match step L s .swap with
  | none => [s]
  | some t => [s, t]

/-- Play a sequence of directional moves, allowing free switches between the two
half blocks at any point. -/
def runDirs (L : Level) (ss : List St) : List Dir → List St
  | [] => ss
  | d :: ds =>
    runDirs L ((ss.flatMap (fun s =>
      match step L s (.go d) with
      | none => []
      | some t => swapClosure L t)).dedup) ds

/-- Can this sequence of directional moves be played at all? -/
def dirsPlayable (L : Level) (ds : List Dir) : Bool :=
  !(runDirs L (swapClosure L (initSt L)) ds).isEmpty

/-- Does this sequence of directional moves win the level? -/
def solvesDirs (L : Level) (ds : List Dir) : Bool :=
  (runDirs L (swapClosure L (initSt L)) ds).any (isGoal L)

/-- The directional moves of a play. -/
def dirsOf (ms : List Move) : List Dir :=
  ms.filterMap (fun m => match m with | .go d => some d | .swap => none)

def posted1 : List Move := parseMoves "RRDRRRD"
def posted2 : List Move := parseMoves "URDRRRUUURDDRRRRULU"
def posted3 : List Move := parseMoves "RURRRULDRUURRRDDDRU"
def posted4 : List Move := parseMoves "ULURRURRRRRRDRDDDDDRULLLLLLD"
def posted5 : List Move := parseMoves "LLLRLLLLLDRDDRRRRDRRRRLLLLDLLLLLL"
def posted6 : List Move := parseMoves "RRRDDRDDRDRULLLUULUUURRRDDRDRDRUULDRULDR"
def posted7 : List Move := parseMoves "DLURRRRRDRLULLLLLDRDRDRRRUURDLURUURRRDRDRDLU"
def posted8 : List Move := parseMoves "RRDDDRRSUUURR"
def posted9 : List Move := parseMoves "RDRRRRRRURDLLLLLUSDRRRRRD"
def posted10 : List Move := parseMoves "RRLDDDRDDDDDLLLLULLLDURRRDRRRUSRRDDDRDDDLDURUUULUURSRRLLLLLLL"
def posted11 : List Move := parseMoves "RRRRULDDDRRRRUULUULLLDRURRDRULLLDDLLLUURUULDRURDL"
def posted12 : List Move := parseMoves "LDRURURURULDRURRRDDLDRULDRULDLURUUULLLRRRDDDLDRUURDLDRUUURUDLDDDLURUULLLULDRRULDDDL"
def posted13 : List Move := parseMoves "ULDRDLURRDLUUUULLLLLLLDDDRULDRDDRDDRULLDRUULDRURRUU"
def posted14 : List Move := parseMoves "RRRUURDLLURDDRRDDDDLLLDRURRUUDDLLDRDRRLLULLURRRUUUULLLLLLURDLLLLLDDDRDR"
def posted15 : List Move := parseMoves "RRRRUUSUUUUURRRUURRRRDDUURRSLLRLLLURDLLURDLLLDLLLDDDDLURDRRRRRRR"
def posted16 : List Move := parseMoves "RRRRSRDSRUSRLLLSRRRSRRRRRLLLLRRRRRRRRSDRRRRRRRRR"
def posted17 : List Move := parseMoves "DDDDDLURRRRRURRRLLLDLLLLUUUUUURRRRDRRRRULDRRULDDRULDURDLUURDLLURDLLLLULLLLDDDDDDRRRRURRRDDULULLLDLLLULUUURRRRRDRRR"
def posted18 : List Move := parseMoves "RDLURRDLURRRUUDDLLLDRULLDRURRRDDUULLLDLURRDLUURDLULLDDDDRRLLUUUURRDRULDDRULDRURRRRRDDDRULDDRULDLUR"
def posted19 : List Move := parseMoves "RRRRRRRRDRULLLLLLDRURRRRRDDDDDLLLLLDLURRRRRRULDLLLLLDDDDRRRLLLLLLUU"
def posted20 : List Move := parseMoves "DLDRDLUURUULLLLDDRULLDDDLDURUURUURRRDDDLUSLUDRSLLLLLDDDDDRRRRRD"
def posted21 : List Move := parseMoves "RDLULDRURRURRRULDDDUUURDLLLDLLDLURDRULDRULDRDDRDDRRRUUDDLLULDRRRUUUURRR"
def posted22 : List Move := parseMoves "RULDLURRRURRDRDRRULDLULDRRDDDLDURUUULLURDRDRULLLULLLDLDLLURDDLURRDLUURDLURDLDDDRDULUUURULDLURRRURRDRRDDLURRRU"
def posted23 : List Move := parseMoves "DLURDDRURRRRRRULDRLLLUUUUURRRRUDLLLLLLDDDDLLLLLLLUUURRUDLURDDRDDDRRRRRRRRULDRLLLLUUUSDRRDDDRRRRUU"
def posted24 : List Move := parseMoves "DDRRUURURRRRURDLLURDLRULDLURDLLLLDLLLDLDRDLUUDDRULURURRRURRRRULDRURDLLLLLLDRLURRRRRRULDLURDRSDSRDLRURRR"
def posted25 : List Move := parseMoves "URDLURDLLURRRRUULLURLDRRDDLLLLDRRURRRUURRRULDRUULDRURDL"
def posted26 : List Move := parseMoves "UULLLDLLLDRURRUURRDRRDRRUULLULLLLLLDLLLDDDSUUULLLLLLDLLLDDDUURULDRURRUURRDRRDRRUULLULLLLDDDDDRRRSUUULLLLDDDDDRRL"
def posted27 : List Move := parseMoves "RRRRRULDRURDLLLLLLURDLLURDRRRRURRRRDDDLDDDLLLDLUUUURDLLLLLLLULDDRULDRUL"
def posted28 : List Move := parseMoves "LDDDRDLURDDRRDDRRRUUULULULULDRRDRDRDRRDLDLLUUULULULLULLDLURRRDRDRDRDRLLLLDDDLLLLLUULLLDSLLLLLLLUULLLU"
def posted29 : List Move := parseMoves "LDRURRDLURDDRRLLUULDRULDLULUULLRRDDRDRURDLURUURRLLDDDDDDRRLLUUUULDLULDRURRRRRLLLLLDRULLDRULLLLLRRRRRULDLDDDLLLURDLLURDDLURDRUL"
def posted30 : List Move := parseMoves "DRDDRRURRDRRRRUDLLLLULLLDDLURRRRRRUUURRRURDDDLLDLDRUURDLDLLLLULLDLLULDLURUDLDRURDRRULDDLURRRRRRRULUUURRRURULLLLLDL"
def posted31 : List Move := parseMoves "ULDLLUUUUDDDDRRRULDRUUUURULDDLLLLLLDLURRDLURRRRDDDLDDUURUUULLLLURDLLURDDLURDDDDLDRUULDRULDRLDRULDRUULDLURRRRURRDRRRULDRUUUUURDL"
def posted32 : List Move := parseMoves "UULDRURURDLRULDLDLURDLURURURDLLDDDDLLLLURDRRRUUUUURURRUDLLDLDDDDDLLLLURLDRRRRUUUUURURRUDLLDLDDDDDLLLULDRRRRUUUURRULDLDLDRULLULLLLLD"
def posted33 : List Move := parseMoves "RRRRULDDDRRULULUURRDRDRULLURDRDDRDLDDRRUDLLUUUULULDRDRULULLLDDDLDLLDLU"


/-- The walkthrough plays, in level order. -/
def postedPlays : List (List Move) :=
  [posted1, posted2, posted3, posted4, posted5, posted6, posted7, posted8, posted9, posted10, posted11, posted12, posted13, posted14, posted15, posted16, posted17, posted18, posted19, posted20, posted21, posted22, posted23, posted24, posted25, posted26, posted27, posted28, posted29, posted30, posted31, posted32, posted33]

/-- Which of the walkthrough plays win their level in the model: all of them
except the ones recorded for level 21 and level 24. -/
theorem postedPlays_results :
    (List.range 33).map
        (fun i => solvesDirs (levels.getD i default) (dirsOf (postedPlays.getD i [])))
      = [true, true, true, true, true, true, true, true, true, true,
         true, true, true, true, true, true, true, true, true, true,
         false, true, true, false, true, true, true, true, true, true,
         true, true, true] := by
  native_decide


/-- The 57-move play of level 15 quoted in the `README.md`. -/
def readme15 : List Move := parseMoves "RRRRUUSUUUUURRRUURRRRDDSLLLLSUDULULLLDSLLLLLDLLDDDLDRURRRRRRR"

/-- The 71-move sequence for level 21 quoted in the `README.md`. -/
def readme21 : List Move := parseMoves "RDLULDRURRURRRULDDDUUURDLLLDLLDLURDRULDRULDRDDRDDRRRUUDDLLULDRRRUUUURRR"

/-- The level 15 sequence from the `README.md` wins level 15 and uses 57 moves. -/
theorem readme15_solves : solvesDirs level15 (dirsOf readme15) = true := by native_decide

theorem readme15_length : (dirsOf readme15).length = 57 := by native_decide

/-- The level 21 sequence from the `README.md` uses 71 moves ... -/
theorem readme21_length : (dirsOf readme21).length = 71 := by native_decide

/-- ... but it cannot be played on level 21: its first 58 moves are legal, the
59th is not. -/
theorem readme21_fails_at_59 :
    dirsPlayable level21 ((dirsOf readme21).take 58) = true ∧
    dirsPlayable level21 ((dirsOf readme21).take 59) = false := by
  native_decide

end Blox
