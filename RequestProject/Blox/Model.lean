import Mathlib

/-!
# A formal model of the Bloxorz puzzle levels of this project

This file formalises the game semantics that the Java solver in `src/main/java`
implements, for the level descriptions stored in `src/main/resources/level<n>.txt`.

A level is a rectangular grid of tiles.  The player controls a `1 x 1 x 2` block,
which starts standing on the start tile and has to end up standing on the goal
tile.  A move tips the block over one of its edges (`U`, `D`, `L`, `R`).  A move
is illegal if any tile the block would come to rest on is missing (or lies
outside the grid), and also if the block would stand on its end on a *weak*
tile.

Tiles can carry switches.  A *weak* switch (`W` in the level files) fires
whenever the moving piece comes to rest on it; a *strong* switch (`S`) fires
only when the full block comes to rest standing on it.  A switch fires a list of
rules which `toggle`, `close` or `open` a set of tiles.

A *teleport* tile (`t`) splits the block into two `1 x 1 x 1` half blocks placed
on the two tiles named by its rule.  From then on the player moves one half
block at a time and can switch (`swap`) between them; when the two halves come
to rest next to each other they merge back into one full block.  Only full
blocks standing on their end can fall through teleports, break weak tiles or
fire strong switches.

The cost of a play is the number of directional moves `U`,`D`,`L`,`R` it uses;
switching between the two half blocks is free.  This is the convention used for
the move counts quoted in the project `README.md`.
-/

namespace Blox

/-- Tile kinds, mirroring the symbols used in the level files. -/
inductive TType
  | plain | start | weak | missing | teleport | strongSwitch | weakSwitch | goal | landing
  deriving DecidableEq, Repr, Inhabited

/-- The four directions a block can be tipped in. -/
inductive Dir | U | D | L | R
  deriving DecidableEq, Repr, Inhabited, Hashable

/-- A player input: either tip the active block in a direction, or (when the block
is split in two halves) switch which half is active. -/
inductive Move | go (d : Dir) | swap
  deriving DecidableEq, Repr, Inhabited, Hashable

/-- Orientation of the full block: lying along the x axis, lying along the y axis,
or standing on its end. -/
inductive Orient | horiz | vert | stand
  deriving DecidableEq, Repr, Inhabited, Hashable

/-- The piece(s) under the player's control.  `big o x y` is the full block, `split`
is the pair of half blocks, ordered lexicographically, with `second` saying which
one is currently active. -/
inductive Blocks
  | big (o : Orient) (x y : Int)
  | split (x1 y1 x2 y2 : Int) (second : Bool)
  deriving DecidableEq, Repr, Inhabited, Hashable

/-- A game state: the piece(s), together with the current open/closed configuration
of the switchable tiles, encoded as a bit mask. -/
structure St where
  b : Blocks
  cfg : Nat
  deriving DecidableEq, Repr, Inhabited, Hashable

instance : BEq St := ⟨fun a b => decide (a = b)⟩

instance : LawfulBEq St where
  eq_of_beq h := of_decide_eq_true h
  rfl := by intro a; simp [BEq.beq]

/-- A compiled level.  Cell `(x,y)` (with `y` counted from the bottom row of the
level file) has index `x * height + y`. -/
structure Level where
  width : Nat
  height : Nat
  /-- static tile kind of every cell -/
  tile : Array TType
  /-- `0` if the cell is never opened/closed, otherwise `b+1` where `b` is the bit
  of the configuration mask that describes the cell -/
  mutBit : Array Nat
  /-- for each cell, the list of effects of the switch on it (in level-file order),
  each being an action code (`0` toggle, `1` close, `2` open) and a bit mask -/
  eff : Array (List (Nat × Nat))
  /-- for each teleport cell, the two cells the halves of the block land on -/
  tel : Array (List (Int × Int))
  sx : Int
  sy : Int
  ex : Int
  ey : Int
  initCfg : Nat
  fullMask : Nat
  deriving Inhabited

/-! ### Geometry -/

/-- The cells occupied by a full block. -/
def bigCells : Orient → Int → Int → List (Int × Int)
  | .stand, x, y => [(x, y)]
  | .horiz, x, y => [(x, y), (x + 1, y)]
  | .vert,  x, y => [(x, y), (x, y + 1)]

/-- Tipping the full block: new orientation and new anchor cell. -/
def bigMove (o : Orient) (x y : Int) : Dir → Orient × Int × Int
  | .U => match o with
      | .horiz => (.horiz, x, y + 1)
      | .vert  => (.stand, x, y + 2)
      | .stand => (.vert,  x, y + 1)
  | .D => match o with
      | .horiz => (.horiz, x, y - 1)
      | .vert  => (.stand, x, y - 1)
      | .stand => (.vert,  x, y - 2)
  | .L => match o with
      | .horiz => (.stand, x - 1, y)
      | .vert  => (.vert,  x - 1, y)
      | .stand => (.horiz, x - 2, y)
  | .R => match o with
      | .horiz => (.stand, x + 2, y)
      | .vert  => (.vert,  x + 1, y)
      | .stand => (.horiz, x + 1, y)

/-- Displacement of a half block. -/
def dirDelta : Dir → Int × Int
  | .U => (0, 1)
  | .D => (0, -1)
  | .L => (-1, 0)
  | .R => (1, 0)

/-- Lexicographic order on cells. -/
def ltPos (a b : Int × Int) : Bool := a.1 < b.1 || (a.1 = b.1 && a.2 < b.2)

