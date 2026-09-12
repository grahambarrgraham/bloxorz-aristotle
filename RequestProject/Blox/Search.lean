import RequestProject.Blox.Model

/-!
# Certified lower bounds on the number of moves

To prove that a level needs at least `n` moves we exhibit a *certificate*: a
finite map `f` from states to numbers such that

* the initial state has `f = 0`;
* no state in the domain of `f` is a winning state;
* free swaps do not leave the domain and do not increase the value;
* a directional move from a state of value `k < n - 1` lands in the domain with
  value at most `k + 1`.

Any play of cost `< n` would then end in the domain of `f`, hence not at the
goal.  The certificate itself is produced by a breadth-first search (`bfs`), but
nothing in the proof depends on that search being correct: the certificate is
checked by `checkCert`.
-/

namespace Blox

def allDirs : List Dir := [.U, .D, .L, .R]

/-! ### Computing a certificate by breadth-first search -/

/-- Insert the given states (and the states reachable from them by a free swap)
into the table with value `k`, returning the newly inserted ones. -/
def expand (L : Level) (k : Nat) (T : Std.HashMap St Nat) (front : List St) :
    Std.HashMap St Nat × List St := Id.run do
  let mut T := T
  let mut out : List St := []
  for s in front do
    if !T.contains s then
      T := T.insert s k
      out := s :: out
    match step L s .swap with
    | none => pure ()
    | some s' =>
      if !T.contains s' then
        T := T.insert s' k
        out := s' :: out
  return (T, out)

def bfsAux (L : Level) : Nat → Nat → Std.HashMap St Nat → List St → Std.HashMap St Nat
  | 0, _, T, _ => T
  | fuel + 1, k, T, front =>
    if front.isEmpty then T
    else
      let nexts := front.flatMap (fun s => allDirs.filterMap (fun d => step L s (.go d)))
      let r := expand L (k + 1) T nexts
      bfsAux L fuel (k + 1) r.1 r.2

/-- All states reachable with at most `depth` directional moves, tagged with the
number of moves needed to reach them. -/
def bfs (L : Level) (depth : Nat) : Std.HashMap St Nat :=
  let r := expand L 0 {} [initSt L]
  bfsAux L depth 0 r.1 r.2

/-! ### Checking a certificate -/

def okAt (L : Level) (n : Nat) (T : Std.HashMap St Nat) (p : St × Nat) : Bool :=
  (isGoal L p.1 == false) &&
  (match step L p.1 .swap with
   | none => true
   | some t => match T[t]? with
               | none => false
               | some k' => decide (k' ≤ p.2)) &&
  ((decide (p.2 + 1 < n) == false) ||
    allDirs.all (fun d =>
      match step L p.1 (.go d) with
      | none => true
      | some t => match T[t]? with
                  | none => false
                  | some k' => decide (k' ≤ p.2 + 1)))

/-- The certificate check. -/
def checkCert (L : Level) (n : Nat) (T : Std.HashMap St Nat) : Bool :=
  (T[initSt L]? == some 0) && T.toList.all (okAt L n T)

/-! ### Soundness -/

/-- The properties of a certificate for "at least `n` moves are needed". -/
structure CertValid (L : Level) (n : Nat) (f : St → Option Nat) : Prop where
  init : f (initSt L) = some 0
  notGoal : ∀ s k, f s = some k → isGoal L s = false
  swap : ∀ s k s', f s = some k → step L s .swap = some s' → ∃ k', f s' = some k' ∧ k' ≤ k
  go : ∀ s k d s', f s = some k → k + 1 < n → step L s (.go d) = some s' →
        ∃ k', f s' = some k' ∧ k' ≤ k + 1

