# Cleanup plan

Audit of generic names and of assets, written before the rename and extraction passes. The build on this tree is MATCH (`10dcd21be9c5542e82b0b94473bf5ff569b36cf5`). Nothing in this file changes bytes.

Counts are label definitions (`Name:` or `Name =`) under `src/`. A generic name is `CODE_`, `DATA8_`, `DATA16_`, `loc_`, `byte_`, `word_`, `unk_`, `off_`, `sub_`, `L` plus four or more hex digits, a `.lN` / `.vN` local, or `SpriteFrame` plus a number. There are no `loc_`, `byte_`, `word_`, `unk_`, `off_`, `sub_`, `Lxxxx`, `.lN` or `.vN` definitions.

## Generic names

9095 labels. 6881 of them are still generic.

| Kind | Count |
|---|---|
| `CODE_` | 5100 |
| `SpriteFrameN` | 976 |
| `DATA8_` | 793 |
| `DATA16_` | 12 |

2737 files are still named `CODE_`, `DATA8_` or `DATA16_`. 2183 generic labels are used only in the file that defines them (branch targets and small fall-throughs). 3722 are referenced from another file, so a rename has to cover every reference.

| Folder | Generic labels | Generic file names |
|---|---|---|
| `routines/snes` | 4990 | 2244 |
| `data/gfx` | 1209 | 233 |
| `data/text` | 332 | 26 |
| `data/tables` | 133 | 133 |
| `data/sound` | 101 | 101 |
| `routines/hockey` | 43 | 0 |
| `routines/penalty` | 35 | 0 |
| `routines/logic` | 16 | 0 |
| `routines/video` | 8 | 0 |
| `routines/middle` | 8 | 0 |
| `routines/shootout` | 5 | 0 |
| `routines/stats` | 1 | 0 |

The named routine folders (`hockey`, `penalty`, `logic`, `video`, `middle`, `shootout`, `stats`) already use the 93S or 94G routine name. The generic labels inside them are branch targets. Those are the first rename pass: the 93S local name where the routine matches, otherwise a 92-style local (`.loop`, `.done`, `.exit`, or a plain number).

`routines/snes` is the rest of the code. A routine that matches 93S moves to that 93S folder under the 93S name. A routine that matches a 94G feature moves to that 94G module. Anything still unclear after a short look keeps a placeholder and goes on the Unsure list in `docs/HANDOFF.md`.

`SpriteFrameN` (976 labels, one per frame in `data/gfx/SpriteFrames8*.asm`) stays a numbered frame until a 93S `SPF` name or a 94G frame name is certain. Replacing the number with a guess would hide the frame index the animation tables use.

Raw absolute operands (`lda.w $15D6` and the same shape) are not labels, and there are 16779 of them, 16142 in `routines/snes`. They are renamed only when `src/ram94s.asm` or `src/inc/snes_regs.asm` already has that address, or when a 93S variable is the same role and the bytes stay the same. New equates go in `ram94s.asm`.

History stays in `docs/name_map.csv`. New rows keep the existing columns (`address,name,auto_name,source,note,file`): `auto_name` is the old name, `name` is the new one, and `source` is `93S`, `94G` or `new`.

## Asset inventory

93S commits binaries under `data/` and the asm `incbin`s them. It does not auto-extract, and it does not decompress a stream that the ROM stores packed (`.chr.pak`, `.map.pak` stay packed). Unpacked ROM data is stored unpacked (`.chr`, `.pieces`, `.snesmap`, `.snespal`). 94G extracts 475 slices into `Extracted/` from `tools/extractAssets94.js`, with `Extracted/.extract-complete.json` written last, and `tools/prebuild.js` runs that when the folder is missing. Genesis `.map.jim` / `.pal` / PCM are not the SNES formats. A 94G asset maps to the SNES asset of the same role, in the 93S file type.

94S already lists 302 ROM ranges in `tools/extract.py` and commits the bytes under `src/data/gfx/` and `src/data/sound/` (13 `.bin`, 4 `.chr`, 204 `.huf`, 28 `.lz`, 2 `.pairs`, 4 `.rle`, 45 `.spc`, 2 `.spr`). `tools/prebuild.py` checks the ROM and stops with "ROMs are not included in the repo." It does not extract. `Extracted/` does not exist.