/-- Assemble the piece(s) from the two half-block positions `a` (the one that just
moved, hence the active one) and `b`; adjacent halves merge into a full block. -/
def mkBlocks (a b : Int × Int) : Blocks :=
  let p := if ltPos a b then a else b
  let q := if ltPos a b then b else a
  if q.1 - p.1 = 1 ∧ p.2 = q.2 then .big .horiz p.1 p.2
  else if p.1 = q.1 ∧ q.2 - p.2 = 1 then .big .vert p.1 p.2
  else .split p.1 p.2 q.1 q.2 (!ltPos a b)

/-! ### Tiles and switches -/

def cellIdx (L : Level) (x y : Int) : Option Nat :=
  if 0 ≤ x ∧ x < (L.width : Int) ∧ 0 ≤ y ∧ y < (L.height : Int) then
    some (x.toNat * L.height + y.toNat)
  else none

/-- The kind of the tile at `(x,y)` in configuration `cfg`; everything outside the
grid counts as missing. -/
def typeAt (L : Level) (cfg : Nat) (x y : Int) : TType :=
  match cellIdx L x y with
  | none => .missing
  | some i =>
    match L.mutBit[i]! with
    | 0 => L.tile[i]!
    | b + 1 => if Nat.testBit cfg b then .plain else .missing

/-- Can the piece come to rest on this cell?  `standing` says whether it is the full
block standing on its end (which breaks weak tiles). -/
def cellOk (L : Level) (cfg : Nat) (standing : Bool) (p : Int × Int) : Bool :=
  match typeAt L cfg p.1 p.2 with
  | .missing => false
  | .weak => !standing
  | _ => true

/-- Apply the effect of one switch rule to the configuration. -/
def applyEff (fullMask : Nat) (cfg : Nat) (ae : Nat × Nat) : Nat :=
  match ae.1 with
  | 0 => cfg ^^^ ae.2                 -- toggles
  | 1 => cfg &&& (fullMask ^^^ ae.2)  -- closes
  | _ => cfg ||| ae.2                 -- opens

/-- Fire all switches under the cells the piece has just come to rest on. -/
def fireSwitches (L : Level) (cfg : Nat) (standing : Bool) (cs : List (Int × Int)) : Nat :=
  cs.foldl
    (fun c p =>
      match cellIdx L p.1 p.2 with
      | none => c
      | some i =>
        if L.tile[i]! = TType.weakSwitch ∨ (L.tile[i]! = TType.strongSwitch ∧ standing = true) then
          (L.eff[i]!).foldl (applyEff L.fullMask) c
        else c)
    cfg

/-! ### The transition function -/

/-- One step of the game.  `none` means the input is not available in this state
(the block would fall off, or there is nothing to swap to). -/
def step (L : Level) (s : St) (m : Move) : Option St :=
  match m, s.b with
  | .swap, .big _ _ _ => none
  | .swap, .split x1 y1 x2 y2 sec => some { s with b := .split x1 y1 x2 y2 (!sec) }
  | .go d, .big o x y =>
      let r := bigMove o x y d
      let o' := r.1
      let x' := r.2.1
      let y' := r.2.2
      let cs := bigCells o' x' y'
      let standing := decide (o' = Orient.stand)
      if cs.all (cellOk L s.cfg standing) then
        let telCells : List (Int × Int) :=
          if standing then (match cellIdx L x' y' with | some i => L.tel[i]! | none => []) else []
        match telCells with
        | [a, b] => some { b := mkBlocks a b, cfg := fireSwitches L s.cfg false [a] }
        | _ => some { b := .big o' x' y', cfg := fireSwitches L s.cfg standing cs }
      else none
  | .go d, .split x1 y1 x2 y2 sec =>
      let active : Int × Int := if sec then (x2, y2) else (x1, y1)
      let other : Int × Int := if sec then (x1, y1) else (x2, y2)
      let dd := dirDelta d
      let np : Int × Int := (active.1 + dd.1, active.2 + dd.2)
      if np = other then none
      else if cellOk L s.cfg false np then
        some { b := mkBlocks np other, cfg := fireSwitches L s.cfg false [np] }
      else none

/-- The state the level starts in. -/
def initSt (L : Level) : St := { b := .big .stand L.sx L.sy, cfg := L.initCfg }

/-- The level is solved when the full block stands on the goal tile. -/
def isGoal (L : Level) (s : St) : Bool := s.b == Blocks.big .stand L.ex L.ey

/-- Run a list of inputs. -/
def run (L : Level) (s : St) : List Move → Option St
  | [] => some s
  | m :: ms =>
    match step L s m with
    | none => none
    | some s' => run L s' ms

/-- The number of directional moves in a play (swaps are free). -/
def cost : List Move → Nat
  | [] => 0
  | .go _ :: ms => cost ms + 1
  | .swap :: ms => cost ms

/-- `ms` is a winning play for the level `L`. -/
def Solves (L : Level) (ms : List Move) : Prop :=
  ∃ s, run L (initSt L) ms = some s ∧ isGoal L s = true

/-- Boolean version of `Solves`. -/
def solvesB (L : Level) (ms : List Move) : Bool :=
  match run L (initSt L) ms with
  | none => false
  | some s => isGoal L s

theorem solves_of_solvesB {L : Level} {ms : List Move} (h : solvesB L ms = true) :
    Solves L ms := by
  unfold solvesB at h
  cases hr : run L (initSt L) ms with
  | none => rw [hr] at h; exact absurd h (by simp)
  | some s => exact ⟨s, hr, by rw [hr] at h; exact h⟩

/-- `n` is the optimal number of moves for the level `L`: it is achievable, and no
winning play uses fewer moves. -/
def MinCost (L : Level) (n : Nat) : Prop :=
  (∃ ms, Solves L ms ∧ cost ms = n) ∧ ∀ ms, Solves L ms → n ≤ cost ms

end Blox
