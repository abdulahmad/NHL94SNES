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

## Learned