Status in the table: **extracted** means the bytes are already a named file the source includes. **move** means those bytes should leave git and come from `Extracted/` on prebuild (same bytes, same format). **name** means the bytes are extracted under a `DATA8_` file and still need the reference name. **missing** means no 94S block is identified yet.

### Graphics and tiles

| Reference | 94S | Status |
|---|---|---|
| 93S `IceRink.chr.pak` | `IceRink.chr.lz` (header spelled, rest `incbin`) | extracted, move |
| 93S `IceRink.snesmap` | `IceRink.map.lz` | extracted, move. 94 stores the map packed; 93S's map is unpacked in ROM, so this one stays packed |
| 93S `IceRinkHor.snesmap` | no horizontal rink map file | missing |
| 93S `BigFont.chr.pak`, `SmallFont.chr.pak` | `LetterSprites.spr`, `SmallLetterSprites.spr` (sprite fonts, not BG fonts) | extracted, move. A separate BG font tile block is not identified |
| 93S `Sprites/set00`–`set14` `.chr` + `.pieces` | `SpriteFrames82.bin`–`SpriteFrames8E.bin`, headers and pieces in source, tiles `incbin` by range | extracted as raw ROM cuts, move. Not split into one tiles file per frame the way 93S splits a set |
| 93S `FaceOff.chr.pak`, `FaceOffMap` | no FaceOff tiles or map file | missing |
| 93S `Framer.chr`, `FramerMap` | no Framer file | missing |
| 93S `Ref.chr.pak`, `RefHor.chr.pak`, `Refs.snesmap`, `RefsHor.snesmap` | no ref tiles or maps | missing |
| 93S `PlayoffTiles.chr.pak`, `TeamBlocks.chr.pak` | no playoff-tile or team-block file | missing |
| 93S `Title1`, `EASN`, `RonBarr`, `GameSetup`, `NHLPALogo` `.map.pak` | no title, EASN, Ron Barr, game-setup or NHLPA logo screen file | missing |
| 94G `logo*.map.jim` (28 teams) | `TeamLogos.spr.huf` plus `CenterIceTiles*` / `CenterIceMap*` | extracted, move. One sprite set, not one map per team |
| 94G `Crowd.anim`, `Zam.anim`, `FaceOff.anim` | no animation-container files. Frames live in SpriteFrames | missing as separate assets |
| 94G `EnergyBar`, `Scores`, `Arrows`, `PauseScreen`, `ReplayOptions`, `EASportsMap`, `HiScoreImg`, `HotIcon`, `ColdIcon`, `CornerLogo`, `PlayoffSprite`, `ArenaGfxBank` | not identified as their own files | missing |
| 94G `GameSetUp94`, `Title94`, `Scouting94`, `GameSetupBkgd`, `GameSetupLogoBorder` | screen graphics inside `DATA8_` gfx blocks | name, once a reader identifies the block |

### Palettes

| Reference | 94S | Status |
|---|---|---|
| 93S `Pals/<team>h.snespal`, `<team>v.snespal` (and 94G `*h.pal` / `*v.pal`) | `HomeUniformPalettes`, `AwayUniformPalettes` (source `dw`, 16 colours per team) | extracted as source. Not separate `.snespal` files |
| 93S `Pals/Rink.snespal` | no rink palette file. HANDOFF: the rink palette is not found | missing |
| 94G `MatchupPal*` | not identified | missing |
| 94G `TeamLogoPal*` | `LogoPalette*` (source `dw`, one file per team) | extracted as source |
| 94G `PicturePalette.bin` | `PhotoPalette*` (source `dw`) | extracted as source |
| unnamed packed palettes | `DATA8_89FFC7.pal.lz`, `DATA8_9ACCA9.pal.lz`, `DATA8_9ADE57.pal.lz`, `DATA8_9AE0D5.pal.lz`, `DATA8_9AE121.pal.lz`, `DATA8_9AE884.pal.rle`, `DATA8_9AE946.pal.lz`, `DATA8_9AE972.pal.huf` | name |

### Tilemaps

