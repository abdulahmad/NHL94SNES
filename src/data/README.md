# src/data/

The data the bank files include by name. Graphics and sound binaries are not committed. `tools/prebuild.js` extracts
them from the ROM into `Extracted/data/gfx/` and `Extracted/data/sound/` (gitignored) and writes
`Extracted/.extract-complete.json` last. The asm `incbin`s those files, so the build stays byte-identical.
`tools/extractAssets94s.js` lists every binary asset with its ROM range (`assets`). `node tools/extractAssets94s.js nhl94retail.sfc --check`
compares `Extracted/` with the ROM.

- `gfx/`: graphics source. Packed and unpacked tiles, maps, palettes and sprite sets. The binary is in `Extracted/data/gfx/`;
  the palettes are in its `Pals/` folder and the player photos (`Card<NNN>.lin.*` and the `NoPic*` stand-ins, the
  PlayerPhotoTable pictures) in its `PlayerCards/` folder, as the 94G project's `Graphics/Pals` and `Graphics/PlayerCards`.
- `sound/`: sound source. The upload blocks are in `Extracted/data/sound/`.
- `text/`: the text tables as source, one file per table named after its label (`incsrc "data/text/<Label>.asm"` at its
  place in the bank file). Strings are written with the `String` macro (length word, then the text); records with
  position codes ($9F, $AF or $BF, then two position bytes) keep their length word.
- `teamdata94s.asm`: anonymized (player names and team nicknames are placeholders; `tools/build.js` (the names step) puts the real ones back from the ROM into
  `output/names/`, which the bank files include; so are `text/LongNYI.asm` and `text/PregameText.asm`). The team database (TeamList, the team records with their players, playoffseats), as
  NHLPA93SNES `teamdata93s.asm`; bank9C_A000 includes it.

Where a header is already spelled as `db`/`dw`, the `incbin` is the rest of that asset (`incbin "../../../Extracted/data/gfx/<name>":<start>..<end>`, decimal, end exclusive). IceRinkTiles and TeamLogoSprites are that shape. SpriteFrames keeps one `Extracted` file per bank; the source writes each frame's header and pieces and includes that frame's tiles by range. The file is still a ROM cut of the frame region, not one `.chr` per frame.
`tools/snesgfx.py` unpacks the packed formats and renders tiles, maps, sprite sets and palettes to PNG. `tools/songwav.py` plays the organ songs (TeamSongs / DefaultSongs) and decodes the sample blocks to WAV. `tools/spc700dis.py` disassembles sound CPU code in the asar syntax of `tables/SoundDriver.asm`.

The file extension gives the format:

| Extension | Format |
|-----------|--------|
| `.chr` | SNES 4bpp planar tiles, not packed |
| `.chr.lz`, `.chr.huf`, `.chr.pairs` | SNES 4bpp tiles packed for DecompressLZ (format word $FB10), DecompressHuffman ($FB30), DecompressPairs ($FB46) |
| `.lin.huf`, `.lin.lz`, `.lin.pairs` | Linear 4bpp tiles (converted to planar by $9B85C2), packed for DecompressHuffman, DecompressLZ, DecompressPairs. The team centre ice logos and the player photos |
| `.spr` | A DrawSprite sprite set, not packed |
| `.spr.huf` | A DrawSprite sprite set packed for DecompressHuffman |
| `.map.lz`, `.map.huf` | Map words packed for DecompressLZ, DecompressHuffman |
| `.map.rle` | Map words (or map bytes after a $0010 header word) packed for DecompressRLE ($FB7A) |
| `.pal` | Colours, not packed: BGR555 words (bit 15 unused), 16 per palette row |
| `.pal.lz`, `.pal.huf`, `.pal.rle` | Colours packed for DecompressLZ, DecompressHuffman, DecompressRLE |
| `.lz`, `.huf` | Packed for DecompressLZ, DecompressHuffman, contents not identified yet |
| `SpriteFramesXX.bin` | The SpriteFrames frames of bank $XX, not packed. The source writes their headers and pieces, and includes their tiles from this file |
| `.spc` | A BRR sound sample for SPCUploadBlock: big-endian loop point and length (multiples of the 9-byte BRR block), then the BRR blocks |

The palettes are in `Extracted/data/gfx/Pals/`, one file per label, as the 94G project's `Graphics/Pals`. The team uniform
colours (HomeUniformPalettes, AwayUniformPalettes) are one file per team with the 94G names: `<team>h.pal` (home, white
jerseys) and `<team>v.pal` (away). The per-team logo, photo and team block colours are `LogoPalette<team>.pal`,
`PhotoPalette<team>.pal` and `TeamBlockPalette<team>.pal` (team order: the tables in bank $9C / $9D;
`LogoPaletteNHL` / `LogoPaletteNHLPA` are the NHL shield and NHLPA logo). `python3 tools/snesgfx.py pal FILE ... -o PNG`
draws them as swatches (one line per 16 colours); `--pal FILE` of the other commands takes them too.

A map (unpacked) starts with three words: width, height, and a format word that no code reads ($0308 in the 4bpp background maps, $0010 in the mode 7 maps EALogoMap, LicenceNHLPAMap and TitlePuckMap); the map words follow at +6.

An asset takes the name of the label that includes it (`MenuBackTiles.chr.lz`); one not identified yet is named by its address (`DATA8_XXXXXX.<format>`).
