# Rules (94S)

The rules for this repo's part of the alignment, then the learned rules. Read before every unit. Any tool adds a learned
rule in the same commit as the fix that confirmed it, newest last: `- YYYY-MM-DD <area>: <rule>. (<evidence>)`.

## Who decides what (all games)

| Category | Decided by |
|---|---|
| Name of a routine several games share | the earliest game that has it (92G is the root); a fix goes to the earliest repo first, then down the lineage |
| Name of a feature new in year N | that year's Genesis game (94G for 94S and 94PC, 95G for 95S and 95PC) |
| Name of a platform-only job | the earlier repo on that platform (93S for 94S, 94PC for 95PC), else what the code does |
| Same name, different job | the earlier meaning keeps the name |
| Top folder or file | the same-year Genesis file |
| RAM order | the merged order (92G, 93G, 94G, 93S, 94S, then 95G, 96G) |
| Data, assets, banks | the earlier repo on the same platform |
| Order inside a file | ROM order (the report re-sorts for display) |
| History | `docs/name_map.csv` only, never source comments |

## This repo

- Folders: the top folder under `src/routines/` is the 94G file the routine is in (`collide`, `setup`, `stats`, `logic`...). A routine with no 94G partner goes in the 94G file of its callers. SNES-only engine code goes in the folder for its job (video, sound, middle, decompress, main).
- Second level: inside `logic/`, `penalty/`, `middle/` and `video/`, a routine that comes from a 93S area goes in a subfolder with that area's name (`logic/assignments/`). No subfolder that repeats the top folder.
- Names: the shared 92G/93G name when the body matches (93S and 94G agree on almost all of them). A 94 feature takes the 94G name. An SNES job 94G does not have keeps the 93S name. Same name, different job: the earlier meaning keeps it (`BitstoPW` stays: password, not 94G's SRAM `BackupRAM_Save`).
- Data and banks follow 93S: one asset per file, `src/data/tables/`, `src/banks/` in ROM order.


## Naming, source style and layout (moved from SEGMENT_AGENT.md, Oct 2026)

Naming lineage is 92G -> 93G -> 94G -> 95G, and the SNES ports sit beside their Genesis parents (93S from 92G/93G, 94S from 93S plus the 94G features).
- A routine, variable or table that matches its parent takes the parent's name. 92G is the naming root.
- Clash rule: if one name would mean two different things, the earliest game's meaning keeps the name and the later one gets a new name.
- Fix the earliest repo first, then propagate the change down the lineage (92 -> 93 -> 94 -> 95, and to the SNES repos).
- Team names: 93 uses the city names of its own data; 94 and 95 use NYI / NYR style abbreviations (team nicknames are not in the repo).

Source style:
- No rename-history, provenance or origin-tag comments ("was X", "from 93G", "renamed"). That history lives in `docs/name_map.csv` only.
- No hardcoded ROM addresses in comments, and no hand-kept derived counts (sizes, numbers of entries, totals) that the code or the assembler can compute.
- Mark "new in 94" / "new in 95" only for major features, not for every changed routine.
- First-pass naming: a label with no 93S/94G (or 93G/92G) match is named from what the code clearly does when that is obvious;
  otherwise an auto label (`CODE_xxxxxx`, raw RAM address) is acceptable and is revisited in a later naming pass. Never guess a name.
- Local labels in 92 style: `.loop`, `.next`, `.done`, `.exit`, and plain numbers for trivial jumps.
- File headers are short plain-English stories of what the file does, modelled on `hockey93.asm`, `main93.asm` and `menu93.asm`.

Layout (SNES repos, 93S and 94S): `src/banks/` holds ordered bank files named by content (one `org`, then `incsrc` lines in ROM order),
`src/routines/<module>/<Routine>.asm` holds one routine per file, `src/data/<category>/` holds data. The folder is the module of the
routine's origin: 94G for 94 code, else 93G, else 92G; SNES-only code goes in a sensibly named SNES folder. Tools go in
`tools/`. The build runs a prebuild ROM check that names the path, file name, SHA-1 and size of the ROM it needs
(and extracts the assets automatically where the repo extracts them).

Work in small steps: every change is built and checked byte for byte against the reference ROM, committed on a short branch off
`main` and merged through one pull request (normal merge, no force push; outside contributors use a fork). Keep `docs/HANDOFF.md`
current after each merge.

## Learned
- 2026-11-02 names: `SetupPauseScreen` (5 callers) and `DrawTeamBlocks` (14 callers) are not folded into `Pausemode` / `PlayoffScreen` as 94G's locals: they are shared routines in 94S, so they keep their global 93S names. (step C2, jsl callers in src/routines)
- 2026-11-02 names: call-order matching against 94G (align each shared routine's call list, take the 94S callee where 94G calls a routine 94S lacks) is too noisy to apply: 78 candidates, mostly wrong (`Mul8U` -> `printz`), because 94G calls the print macros where 94S calls its own helpers. Name by reading both bodies, one 94G file per unit. (step C5 trial)
- 2026-11-04 contributing: CONTRIBUTING.md must not contradict History: lineage lives only in the name history file, never in source comments. (CONTRIBUTING rewrite vs RULES History row)
- 2026-11-05 leftover recut: 94G folded ManualGoalieMenu into period94, so 94S `goalie/ManualGoalieMenu.asm` moved to `src/routines/period/ManualGoalieMenu.asm`. (94G leftover recut; 94S~94G)
- 2026-11-06 names: `adefo` and the other `a*`/`p*` equates are asstab slot indexes, not the `ass*` routines. Shared slots keep the Genesis name at this ROM's numbers (goalie is $07; 93S 7-D became 8-E). SNES-only slots: 94G `abreakaway` for $10 even though 94G's number differs; `adumpin` for $14 (95PC has no dump-in string). Do not invent 94S slots for 94G extras that are not in this asstab. (Abdul)
- 2026-11-06 names: asstab slot $00 is `anull` (95PC debug "null" / `rtss`). 92G left it unnamed; do not reuse `anothing` (92G `assnothing`). 93S/94S/94G share `anull`. (Abdul)