| Reference | 94S | Status |
|---|---|---|
| 93S rink / ref / screen maps above | see Graphics | |
| centre-ice maps | `CenterIceMap*` (source, per team, plus NHL) | extracted as source |
| other packed maps | `DATA8_8AFF7A` (10 x 12 byte map), `DATA8_95FF9B.map.huf`, `DATA8_96C61F.map.lz`, `DATA8_9AB7A1.map.huf`, `DATA8_9ABA95.map.lz`, `DATA8_9AC0CC.map.huf`, `DATA8_9AD88C.map.huf`, `DATA8_9ADC8D.map.huf`, `DATA8_9ADDC6.map.huf`, `DATA8_9ADEE0.map.rle`, `DATA8_9ADFCB.map.huf`, `DATA8_9AE8EC.map.rle`, `DATA8_9AE919.map.rle`, `DATA8_9AE9C7.map.lz`, `DATA8_9AE9F0.map.lz`, `DATA8_9AEA15.map.lz` | name |

### Sprite frames and fonts

| Reference | 94S | Status |
|---|---|---|
| 93S sprite sets, 94G `Sprites.bin` / `Spritetiles.bin` / `frameSprData.bin` | SpriteFrames banks `$82`–`$8E` | extracted, move |
| 93S `HotList.bin` | no HotList file | missing |
| 94G `revframetbl.bin` | not identified | missing |
| sprite fonts | `LetterSprites.spr`, `SmallLetterSprites.spr` | extracted, move |

### Logos and photos

| Reference | 94S | Status |
|---|---|---|
| 94G team logos | `TeamLogos.spr.huf`, `CenterIceTiles*`, `CenterIceMap*` | extracted, move (tiles) or source (maps) |
| 94G `PlayerCards/*.bin` (144 named cards) | hundreds of `DATA8_*.lin.huf` photo blocks in banks `$97`–`$9A`, plus `DATA8_8FFE74` (stand-in skater) and `DATA8_8CFDEC`, `DATA8_90FDE2` | extracted, name. Player names are not matched yet |
| 94G `NoPicSkater*`, `NoPicGoalie*` | `DATA8_8FFE74.lin.huf` is the shared stand-in. Goalie stand-ins are not split out | name / missing |

### Sound and music

| Reference | 94S | Status |
|---|---|---|
| 93S `spc/driver.spc700` | `SoundDriver` in the engine (SPC bytes as `db`). Not a separate extracted driver file | extracted as source |
| 93S `gamesamples.brr`, `bootsamples.brr` | 45 `DATA8_*.spc` upload blocks (address, length, bytes) | extracted, move, name. BRR sample names from 93S are not matched to SPC blocks |
| 94G `z80_snd_drv93.bin`, PCM `sfx_*`, `fm_instrument_patches.bin` | no Z80 driver and no Genesis PCM. The SPC driver and the `.spc` blocks are the SNES counterparts | missing as those file names; the role is the `.spc` list |
| 94G `sfx_*_cmdstream.bin` | sound effect table bytes still plain `db` (HANDOFF: `$80E741`) | missing as extracted streams |
| 94G `fmtune_id_*` (75 songs) | songs at bank ends (`DATA8_81FE45`, `DATA8_8BFE74`, `DATA8_8EFD2B`, `DATA8_8FDD32`, `DATA8_90C20C`, and the TeamSongs pointers) | source `db`, not one file per song. name |

### Text and team data

| Reference | 94S | Status |
|---|---|---|
| 93S text tables (`AttribMenuSkater`, `AttribMenuGoalie`, `PositionNames`, `GameLabels`, `PasstoText`, `StatusTextTbl`, `HandedTextTbl`, `GoalBoxText`, `RosterLineNames`) | same names in `src/data/text/` | extracted as source |
| 93S `Credits`, `PasswordText`, `PerLabels`, `ScoutLabels` | `CreditTitles`, `CreditNames`. Password, period and scout label tables are not under those names | partial. `DATA8_` text files still to name |
| 93S `ScoutingReportText.bin`, 94G `ScoutTextScript.bin` | scouting text is inside the team records (`.sr`), not a separate script file | extracted as source, different layout |
| 93S `teamdata93s.asm`, 94G team data | `src/data/teamdata94s.asm` | extracted as source |

## Extraction work

