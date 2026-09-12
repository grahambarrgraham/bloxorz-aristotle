import RequestProject.Blox.Data
import RequestProject.Blox.Search

/-!
# The optimal number of moves for the 33 levels

For every level we exhibit a play of length `opts[i]` and a certificate showing
that no play is shorter, so `opts[i]` is the optimal number of moves.  Summing up,
the whole game needs exactly `2000` moves; in particular the `1999` moves quoted
in the project `README.md` are *not* achievable for these level descriptions.
-/

namespace Blox

open Finset

/-- The level with index `i`. -/
def levelOf (i : Fin 33) : Level := levels.getD i default

/-- The optimal play of the level with index `i` found by the search. -/
def solOf (i : Fin 33) : List Move := sols.getD i []

/-- The optimal number of moves of the level with index `i`. -/
def optOf (i : Fin 33) : Nat := opts.getD i 0

/-- All 33 levels pass the check: the recorded play wins the level, has the
recorded length, and the breadth-first search certificate rules out any shorter
play. -/
theorem all_verified :
    (List.range 33).all (fun i => verified (levels.getD i default) (opts.getD i 0)
      (sols.getD i [])) = true := by
  native_decide

theorem verified_levelOf (i : Fin 33) : verified (levelOf i) (optOf i) (solOf i) = true :=
  List.all_eq_true.1 all_verified (i : Nat) (List.mem_range.2 i.isLt)

/-- For every level, the recorded number of moves is optimal. -/
theorem minCost_levelOf (i : Fin 33) : MinCost (levelOf i) (optOf i) :=
  minCost_of_verified _ _ (solOf i) (verified_levelOf i)

/-- The recorded play of each level wins it. -/
theorem solves_solOf (i : Fin 33) : Solves (levelOf i) (solOf i) :=
  solves_of_verified (verified_levelOf i)

/-- The recorded play of each level has the optimal length. -/
theorem cost_solOf (i : Fin 33) : cost (solOf i) = optOf i :=
  cost_of_verified (verified_levelOf i)

/-! ### The optimum for each individual level -/

theorem optimal_level1 : MinCost level1 7 := minCost_levelOf 0
theorem optimal_level2 : MinCost level2 17 := minCost_levelOf 1
theorem optimal_level3 : MinCost level3 19 := minCost_levelOf 2
theorem optimal_level4 : MinCost level4 28 := minCost_levelOf 3
theorem optimal_level5 : MinCost level5 33 := minCost_levelOf 4
theorem optimal_level6 : MinCost level6 35 := minCost_levelOf 5
theorem optimal_level7 : MinCost level7 44 := minCost_levelOf 6
theorem optimal_level8 : MinCost level8 10 := minCost_levelOf 7
theorem optimal_level9 : MinCost level9 24 := minCost_levelOf 8
theorem optimal_level10 : MinCost level10 57 := minCost_levelOf 9
theorem optimal_level11 : MinCost level11 47 := minCost_levelOf 10
theorem optimal_level12 : MinCost level12 65 := minCost_levelOf 11
theorem optimal_level13 : MinCost level13 46 := minCost_levelOf 12
theorem optimal_level14 : MinCost level14 67 := minCost_levelOf 13
theorem optimal_level15 : MinCost level15 57 := minCost_levelOf 14
theorem optimal_level16 : MinCost level16 28 := minCost_levelOf 15
theorem optimal_level17 : MinCost level17 106 := minCost_levelOf 16
theorem optimal_level18 : MinCost level18 85 := minCost_levelOf 17
theorem optimal_level19 : MinCost level19 67 := minCost_levelOf 18
theorem optimal_level20 : MinCost level20 56 := minCost_levelOf 19
theorem optimal_level21 : MinCost level21 72 := minCost_levelOf 20
theorem optimal_level22 : MinCost level22 65 := minCost_levelOf 21
theorem optimal_level23 : MinCost level23 75 := minCost_levelOf 22
theorem optimal_level24 : MinCost level24 57 := minCost_levelOf 23
theorem optimal_level25 : MinCost level25 55 := minCost_levelOf 24
theorem optimal_level26 : MinCost level26 104 := minCost_levelOf 25
theorem optimal_level27 : MinCost level27 71 := minCost_levelOf 26
theorem optimal_level28 : MinCost level28 100 := minCost_levelOf 27
theorem optimal_level29 : MinCost level29 104 := minCost_levelOf 28
theorem optimal_level30 : MinCost level30 114 := minCost_levelOf 29
theorem optimal_level31 : MinCost level31 91 := minCost_levelOf 30
theorem optimal_level32 : MinCost level32 129 := minCost_levelOf 31
theorem optimal_level33 : MinCost level33 65 := minCost_levelOf 32

/-! ### The optimum for the whole game -/

theorem sum_optOf : ∑ i : Fin 33, optOf i = 2000 := by decide

/-- The total number of moves of a family of plays, one for each level. -/
def totalCost (sol : Fin 33 → List Move) : Nat := ∑ i, cost (sol i)

/-- The set of totals that can be achieved by playing all 33 levels. -/
def Achievable (N : Nat) : Prop :=
  ∃ sol : Fin 33 → List Move, (∀ i, Solves (levelOf i) (sol i)) ∧ totalCost sol = N

/-- **The whole game needs exactly 2000 moves.** -/
theorem min_total_moves : IsLeast Achievable 2000 := by
  constructor
  · refine ⟨solOf, solves_solOf, ?_⟩
    rw [totalCost, Finset.sum_congr rfl (fun i _ => cost_solOf i), sum_optOf]
  · rintro N ⟨sol, hsol, rfl⟩
    calc (2000 : Nat) = ∑ i : Fin 33, optOf i := sum_optOf.symm
      _ ≤ ∑ i : Fin 33, cost (sol i) :=
          Finset.sum_le_sum (fun i _ => (minCost_levelOf i).2 _ (hsol i))
      _ = totalCost sol := rfl

/-- In particular, the 1999 moves quoted in the project `README.md` cannot be
achieved. -/
theorem not_achievable_1999 : ¬ Achievable 1999 := by
  intro h
  have := min_total_moves.2 h
  omega

end Blox
