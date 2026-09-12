import RequestProject.Blox.Model

/-!
# Compiling the level files into `Level`s

`RawLevel` is a verbatim transcription of a level file from
`src/main/resources`: the grid of tokens, row by row exactly as in the file,
together with the switch rules listed below the grid.  `compile` turns it into
the `Level` structure used by the game semantics, following `Scape.load` of the
Java program (in particular the grid is transposed, so that `x` is the column
index and `y` counts rows from the bottom).
-/

namespace Blox

/-- A verbatim transcription of a level file. -/
structure RawLevel where
  /-- the rows of the grid, top row first, as in the file -/
  rows : List (List String)
  /-- the rules, as (subject, action, objects) -/
  rules : List (String × String × List String)
  deriving Inhabited

def tokenType (t : String) : TType :=
  match t.front with
  | 'p' => .plain
  | 's' => .start
  | 'w' => .weak
  | 'x' => .missing
  | 't' => .teleport
  | 'S' => .strongSwitch
  | 'W' => .weakSwitch
  | 'e' => .goal
  | 'l' => .landing
  | _   => .missing

def tokenId (t : String) : Option String := if t.length > 1 then some t else none

/-- Compile a transcribed level file. -/
def compile (R : RawLevel) : Level := Id.run do
  let rows := (R.rows.map List.toArray).toArray
  let h := rows.size
  let w := if h = 0 then 0 else rows[0]!.size
  let tok : Nat → Nat → String := fun x y => (rows.getD (h - 1 - y) #[]).getD x ""
  let mut tile : Array TType := Array.replicate (w * h) TType.missing
  let mut ids : Array (Option String) := Array.replicate (w * h) none
  for x in [0:w] do
    for y in [0:h] do
      tile := tile.set! (x * h + y) (tokenType (tok x y))
      ids := ids.set! (x * h + y) (tokenId (tok x y))
  -- the cells each object id refers to (weak tiles and the goal tile carry no id)
  let mut objs : Std.HashMap String (List Nat) := {}
  for x in [0:w] do
    for y in [0:h] do
      let i := x * h + y
      match ids[i]! with
      | none => pure ()
      | some id =>
        match tile[i]! with
        | .weak | .goal => pure ()
        | _ => objs := objs.insert id ((objs.getD id []) ++ [i])
  -- the cells that can be opened and closed get a bit of the configuration mask
  let mut mutCells : List Nat := []
  for r in R.rules do
    if r.2.1 != "teleports" then
      for o in r.2.2 do
        for i in objs.getD o [] do
          if !(mutCells.contains i) then mutCells := mutCells ++ [i]
  let cells := mutCells.mergeSort (fun a b => a ≤ b)
  let nbits := cells.length
  let mut mutBit : Array Nat := Array.replicate (w * h) 0
  for j in [0:nbits] do
    mutBit := mutBit.set! (cells.getD j 0) (j + 1)
  let mut initCfg : Nat := 0
  for j in [0:nbits] do
    if tile.getD (cells.getD j 0) TType.missing != TType.missing then
      initCfg := initCfg ||| (1 <<< j)
  let fullMask : Nat := (1 <<< nbits) - 1
  let maskOf : List String → Nat := fun objIds => Id.run do
    let mut m : Nat := 0
    for o in objIds do
      for i in objs.getD o [] do
        match mutBit[i]! with
        | 0 => pure ()
        | b + 1 => m := m ||| (1 <<< b)
    return m
  -- switch effects and teleport destinations
  let mut eff : Array (List (Nat × Nat)) := Array.replicate (w * h) []
  let mut tel : Array (List (Int × Int)) := Array.replicate (w * h) []
  for i in [0:w * h] do
    let id := (ids[i]!).getD ""
    if tile[i]! = TType.strongSwitch ∨ tile[i]! = TType.weakSwitch then
      let mut es : List (Nat × Nat) := []
      for r in R.rules do
        if r.1 == id ∧ r.2.1 != "teleports" then
          let code : Nat := if r.2.1 == "toggles" then 0 else if r.2.1 == "closes" then 1 else 2
          es := es ++ [(code, maskOf r.2.2)]
      eff := eff.set! i es
    if tile[i]! = TType.teleport then
      for r in R.rules do
        if r.1 == id ∧ r.2.1 == "teleports" ∧ (tel[i]!).isEmpty then
          let mut cs : List Nat := []
          for o in r.2.2 do
            for j in objs.getD o [] do
              if !(cs.contains j) then cs := cs ++ [j]
          let sorted := cs.mergeSort (fun a b => a ≤ b)
          tel := tel.set! i (sorted.map (fun j => ((j / h : Nat), (j % h : Nat))))
  let mut sx : Int := 0
  let mut sy : Int := 0
  let mut ex : Int := 0
  let mut ey : Int := 0
  for i in [0:w * h] do
    if tile[i]! = TType.start then
      sx := (i / h : Nat); sy := (i % h : Nat)
    if tile[i]! = TType.goal then
      ex := (i / h : Nat); ey := (i % h : Nat)
  return { width := w, height := h, tile := tile, mutBit := mutBit, eff := eff, tel := tel,
           sx := sx, sy := sy, ex := ex, ey := ey, initCfg := initCfg, fullMask := fullMask }

/-- Read a move sequence written as e.g. `"RRDSU"`, with `S` for switching between
the two half blocks. -/
def parseMoves (s : String) : List Move :=
  s.toList.filterMap fun c =>
    match c with
    | 'U' => some (.go .U)
    | 'D' => some (.go .D)
    | 'L' => some (.go .L)
    | 'R' => some (.go .R)
    | 'S' => some .swap
    | _   => none

end Blox
