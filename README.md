# NHL '94 (SNES)

> **📀 Game data is not included.** This repository has the assembly code only. The graphics, team palettes, sprites, player photos, sound samples, music and the NHLPA player names and NHL team nicknames are extracted from your own copy of the original ROM when you build, and are not in the repo. You need the NHL '94 Super Nintendo ROM (SHA-1 below) at `nhl94retail.sfc`, or the build stops.

> **🤝 Making a mod, hack, port or other derivative work from this repo? You must credit me and everyone credited in this repo, clearly, in your own repo and in every release. See [Credits and derivative works](#credits-and-derivative-works).**

See [CONTRIBUTING.md](CONTRIBUTING.md) for how changes are made (names, comments, layout, verification).

> **Work in progress:** this disassembly is unfinished and unpolished, and is being actively worked on. Expect labels, file layout and docs to change.

## 🚧 Current Status

- McMarkis has done a cleanup pass.
- Remaining: aligning it with the 93 Genesis, 94 Genesis and 93 SNES cleanups, extracting all the data, naming data properly, and labeling music, frame lists and animations.

**AI agent: start with [START_HERE.md](START_HERE.md).**

Reverse engineered source of NHL '94 for the Super Nintendo, assembled with asar 1.91. The full build is byte-identical to the retail ROM
(SHA-1 `10dcd21be9c5542e82b0b94473bf5ff569b36cf5`, 1048576 bytes, LoROM FastROM, header title `NHL '94`, version 1.0).
The ROM is not included: put your own dump in the repository's root folder (`nhl94retail.sfc` is the usual name, but any name works: the build finds the ROM by its SHA-1 and size; `.sfc`, `.smc` and `.bin` files there are gitignored); the build tells you if it is missing or the wrong one.

Status: bootstrap. The ROM is split into 256 segments of 4 KB (`src/bankXX_YYYY.asm`), each still an incbin of its ROM bytes,
ready for segment agents to disassemble one at a time (`SEGMENT_AGENT.md` is the queue, `PROMPT.md` the per-segment prompt).

## Lineage

NHL '94 SNES is built from NHLPA 93 SNES plus the NHL 94 Genesis features. Names follow 92G -> 93G -> 94G (and the SNES ports beside
them): [NHLPA93SNES](https://github.com/abdulahmad/NHLPA93SNES), [NHL94Genesis](https://github.com/abdulahmad/NHL94Genesis),
[NHLPA93Genesis](https://github.com/abdulahmad/NHLPA93Genesis), [NHL92Genesis](https://github.com/abdulahmad/NHL92Genesis),
[NHL95Genesis](https://github.com/abdulahmad/NHL95Genesis).

## Credit

[NHL94SNESVault](https://github.com/Mhopkinsinc/NHL94SNESVault) by Mhopkinsinc (McMarkis) is the existing decompilation and ROM-hack
project for this game and a reference for this one. `tools/codemap.txt` (the instruction starts of its DiztinGUIsh export) comes
from it; the Vault is released into the public domain (Unlicense).

## Layout

- `src/nhl94snes.asm` includes the segments in ROM order. Each `src/bankXX_YYYY.asm` has one `org`.
- `src/data/gfx/`, `src/data/sound/` the binary assets the banks `incbin` (extracted to `Extracted/data/gfx/`, with
  `gfx/Pals/` and `gfx/PlayerCards/`, and `Extracted/data/sound/`), `src/data/text/` the text tables the banks `incsrc`,
  `src/data/teamdata94s.asm` the team database (see `src/data/README.md`).
- `tools/build.js` the whole build, one line per step (`node tools/build.js`, `--clean`, `--extract`; the npm scripts call it). `tools/prebuild.js` ROM check, run by every build (`tools/roms.js` finds the ROM in the repo folder by its SHA-1 and size, whatever the file name). `tools/verifySegment.js` checks one bank file (or `--all`) against the ROM; `tools/verify_segment.sh` and `verify_all.sh` call it. `tools/extractAssets94s.js` lists the assets' ROM ranges and checks or rewrites them.
  It also extracts the NHLPA player names and NHL team nicknames to `Extracted/PlayerNames.txt` / `TeamNicknames.txt`: `src/data/teamdata94s.asm`,
  holds placeholders instead, and the names step of `tools/build.js` writes a copy with the real
  names to `output/names/`, which the bank file includes (the New York full names in `src/data/text/LongNYI.asm` and `PregameText.asm` include asm that the extractor generates from the ROM). A name must keep the length of its placeholder.
- `tools/disasm65816.py` quick pass for a segment's starting text (`output/quickpass/`).
- `tools/verify_segment.sh`, `tools/verify_all.sh` segment and clean full checks.
- `docs/HANDOFF.md` state of the work, `docs/name_map.csv` name history.

## Build

`npm run build:retail` (the first build installs asar 1.91 into `tools/bin` by itself, with `tools/setup.sh` or `tools\setup.ps1`; you can run those first) (or `node tools/build.js`; `./build.sh` and `build.ps1` run the same). Needs Node.js and asar 1.91. It prints one line per step and ends with MATCH; the ROM is `output/retail/nhl94snes.sfc`. `npm run clean` deletes `output/` and `Extracted/`.

## AI assistance

This project is AI-assisted. The work is directed by a strict ruleset and curated by hand, with the aim of producing correctly labelled and commented code that matches the spirit of what the original source code would have been. We can't guarantee it's perfect, and ultimately this will always be a work in progress. If you see something that needs fixing, raise an issue, or even better, raise a PR.

## Credits and derivative works

Thanks to chaos, StaticEck, McMarkis and Drezz for their help with the disassembly.

Special thanks to smozoma and kingraph, whose past contributions to the NHL modding community made this work easier.

This project is the result of my work and the work of the people credited above. If you build anything from it, including mods, ROM or EXE hacks, ports, released forks, tools, or any other derivative work, you must credit us:

- Put the credit in your repo's README, near the top and not buried in a footer, and in the notes of every release you publish, including any text file shipped inside a release archive.
- Name me and link to this repository.
- Name everyone credited here: chaos, StaticEck, McMarkis (Mhopkinsinc) and Drezz, with special thanks to smozoma and kingraph.
- If you only use part of this repo (docs, a tool, labels, a file format description), the credit still applies.
- If you are unsure, over-credit.

Credit is the condition for using this work. Please do not release a derivative without it.