theorem certValid_of_check (L : Level) (n : Nat) (T : Std.HashMap St Nat)
    (h : checkCert L n T = true) : CertValid L n (fun s => T[s]?) := by
  rw [checkCert, Bool.and_eq_true] at h
  obtain ⟨hinit, hall⟩ := h
  have hmem : ∀ s k, T[s]? = some k → okAt L n T (s, k) = true := by
    intro s k hsk
    have : (s, k) ∈ T.toList := Std.HashMap.mem_toList_iff_getElem?_eq_some.2 hsk
    exact List.all_eq_true.1 hall _ this
  refine ⟨eq_of_beq hinit, ?_, ?_, ?_⟩
  · intro s k hsk
    have := hmem s k hsk
    rw [okAt, Bool.and_eq_true, Bool.and_eq_true] at this
    exact eq_of_beq this.1.1
  · intro s k s' hsk hstep
    have := hmem s k hsk
    rw [okAt, Bool.and_eq_true, Bool.and_eq_true] at this
    have h2 := this.1.2
    simp only [hstep] at h2
    cases hk : T[s']? with
    | none => simp only [hk] at h2; exact absurd h2 (by simp)
    | some k' => exact ⟨k', rfl, by simp only [hk] at h2; exact of_decide_eq_true h2⟩
  · intro s k d s' hsk hlt hstep
    have := hmem s k hsk
    rw [okAt, Bool.and_eq_true] at this
    have h2 := this.2
    rw [show (decide (k + 1 < n) == false) = false by simp [hlt]] at h2
    have h3 : allDirs.all (fun d =>
        match step L (s, k).1 (.go d) with
        | none => true
        | some t => match T[t]? with
                    | none => false
                    | some k' => decide (k' ≤ (s, k).2 + 1)) = true := by
      simpa using h2
    have h4 := List.all_eq_true.1 h3 d (by cases d <;> simp [allDirs])
    simp only [hstep] at h4
    cases hk : T[s']? with
    | none => simp only [hk] at h4; exact absurd h4 (by simp)
    | some k' => exact ⟨k', rfl, by simp only [hk] at h4; exact of_decide_eq_true h4⟩

theorem cert_run {L : Level} {n : Nat} {f : St → Option Nat} (h : CertValid L n f) :
    ∀ (ms : List Move) (s : St) (k : Nat) (s' : St), f s = some k →
      run L s ms = some s' → k + cost ms < n → ∃ k', f s' = some k' ∧ k' ≤ k + cost ms := by
  intro ms
  induction ms with
  | nil =>
    intro s k s' hs hrun _
    rw [run] at hrun
    cases hrun
    exact ⟨k, hs, by simp [cost]⟩
  | cons m ms ih =>
    intro s k s' hs hrun hlt
    rw [run] at hrun
    cases hstep : step L s m with
    | none => rw [hstep] at hrun; exact absurd hrun (by simp)
    | some s1 =>
      rw [hstep] at hrun
      cases m with
      | swap =>
        obtain ⟨k1, hk1, hle1⟩ := h.swap s k s1 hs hstep
        have hcost : cost (Move.swap :: ms) = cost ms := by simp [cost]
        rw [hcost] at hlt ⊢
        obtain ⟨k', hk', hle'⟩ := ih s1 k1 s' hk1 hrun (by omega)
        exact ⟨k', hk', by omega⟩
      | go d =>
        have hcost : cost (Move.go d :: ms) = cost ms + 1 := by simp [cost]
        rw [hcost] at hlt ⊢
        obtain ⟨k1, hk1, hle1⟩ := h.go s k d s1 hs (by omega) hstep
        obtain ⟨k', hk', hle'⟩ := ih s1 k1 s' hk1 hrun (by omega)
        exact ⟨k', hk', by omega⟩

theorem lower_bound {L : Level} {n : Nat} {f : St → Option Nat} (h : CertValid L n f)
    {ms : List Move} (hs : Solves L ms) : n ≤ cost ms := by
  by_contra hlt
  push_neg at hlt
  obtain ⟨s', hrun, hgoal⟩ := hs
  obtain ⟨k', hk', _⟩ := cert_run h ms (initSt L) 0 s' h.init hrun (by omega)
  have := h.notGoal s' k' hk'
  rw [this] at hgoal
  exact absurd hgoal (by simp)

/-- The main tool: a checked witness plus a checked certificate give optimality. -/
theorem minCost_of (L : Level) (n : Nat) (ms : List Move) (T : Std.HashMap St Nat)
    (h1 : solvesB L ms = true) (h2 : cost ms = n) (h3 : checkCert L n T = true) :
    MinCost L n :=
  ⟨⟨ms, solves_of_solvesB h1, h2⟩,
   fun _ hs => lower_bound (certValid_of_check L n T h3) hs⟩

/-- Everything that has to be checked to know that `n` moves are optimal for `L`,
with `ms` as the witnessing play: `ms` wins, it costs `n`, and the table produced
by the breadth-first search to depth `n-1` is a valid certificate. -/
def verified (L : Level) (n : Nat) (ms : List Move) : Bool :=
  solvesB L ms && (cost ms == n) && checkCert L n (bfs L (n - 1))

theorem minCost_of_verified (L : Level) (n : Nat) (ms : List Move) (h : verified L n ms = true) :
    MinCost L n := by
  rw [verified, Bool.and_eq_true, Bool.and_eq_true] at h
  exact minCost_of L n ms (bfs L (n - 1)) h.1.1 (eq_of_beq h.1.2) h.2

theorem solves_of_verified {L : Level} {n : Nat} {ms : List Move} (h : verified L n ms = true) :
    Solves L ms := by
  rw [verified, Bool.and_eq_true, Bool.and_eq_true] at h
  exact solves_of_solvesB h.1.1

theorem cost_of_verified {L : Level} {n : Nat} {ms : List Move} (h : verified L n ms = true) :
    cost ms = n := by
  rw [verified, Bool.and_eq_true, Bool.and_eq_true] at h
  exact eq_of_beq h.1.2

end Blox
