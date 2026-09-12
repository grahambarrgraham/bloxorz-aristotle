# Summary of changes for run 2321165d-e609-49a9-b927-ad40ac994295
I formalised the puzzle in Lean 4 and settled the question: for the level descriptions in `src/main/resources`, **1999 moves is not optimal — it is impossible. The true optimum for the whole game is 2000 moves.**

What is in the project now (all proofs machine-checked, no `sorry`, `lake build` clean):

- `RequestProject/Blox/Model.lean` — a formal model of the game matching the rules implemented by the Java solver: grid tiles, missing/weak tiles, weak and strong switches with toggle/close/open rules, teleport tiles that split the block into two half blocks which can be switched between for free and merge again when adjacent, and the winning condition (full block standing on the goal tile). A move is `U`/`D`/`L`/`R`; switching half blocks is free, the convention used for the README's move counts.
- `RequestProject/Blox/Compile.lean` and `Data.lean` — verbatim transcriptions of all 33 level files (I checked token-by-token against the `.txt` files) plus an explicit optimal play for each level.
- `RequestProject/Blox/Search.lean` — a breadth-first search together with a proved soundness theorem: the search output is re-checked as a certificate, so the lower bounds do not depend on the search being correct.
- `RequestProject/Blox/Optimal.lean` — `Blox.minCost_levelOf` (and `optimal_level1` … `optimal_level33`): for every level the exhibited play wins and no shorter play exists; `Blox.min_total_moves : IsLeast Achievable 2000`; and `Blox.not_achievable_1999 : ¬ Achievable 1999`.
- `RequestProject/Blox/Validation.lean` — evidence that the model is faithful: replaying the walkthrough of `postedSolution.txt` inside it wins 31 of the 33 levels (`Blox.postedPlays_results`).

Why the 1999 figure fails: it is the solver's 2002 minus 2 moves on level 15 and 1 move on level 21. The level 15 improvement is real — the 57-move sequence quoted in the README is legal and is exactly the optimum (the solver finds 59; this is the only level where it is not optimal). The level 21 sequence is not a legal play at all: its first 58 moves work, but the 59th would roll the block onto a missing tile (`Blox.readme21_fails_at_59`), and the level 21 optimum is 72, exactly what the solver already finds. Hence 2002 − 2 = 2000 is the best possible total.

I also updated `README.md` with a per-level table (solver vs. optimum) and added `OPTIMAL_SOLUTIONS.md` listing an optimal play for every level; `tools/` holds the scripts used to transcribe the level files and generate the witnesses.