1. `tools/prebuild.py` keeps the missing-ROM message. After the ROM checks out, it checks `Extracted/.extract-complete.json` (file list, sizes, ROM SHA-1, extractor SHA-1). If anything is missing or the extractor changed, it runs `tools/extract.py`.
2. The extractor writes `Extracted/data/gfx/` and `Extracted/data/sound/` with the extensions already in `src/data/README.md`, and writes the marker last. `Extracted/` is gitignored.
3. Asm `incbin`s the extracted file (ranges stay where a header is already spelled as `db`/`dw`). The committed copies under `src/data/gfx/` and `src/data/sound/` are deleted in that commit.
4. `SpriteFramesXX.bin` moves with them. Splitting each frame's tiles into its own `.chr`, the way 93S splits a sprite set, is a later commit and only if every `incbin` range still assembles to the same bytes.
5. Packed streams stay packed. 93S only stores unpacked bytes when the ROM already stores them unpacked.
6. Palettes and centre-ice maps that are already `dw` source stay source.
7. `lst/nhl94snes.sfc` stays committed.

## Order of work

1. This plan.
2. Named routine folders (`stats`, `shootout`, `video`, `middle`, `logic`, `penalty`, `hockey`): local labels, then any `CODE_` file that is the rest of one of those routines. MATCH, commit, push, update `docs/HANDOFF.md`.
3. Extraction flow (the steps above), one commit.
4. `routines/snes`, one bank group at a time (`$9E`, `$9F`, `$9B`, `$9D`, `$9C`, `$80`), 93S name, then 94G name, then a name from what the code does.
5. `data/text`, `data/tables`, `data/sound`, `data/gfx`: name `DATA8_` blocks that match a reference asset. Leave the rest on the Unsure list.
6. SPA names in the animation list (`SPAboardfront`, `SPAboardback`, `SPAbenchcheckl`, `SPAbenchcheckr`, `SPAcrosscheck`, and the rest of the 94G list), frame numbers, RAM, sound IDs, team indexes, joypad bits, PPU equates. Long pointers that are bank `$00` in the ROM are `dl Label&$FFFF`.
7. Headers: a short plain-English line on each routine file, a short story on each larger file. "new in 94" only for a major feature.
8. **Unsure decisions (approved 14 Oct 2026).** Apply the equates and policies below before more bank renames. Details and ids are in `docs/HANDOFF.md` and the finish-plan canvas.

### Equates to apply (source=new)

| Name | Address | Where used |
|---|---|---|
| `mesareaEnd` | `$0A48` | `PushNumber`, `PushTime` only |
| `gmStatBase` | `$1742` | `ClearTeamStats`, team stat pointers |
| `playoffRoundIdx` | `$7E35D4` | `GetShifter`, passwords, other scores |
| `rosterNone` | `$FFFC` | `cmp.w` beside `TMPDOUT` in `TryAddPlayerToList`, `ResetBench`, `reenergizeteam` |

### Keep raw (do not equate globally)

`$00` / `$04` / `$08` (divider and engine scratch). `$C3` in `vtoa`. `#$000B` / `#$000A` / `#$0012` in `setplayer`. `$14` and `$0CE5` scratch in `setplayer` until one owner is proven. Flag immediates `#$0800`, `#$0040`, `#$2000`, `#$4000` except the sites already converted. `PenOffsides` stays `$12` in this ROM (note 93S uses `$10`).

### Defer until investigated

`$7E34C6` (not `OptLine`; map bits or split before naming). `$163A` (penalty suppress, not `OptPen`). `$0B7D,x` (pass target on assist path). `#$0024` in `AddPenalty` (match 94G penalty id). `$7E35D0` / `blankchar` (compare stored tile to 93S before naming).

### DATA8 and sprites

Mixed `DATA8_9CF000` cursors: stay `DATA8_` or `Cursor_…` only when tied to one screen. `DATA8_80D3EB` is `PenaltyList` (same layout and readers as 93S). `SpriteFrameN` stays numbered until SPF mapping is proven. The animation list is `SPAList`; animations that match 93S take the 93S SPA names.

### Missing assets

Identify from screen routines (title, password, summaries, rink DMA), extract with MATCH, or record N/A when SNES has no separate file (many 94G-only gfx). Do not force 94G filenames onto SNES packed streams.
