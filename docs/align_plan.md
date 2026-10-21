# Alignment plan

Audit of 94S against NHLPA93SNES (93S) and NHL94Genesis (94G), written before any layout or rename. The build on this tree is MATCH (`10dcd21be9c5542e82b0b94473bf5ff569b36cf5`). Nothing in this file changes bytes.

94S is still the segment layout: `src/nhl94snes.asm` includes 253 `src/bankXX_YYYY.asm` slices. 93S has already moved to the hybrid layout this plan copies. 94G is the source of names for features 94 added. Banks do not line up by number: 93S is 512 KB (`$80-$8F`), 94S is 1 MB (`$80-$9F`), and bank `$80` of 94S is a new engine (SEGMENT_AGENT).

## bank9C_A000 covers B000, C000 and D000

Checked. There is no `src/bank9C_B000.asm`, `bank9C_C000.asm` or `bank9C_D000.asm`, and `src/nhl94snes.asm` does not include them.

`src/bank9C_A000.asm` is `org $9CA002`. It holds the code at the start of that range, then `incsrc "data/teamdata94s.asm"` (TeamList, every team record, playoffseats). The next file is `src/bank9C_E000.asm` at `org $9CEF59`. The included team database is what fills `$9CB000`, `$9CC000`, `$9CD000` and the bytes of `$9CE000` up to `$9CEF58`. That is the same shape as 93S `src/data/teamdata93s.asm` included from the teams bank. Leave it as one file.

## Target layout

Mirror 93S:

- `src/banks/bXX_<content>.asm`: one `org` at the first byte of the bank (or the first byte after the previous bank's overrun), then `incsrc` lines in ROM order. No other bytes.
- `src/routines/<module>/<Routine>.asm`: one routine per file. The folder is the Genesis module the routine comes from. A routine that matches 93S stays in that 93S folder (`hockey`, `logic`, `middle`, `penalty`, `video`, `stats`, `sound`, `main`). A 94 feature that matches a 94G module goes in that module (`shootout`, and the others below once the code is identified). A routine that falls through into the next stays in the first routine's file. SNES-only engine code (the bank `$80` services, PPU, SPC player, decompressors, heap) goes in `src/routines/snes/`.
- `src/data/`: data. `frames94s.asm` is the merged sprite-animation list (93S `frames93s.asm`, 94G `frames94.asm`). `teamdata94s.asm` stays. `sound/gamesound.asm` and `sound/bootsound.asm` are the SPC upload streams once those blocks are identified the way 93S groups them. Graphics stay as asm that `incbin`s the binary assets. Text stays one table per file in `data/text/`.
- Small tables a code module uses stay in that module's routines folder, as in 93S. Padding stays with the routine before it.

`tools/verify_all.sh` today globs `src/bank*_*.asm`. The first layout commit updates it so a bank file under `src/banks/` is checked the same way, and the full ROM check stays.

## Bank files

Each row is one future `src/banks/` file. "Move" means the slices become `incsrc` lines. "Split" means global labels become routine or data files. Slice notes are the ROM map in `SEGMENT_AGENT.md`.

| Bank file | Slices now | 93S / 94G | Action |
|---|---|---|---|
| `b80_engine.asm` | bank80_8000..F000 | No 93S byte match. Shootout tail is 94G `shootout94`. Math, heap, SPC player, sprite cache and decompressors are SNES-only. | Split. Named services -> `routines/snes/`. ShootoutWonBy, ShootoutShooters, InitShooters, ShooterSelectList -> `routines/shootout/`. Tables and the copyright / credits / header stay data. Header/vectors -> `src/header/snes_header.asm` (93S). |
| `b81_rink_logos.asm` | bank81_8000..F000 | IceRinkTiles is the 93S name. TeamLogoSprites and the song at the end are SNES-only. | Merge the three IceRink slices into `data/gfx/IceRinkTiles.asm` and the logo slices into `data/gfx/TeamLogoSprites.asm`. The song stays its own data file. |
| `b82_spriteframes.asm` .. `b8E_spriteframes.asm` | bank82 .. bank8E | Not 93S's 15 `SpriteSetN` files. One SpriteFrames set runs through these banks (94S `DrawSprite`). Tails are centre-ice logos, photos, songs, SPC blocks. | One bank file each. Frame headers stay source; tile bytes stay the SpriteFramesXX assets. Each tail asset becomes its own data file instead of living in the last slice. |
| `b8F_sound.asm` | bank8F | SPC upload blocks and one song. 93S puts driver + samples in `data/sound/bootsound.asm` / `gamesound.asm`. | Data files under `data/sound/`. Do not force the 93S file names onto blocks that are not the boot driver or the game sample stream. |
| `b90_gfx_sound.asm` .. `b95_gfx_sound.asm` | bank90 .. bank95 | SNES graphics and SPC blocks, plus LetterSprites / SmallLetterSprites. No 93S bank counterpart. | Same as `$8F`: one bank file, one data file per asset. |
| `b96_uniforms.asm` | bank96 | AwayUniformPalettes, HomeUniformPalettes, songs, maps. SNES-only. | Data. Palette tables can share one file if they are one run of bytes. |
| `b97_photos.asm` .. `b99_photos.asm` | bank97 .. bank99 | Player photos and team songs. SNES-only. Centre-ice tails: TBL, NYI, OTT. | Data. Photo blocks stay separate assets until a reader gives them player names. |
| `b9A_logos.asm` | bank9A | Centre-ice tiles and maps, photo and logo palettes. SNES presentation data. | Data, already labelled by team. Rename the abbreviations that disagree with team data (below). |
| `b9B_screens.asm` | bank9B_8000..C000, then FF fill D000..F000 | Screen and game code, mostly `CODE_` / `DATA8_`. A few names already match 93S (`show_rink` is in `$9E`, not here). Multi5Bios is SNES-only. | Split code at labels. Matched names go to the 93S folder. Unmatched code stays `routines/snes/` under the auto name. FF fill stays one pad file. |
| `b9C_teams.asm` | bank9C_8000, 9000, A000, E000, F000 | Team database matches 93S `teamdata93s.asm` (already extracted). Text tables that match 93S are already in `data/text/`. | Split the code in 8000/9000/A000. Keep `teamdata94s.asm`. Keep the text includes. |
| `b9D_roster.asm` | bank9D_8000..F000 | Roster, game setup, player card, photo table. Animation sequences at the end are the 94G frame tables. | Split code. Merge the animation sequences into `data/frames94s.asm`. |
| `b9E_game.asm` | bank9E_8000..F000 | The in-game logic. This is where most 93S `hockey` / `logic` / `penalty` routines should be found. | Split. A label that already matches a 93S routine file uses that folder. |
| `b9F_flow.asm` | bank9F_8000..F000 | Period flow, goals, menus. 94G `period94`, `menu94`, `optsetup94` once a routine is identified. | Split the same way. |

Do not merge two banks into one file. 93S uses one file per bank.

## Files to split, merge, rename or move

Already in the right kind of place, keep:

- `src/data/teamdata94s.asm` (the B/C/D coverage above).
- `src/data/text/*.asm` for the nine tables that already use 93S names: AttribMenuSkater, AttribMenuGoalie, PositionNames, GameLabels, PasstoText, StatusTextTbl, HandedTextTbl, GoalBoxText, RosterLineNames. Also CreditTitles, CreditNames, TeamPlaceNames, PregameText.
- `src/data/gfx/` and `src/data/sound/` binaries. Step 4 moves the binaries to `Extracted/` and leaves the asm.
- `src/ram94s.asm`, `src/inc/snes_regs.asm`, `src/macros/snes94.mac`.

Move, one area per commit, rebuild after each:

1. Bank `$81` into `b81_rink_logos.asm` plus the two gfx asm files and the song.
2. Banks `$82-$8E`, one bank per commit: bank file, frame source, tail asset.
3. Banks `$8F-$9A`, one bank per commit: bank file and one data file per asset.
4. Bank `$80`: routine files for the named services and the shootout; data files for the tables; `snes_header.asm`.
5. Banks `$9B-$9F`, one bank per commit: routine files, `frames94s.asm` out of `$9D`.

Text tables still named `DATA8_` stay in `data/text/` until a 93S or 94G name is certain. Do not invent names.

## Names

Lineage, from SEGMENT_AGENT: a routine that matches 93S takes the 93S name. A 94 feature that matches 94G takes the 94G name. 92 names stay as they are. A label that uses a name belonging to something else is renamed. Local labels stay 92 style (`.loop`, `.next`, `.done`, `.exit`, plain numbers). History goes only in `docs/name_map.csv`.

### Already the parent name

These 94S labels already match a 93S routine or data file. When the file is split, the file name and folder follow that 93S path.

`penalty`: AddPenalty, AdvanceStringPtr, ClearPenaltyBuffer, GetLowestPen, PrintPerLabel, RemovePlayerFromList, SetHor, SetPA, SetupTeamForIntermission, UpdatePA, addteamstat, chkprogress, coinsearch, pplpen, reenergizeteam, releasepl, updatepentime, updatepwrplay, updatepwrplay_clr.

`hockey`: clearTeamStats, GetPeriodTime, GetPeriodTimeRemaining, GetPeriodTime_timetab, GetPlayerNumInitial, GetPlayerRecord, GetShifter, InitScoutDisplay, PWtoBits, ResetBench, SetPlList, Setplass, ShowInjuryBox, SprSort, SuperAdd, TryAddPlayerToList, adda4, adda43, forcepldata, restoreteams, setpde, setpersonel, setplayer, setteams, suba4.

`logic`: Findhittype, GoalieCount, SetSPA, ShotMode, a2offsides, a2touchpuck, assinsert, chkpk2, getlchoice, lcfound, passmode, pucknothing, skatetopuckinit, vtoa.

`middle`: PushNumber, PushTime, PutDigits2, WeightedRandomSelect, appstring, eraser, randomd0.

`video`: RemapTiles, show_rink.

`stats`: GetPlayerCount.

`sound`: SPCUpload.

`data`: AttribMenuGoalie, AttribMenuSkater, GameLabels, GoalBoxText, HandedTextTbl, IceRinkMap, IceRinkTiles, PasstoText, PositionNames, RosterLineNames, StatusTextTbl.

Shootout labels that already match 94G `shootout94.asm`: InitShooters, ShootoutWonBy, ShootoutShooters, ShooterSelectList. The other 94G shootout labels (ClearShootout, NextShooter, CountShootoutGoals, ShootersRedraw, PrintShooterList, and the rest of that file) are not labels in 94S yet. The rounds loop and the list drawing are still `CODE_` / auto. Name them only after a side-by-side match. Until then they stay auto.

Team long names already match 94G and the rules: NYIslanders, NYRangers, plus Anaheim, Boston, Buffalo, Calgary, Chicago, Dallas, Detroit, Edmonton, Florida, Hartford, LosAngeles, Montreal, NewJersey, Ottawa, Philadelphia, Pittsburgh, Quebec, SanJose, StLouis, TampaBay, Toronto, Vancouver, Washington, Winnipeg, AllStarsEast, AllStarsWest. TeamList order matches 94G (Anaheim 0 ... Winnipeg 25, AllStarsEast 26, AllStarsWest 27).

### Names that differ

Abbreviation labels were chosen as the usual three-letter codes. The game's own abbreviation strings in `teamdata94s.asm` disagree for six teams. On-screen place text is the city name, so it does not override the abbreviation. Rename the labels (and the centre-ice asset file names) to the string in the team record. Bytes of the strings stay.

| Now | Team-data string | Where |
|---|---|---|
| ANA | ANH | TeamPlaceNames `.ANA`, CenterIceTilesANA, CenterIceMapANA, LogoPaletteANA, PhotoPaletteANA, `CenterIceANA.lin.huf` |
| LAK | LA | `.LAK`, CenterIce*LAK, LogoPaletteLAK, PhotoPaletteLAK, `CenterIceLAK.lin.huf` |
| NJD | NJ | `.NJD`, CenterIce*NJD, LogoPaletteNJD, PhotoPaletteNJD, `CenterIceNJD.lin.huf` |
| OTT | OTW | `.OTT`, CenterIce*OTT, LogoPaletteOTT, PhotoPaletteOTT, `CenterIceOTT.lin.huf`. 93S palettes are also `OTWh` / `OTWv`. |
| SJS | SJ | `.SJS`, CenterIce*SJS, LogoPaletteSJS, PhotoPaletteSJS, `CenterIceSJS.lin.huf` |
| TBL | TB | `.TBL`, CenterIce*TBL, LogoPaletteTBL, PhotoPaletteTBL, `CenterIceTBL.lin.huf` |

ASE, ASW, BOS, BUF, CGY, CHI, DAL, DET, EDM, FLA, HFD, MTL, NYI, NYR, PHI, PIT, QUE, STL, TOR, VAN, WPG, WSH already match the team-data strings. The NHL shield labels (CenterIceTilesNHL, CenterIceMapNHL) are the all-star logo, not a team abbreviation. Leave them.

94G SPA names to use when the animation list is labelled, including the spellings 94G has today: SPAboardfront, SPAboardback, SPAbenchcheckl, SPAbenchcheckr, SPAcrosscheck. 94S has no SPA animation labels yet (only the RAM index `SPAnum`). The sequences are the `dw` run that starts at DATA8_9DE0FC.

### Still unnamed

About 5,900 labels are still `CODE_` or `DATA8_`. Banks `$9E` and `$9F` are most of the code. They are not guessed in this plan. A later naming pass compares each routine with 93S, then 94G, and writes `docs/name_map.csv`. Anything still uncertain after a short look stays the auto name and is listed under Unsure in `docs/HANDOFF.md`.

## SNES-only, and new in 94

SNES-only (no 93S routine, not a 94G feature): the bank `$80` reset / NMI / IRQ path, mode 7 multiply and divide, the handle heap, the SPC music player (MusicStart, MusicStop, SoundInit, SoundUpdate), DrawSprite and the tile cache, DecompressLZ / DecompressPairs / DecompressHuffman / DecompressRLE / Decompress, the SPC driver upload, Multi5Bios, LinearToPlanar, SpriteFrames as one set, TeamLogoSprites, player photos, centre-ice logos, uniform palettes, and the song data mixed through the upper banks. 93S draws with DrawFrame / DrawFrameHi and unpacks with DecompressGraphics. Those names are not reused for this engine.

New in 94, from 94G modules, once a routine is shown to be that feature: shootout (already partly named), and the modules that have no 93S parent: onetimer, crowd, cards, replay, fourway, period, records, sram, attract, optsetup. The extra SPA tables (board, bench check, cross-check, goalie slam) are the frame-list half of that. Do not mark a routine "new in 94" until it is one of these features.

94S teams that 93S does not have: Anaheim, Dallas, Florida, Ottawa, Tampa Bay, and the two all-star teams. Winnipeg is still in this ROM (team 25).

## Asset extraction

93S on main does not auto-extract. It commits binaries under `data/` (`.chr.pak`, `.snesmap`, `.snespal`, `.brr`, `.spc700`, sprite `setNN.chr` / `.pieces`) and the asm `incbin`s each whole file. Its `build.sh` does not run an extractor. 94G (and 93G) do: `tools/prebuild.js` checks the ROM, and if `Extracted/` is missing or stale it runs the extractor. The extractor writes `Extracted/.extract-complete.json` last (file list, sizes, ROM SHA-1, extractor SHA-1). A missing ROM stops with the path, SHA-1, size, and "ROMs are not included in the repo."

94S already has the ROM message in `tools/prebuild.py`, and `tools/extract.py` knows every asset range, but the binaries are committed in `src/data/gfx/` and `src/data/sound/` and the build does not extract. Slices `incbin` a decimal range of those files.

Bring 94S to the Genesis prebuild flow, with the SNES formats it already uses (the 93S `.pak` / `.snesmap` extensions do not describe Huffman, LZ, RLE or pairs):

- `tools/prebuild.py` checks the ROM, then checks `Extracted/.extract-complete.json`. If anything listed is missing or the extractor changed, it runs `tools/extract.py` and the build continues. The missing-ROM message stays.
- Extractor output is `Extracted/data/...` with the extensions already in `src/data/README.md`. The marker is written last.
- `Extracted/` is gitignored. The committed copies under `src/data/gfx/` and `src/data/sound/` are removed in that commit.
- Asm `incbin`s the extracted file. Where a header is already spelled as `db`/`dw`, the `incbin` is the rest of that one asset, not a slice per 4 KB segment. That is the 93S shape (one include of the asset) and it is what bank `$81` can do immediately.

`lst/nhl94snes.sfc` stays committed, as required.

## Symbols, comments, docs

After the layout and the names:

- Long pointers that are bank `$00` in the ROM are `dl Label&$FFFF`. SPA and frame numbers, RAM, sound IDs and team indexes use the equate or label 93S or 94G uses, when the bytes stay the same.
- Each routine file opens with a short plain-English header. Each larger file opens with a short story of what it does. No rename history, no origin tags, no ROM addresses, no derived counts. "new in 94" only on a major feature.
- Then update START_HERE, SEGMENT_AGENT, PROMPT and HANDOFF so they describe `src/banks`, `src/routines`, `src/data` and the prebuild extraction.

## Order of work

1. This plan.
2. Layout, one bank (or the `$82-$8E` frame group, one bank per commit) at a time. `tools/verify_all.sh` prints MATCH before each commit.
3. The abbreviation renames above, recorded in `docs/name_map.csv`.
4. Extraction flow.
5. Names for `CODE_` routines that clearly match, in bank order `$9E`, `$9F`, `$9B`, `$9D`, `$9C`, `$80`.
6. `dl Label&$FFFF` and the SPA / frame equates in `frames94s.asm`.
7. Headers, then the four docs.
