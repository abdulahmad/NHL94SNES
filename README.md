# NHL '94 (SNES)

> **Work in progress:** this disassembly is unfinished and unpolished, and is being actively worked on. Expect labels, file layout and docs to change.

## 🚧 Current Status

- McMarkis has done a cleanup pass.
- Remaining: aligning it with the 93 Genesis, 94 Genesis and 93 SNES cleanups, extracting all the data, naming data properly, and labeling music, frame lists and animations.

**AI agent: start with [START_HERE.md](START_HERE.md).**

Bitwise rebuild of NHL '94 for the Super Nintendo, assembled with asar 1.91. The full build is byte-identical to the retail ROM
(SHA-1 `10dcd21be9c5542e82b0b94473bf5ff569b36cf5`, 1048576 bytes, LoROM FastROM, header title `NHL '94`, version 1.0).
The ROM is not included: put your own dump at `lst/nhl94snes.sfc`; the build tells you if it is missing or the wrong one.

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
- `tools/prebuild.py` ROM check, run by every build. `tools/extract.py` lists the assets' ROM ranges and checks or rewrites them.
- `tools/disasm65816.py` quick pass for a segment's starting text (`output/quickpass/`).
- `tools/verify_segment.sh`, `tools/verify_all.sh` segment and clean full checks.
- `docs/HANDOFF.md` state of the work, `docs/name_map.csv` name history.

## Build

`sh tools/setup.sh` (or `tools\setup.ps1`), then `./build.sh` (or `build.ps1`). It writes `output/nhl94snes.sfc` and prints MATCH / MISMATCH.
