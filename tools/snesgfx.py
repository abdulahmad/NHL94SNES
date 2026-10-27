#!/usr/bin/env python3
"""snesgfx.py - unpack and view the NHL '94 (SNES) packed data and graphics.

Packed data starts with a format word (little-endian: bytes $10,$FB are $FB10), then the unpacked size (3 bytes, big-endian). Decompress ($80C373) picks the
decompressor by the format word:
  $FB10  DecompressLZ       literal runs and copies of earlier output
  $FB46  DecompressPairs    byte pair codes, expanded recursively
  $FB30  DecompressHuffman  canonical Huffman codes, with a clue symbol for repeats, escaped bytes and the end
  $FB7A  DecompressRLE      literal runs and repeats, of bytes or byte pairs

Inputs: a file (packed files are unpacked first), or $ADDR for a packed block in the retail ROM (e.g. $818000).

Commands:
  unpack IN [-o OUT]                  unpack a packed file or block; prints the packed and unpacked sizes
  blocks [--from ADDR] [--to ADDR]    list the packed blocks found in a ROM range, with their sizes
  tiles IN [-o PNG]                   tile sheet of 4bpp tiles (--offset, --count, --columns, --pal, --palrow)
  map MAP --tiles TILES [-o PNG]      render BG map words with their tiles (--width, --map-offset, --tiles-offset, --pal)
  sprites IN [-o PNG]                 sheet of the frames of a sprite set as DrawSprite draws them (--pal, --pal-table)
  pal IN [IN ...] [-o PNG]            colour swatches: one line of 16 per palette row, the files one after another

Map words: vflip 15, hflip 14, priority 13, palette 12-10, tile 9-0. Tiles: 4bpp planar, 32 bytes per 8x8 tile, or with
--linear 4bpp linear (two pixels per byte), which $9B85C2 converts to planar (the team centre ice logos).
Sprite sets: 4-byte offsets of the frames (the first offset ends the list). A frame: piece count (byte), flags (byte,
bit 7: 16x16 block tiles), tile count, ..., at +$C/+$E the byte counts of the two tile transfers, at +$10 the offset of
its tiles; from +$16 the pieces of 7 bytes (x, y, tile and attribute word, size byte: nonzero = 16x16). The tiles go to
VRAM 16 per row: the first transfer from tile 0, the second from the row after it (DrawSprite's loader, CODE_80B3E1).
Palettes: --pal IN[:OFFSET] (BGR555 words, 16 colours per row), else grey levels. Writes PNG without other modules.

Examples:
  python3 tools/snesgfx.py unpack '$818000' -o rinktiles.bin
  python3 tools/snesgfx.py blocks --from 818000 --to 828000
  python3 tools/snesgfx.py tiles src/data/gfx/IceRink.chr.lz --columns 32 -o rinktiles.png
  python3 tools/snesgfx.py map '$92E053:6' --tiles '$818000' --width 48 -o rink.png    (6-byte header: width, height, ...)
  python3 tools/snesgfx.py sprites '$81ABDE' --pal-table 9C8497 -o logos.png
  python3 tools/snesgfx.py pal Extracted/data/gfx/Pals/BOSh.pal Extracted/data/gfx/Pals/BOSv.pal -o bos.png
  python3 tools/snesgfx.py sprites '$828000' --rom --count 64 --columns 8 --cell 64 --origin-x 32 --origin-y 48 -o frames.png
"""
import argparse
import os
import struct
import sys
import zlib

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
import rompath
ROM = rompath.rom_path()
FORMATS = {0xFB10: "LZ", 0xFB46: "pairs", 0xFB30: "Huffman", 0xFB7A: "RLE"}


def lorom_offset(addr):
    """ROM file offset of a LoROM bank:address ($80-$FF mirror)."""
    return ((addr >> 16) & 0x7F) * 0x8000 + (addr & 0x7FFF)


def lorom_addr(offset):
    return 0x800000 | (offset // 0x8000) << 16 | (0x8000 + offset % 0x8000)


def header(data, p):
    """(format word, unpacked size) of a packed block at data[p:]."""
    return data[p] | data[p + 1] << 8, data[p + 2] << 16 | data[p + 3] << 8 | data[p + 4]


def unpack_lz(src, p, size):
    """DecompressLZ: commands after the 5-byte header; each copies 0-3 (or a run of 4-112) literal bytes, then
    copies earlier output. Returns (output, end offset)."""
    i = p + 5
    out = bytearray()
    while len(out) <= size:
        b0 = src[i]
        if b0 < 0x80:                       # 2 bytes: offset up to $400, length 3-10
            b1 = src[i + 1]; i += 2
            n = b0 & 3; out += src[i:i + n]; i += n
            ln, off = ((b0 & 0x1C) >> 2) + 3, ((b0 & 0x60) << 3) + b1 + 1
        elif b0 < 0xC0:                     # 3 bytes: offset up to $4000, length 4-67
            b1, b2 = src[i + 1], src[i + 2]; i += 3
            n = b1 >> 6; out += src[i:i + n]; i += n
            ln, off = (b0 & 0x3F) + 4, ((b1 & 0x3F) << 8) + b2 + 1
        elif b0 < 0xE0:                     # 4 bytes: offset up to $20000, length 5-1028
            b1, b2, b3 = src[i + 1], src[i + 2], src[i + 3]; i += 4
            n = b0 & 3; out += src[i:i + n]; i += n
            ln, off = ((b0 & 0x0C) << 6) + b3 + 5, ((b0 & 0x10) << 12) + (b1 << 8) + b2 + 1
        elif b0 < 0xFC:                     # literal run of 4-112 bytes
            n = ((b0 & 0x1F) + 1) * 4; i += 1
            out += src[i:i + n]; i += n
            continue
        else:                               # end, with 0-3 last literal bytes
            n = b0 & 3; i += 1
            out += src[i:i + n]; i += n
            return out, i
        if off > len(out) or len(out) + ln > size:
            raise ValueError('not LZ data')
        for _ in range(ln):
            out.append(out[-off])
    raise ValueError('not LZ data')


def unpack_pairs(src, p, size):
    """DecompressPairs: header, escape byte, number of pair codes, the codes (code, first, second), then bytes.
    A pair code expands to its two bytes (recursively); the escape byte makes the next byte literal, or ends at 0."""
    esc, npairs = src[p + 5], src[p + 6]
    kind = [0] * 256                        # 0 literal, 1 escape, -1 pair code
    kind[esc] = 1
    first, second = [0] * 256, [0] * 256
    i = p + 7
    for _ in range(npairs):
        c = src[i]; first[c], second[c] = src[i + 1], src[i + 2]; kind[c] -= 1; i += 3
    out = bytearray()

    def expand(c, depth=0):
        if depth > 256 or len(out) > size:
            raise ValueError('pair codes loop')
        for x in (first[c], second[c]):
            if kind[x]:
                expand(x, depth + 1)
            else:
                out.append(x)
    while len(out) <= size:
        c = src[i]; i += 1
        if kind[c] == 0:
            out.append(c)
        elif kind[c] > 0:
            c = src[i]; i += 1
            if c == 0:
                return out, i
            out.append(c)
        else:
            expand(c)
    raise ValueError('not pair data')


def unpack_rle(src, p, size):
    """DecompressRLE: header, a mode word ($0101: bytes, else byte pairs), then control bytes: negative n copies
    -n items, positive n repeats the next item n + 1 times, 0 ends."""
    unit = 1 if src[p + 5] == 1 and src[p + 6] == 1 else 2
    i = p + 7
    out = bytearray()
    while len(out) <= size:
        c = src[i]; i += 1
        if c == 0:
            return out, i
        if c & 0x80:
            n = (c ^ 0xFF) + 1
            out += src[i:i + n * unit]; i += n * unit
        else:
            out += src[i:i + unit] * (c + 1); i += unit
    raise ValueError('not RLE data')


class Bits:
    """The Huffman bit stream: most significant bit first."""
    def __init__(self, src, i):
        self.src, self.i, self.acc, self.n = src, i, 0, 0

    def peek(self, k):
        while self.n < k:
            if self.i >= len(self.src):
                raise ValueError('Huffman data runs past the end')
            self.acc = self.acc << 8 | self.src[self.i]
            self.i += 1; self.n += 8
        return (self.acc >> (self.n - k)) & ((1 << k) - 1)

    def get(self, k):
        v = self.peek(k); self.n -= k; self.acc &= (1 << self.n) - 1
        return v

    def num(self):
        """A variable-length number: z zero bits, a 1 bit (none when z = 0: the first bit is 1), then z + 2 bits,
        plus 2^(z + 2) - 4."""
        z = 0
        if not self.get(1):
            z = 1
            while not self.get(1):
                z += 1
                if z > 16:
                    raise ValueError('not Huffman data')
        return self.get(z + 2) + (1 << (z + 2)) - 4


def unpack_huffman(src, p, size):
    """DecompressHuffman: header, the clue byte, then a bit stream: the number of codes of each length from 1 bit up
    (until the code space is full), the symbols in code order (each the count of unused byte values to skip, plus 1),
    then the codes. The clue symbol is followed by a number: n > 0 repeats the last byte n times; 0 then a 1 bit
    ends; 0 then a 0 bit and 8 bits is that byte."""
    clue = src[p + 5]
    b = Bits(src, p + 6)
    counts, code, total = [], 0, 0
    while True:
        code <<= 1
        c = b.num()
        counts.append(c); total += c; code += c
        if c and code << (16 - len(counts)) >= 0x10000 or len(counts) > 16:
            break
    used, symbols, x = [False] * 256, [], -1
    for _ in range(total):
        k = (b.num() + 1) & 0xFF or 256
        while k:
            x = (x + 1) & 0xFF
            if not used[x]:
                k -= 1
        used[x] = True; symbols.append(x)
    # canonical codes: (length, code) -> symbol
    table, code, s = {}, 0, 0
    for ln, c in enumerate(counts, 1):
        for _ in range(c):
            table[ln, code] = symbols[s]; code += 1; s += 1
        code <<= 1
    out, last = bytearray(), 0
    while len(out) <= size:
        ln, v = 0, 0
        while (ln, v) not in table:
            v = v << 1 | b.get(1); ln += 1
            if ln > len(counts):
                raise ValueError('Huffman code not in the table')
        sym = table[ln, v]
        if sym != clue:
            out.append(sym); last = sym
            continue
        n = b.num()
        if n:
            out += bytes([last]) * n
        elif b.get(1):
            return out, b.i - (b.n // 8)
        else:
            last = b.get(8); out.append(last)
    raise ValueError('Huffman output runs past the size')


UNPACK = {0xFB10: unpack_lz, 0xFB46: unpack_pairs, 0xFB30: unpack_huffman, 0xFB7A: unpack_rle}


def unpack(data, p=0):
    """Unpack the block at data[p:] as Decompress does. Returns (output, packed length, format name)."""
    fmt, size = header(data, p)
    if fmt not in UNPACK:
        raise ValueError('unknown format word $%04X' % fmt)
    out, end = UNPACK[fmt](data, p, size)
    if len(out) != size:
        raise ValueError('%s: unpacked %d bytes, header says %d' % (FORMATS[fmt], len(out), size))
    return bytes(out), end - p, FORMATS[fmt]


def load(spec):
    """The bytes of IN: $ADDR is a packed block in the ROM; a file that starts with a format word is unpacked."""
    path, ofs = spec, 0
    head, sep, tail = spec.rpartition(':')
    if sep and head and '/' not in tail and '\\' not in tail:
        path, ofs = head, int(tail, 0)       # IN:OFFSET (not the drive letter of C:/...)
    if path.startswith('$'):
        return unpack(open(ROM, 'rb').read(), lorom_offset(int(path[1:], 16)))[0][ofs:]
    data = open(path, 'rb').read()
    if len(data) > 5 and header(data, 0)[0] in UNPACK:
        data = unpack(data)[0]
    return data[ofs:]


def palette(spec):
    """256 RGB colours from IN[:OFFSET] (BGR555 words), or grey levels."""
    if not spec:
        return [(i * 17, i * 17, i * 17) for i in range(16)] * 16
    data = load(spec)
    cols = [snes_rgb(data[i] | data[i + 1] << 8) for i in range(0, len(data) - 1, 2)][:256]
    while len(cols) < 256:
        cols += cols or [(0, 0, 0)]
    return cols[:256]


def snes_rgb(v):
    return ((v & 31) * 255 // 31, ((v >> 5) & 31) * 255 // 31, ((v >> 10) & 31) * 255 // 31)


def tile_pixel(tiles, t, x, y):
    """Colour index (0-15) of pixel x, y in 4bpp planar tile t."""
    b = t * 32
    if b + 32 > len(tiles):
        return 0
    bit = 7 - x
    p0, p1 = tiles[b + 2 * y], tiles[b + 2 * y + 1]
    p2, p3 = tiles[b + 16 + 2 * y], tiles[b + 16 + 2 * y + 1]
    return ((p0 >> bit) & 1) | ((p1 >> bit) & 1) << 1 | ((p2 >> bit) & 1) << 2 | ((p3 >> bit) & 1) << 3


def linear_to_planar(data):
    """Linear 4bpp tiles (4 bytes per row of 8 pixels, high nibble first) to SNES planar, as $9B85C2 converts them: nibble
    bits 3, 2, 1, 0 go to planes 1, 0, 3, 2."""
    out = bytearray(len(data) // 32 * 32)
    for t in range(len(data) // 32):
        for y in range(8):
            p = [0, 0, 0, 0]
            for x in range(8):
                b = data[t * 32 + y * 4 + x // 2]
                n = b >> 4 if x % 2 == 0 else b & 15
                for bit, plane in ((3, 1), (2, 0), (1, 3), (0, 2)):
                    if n >> bit & 1:
                        p[plane] |= 0x80 >> x
            out[t * 32 + 2 * y], out[t * 32 + 2 * y + 1] = p[0], p[1]
            out[t * 32 + 16 + 2 * y], out[t * 32 + 17 + 2 * y] = p[2], p[3]
    return bytes(out)


def write_png(path, w, h, px, scale):
    """Write RGB pixels px[y][x] as a PNG, each pixel scale x scale."""
    rows = []
    for y in range(h):
        line = b''.join(bytes(c) * scale for c in px[y])
        rows += [b'\x00' + line] * scale

    def chunk(t, d):
        return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xFFFFFFFF)
    png = (b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w * scale, h * scale, 8, 2, 0, 0, 0))
           + chunk(b'IDAT', zlib.compress(b''.join(rows), 9)) + chunk(b'IEND', b''))
    open(path, 'wb').write(png)


def sword(d, o):
    v = d[o] | d[o + 1] << 8
    return v - 0x10000 if v & 0x8000 else v


class RomSet:
    """An unpacked sprite set in the ROM: offset o is the LoROM address base + o."""
    def __init__(self, rom, base):
        self.rom, self.base = rom, base

    def __getitem__(self, i):
        if isinstance(i, slice):
            return bytes(self[k] for k in range(i.start, i.stop))
        return self.rom[lorom_offset(self.base + i)]


def sprite_frames(d, first_frame=0, count=0):
    """The frames of a sprite set: [(pieces, vram tiles)], pieces = [(x, y, tile word, size byte)]."""
    first = d[0] | d[1] << 8 | d[2] << 16
    frames = []
    last = first // 4 if not count else min(first // 4, first_frame + count)
    for n in range(first_frame, last):
        o = d[4 * n] | d[4 * n + 1] << 8 | d[4 * n + 2] << 16
        s1, s2 = d[o + 0xC] | d[o + 0xD] << 8, d[o + 0xE] | d[o + 0xF] << 8
        src = o + (d[o + 0x10] | d[o + 0x11] << 8)
        vram = bytearray(0x2000)
        vram[:s1] = d[src:src + s1]
        if d[o + 1] & 0x80:
            t2 = (((s1 >> 1) & 0xFF00) | 0x100) >> 4
            vram[t2 * 32:t2 * 32 + s2] = d[src + s1:src + s1 + s2]
        pcs = [(sword(d, q), sword(d, q + 2), d[q + 4] | d[q + 5] << 8, d[q + 6])
               for q in range(o + 0x16, o + 0x16 + 7 * d[o], 7)]
        frames.append((pcs, vram))
    return frames


def cmd_sprites(a):
    rom = open(ROM, 'rb').read()
    data = RomSet(rom, int(a.input.lstrip('$'), 16)) if a.rom else load(a.input)
    frames = sprite_frames(data, a.first, a.count)

    def frame_palette(n):
        if a.pal_table:
            q = lorom_offset(int(a.pal_table.lstrip('$'), 16)) + 4 * (n + a.first)
            p = lorom_offset(rom[q] | rom[q + 1] << 8 | rom[q + 2] << 16 | 0x800000)
            return [snes_rgb(rom[p + 2 * i] | rom[p + 2 * i + 1] << 8) for i in range(16)]
        return palette(a.pal)[a.palrow * 16:a.palrow * 16 + 16]
    cw = ch = a.cell
    cols = a.columns
    rows = (len(frames) + cols - 1) // cols
    bg = (40, 40, 40)
    px = [[bg] * (cols * cw) for _ in range(rows * ch)]
    for n, (pcs, vram) in enumerate(frames):
        cl = frame_palette(n)
        ox, oy = (n % cols) * cw + a.origin_x, (n // cols) * ch + a.origin_y
        for x, y, t, size in pcs:
            hf, vf, tn, sz = t & 0x4000, t & 0x8000, t & 0x1FF, 16 if size else 8
            for py in range(sz):
                for qx in range(sz):
                    sx, sy = (sz - 1 - qx) if hf else qx, (sz - 1 - py) if vf else py
                    c = tile_pixel(vram, tn + (sx >> 3) + 16 * (sy >> 3), sx & 7, sy & 7)
                    X, Y = ox + x + qx, oy + y + py
                    if c and 0 <= X < cols * cw and (n // cols) * ch <= Y < (n // cols + 1) * ch:
                        px[Y][X] = cl[c]
    write_png(a.output, cols * cw, rows * ch, px, a.scale)
    print('%d frames -> %s' % (len(frames), a.output))


def cmd_unpack(a):
    if a.input.startswith('$'):
        out, n, fmt = unpack(open(ROM, 'rb').read(), lorom_offset(int(a.input[1:], 16)))
    else:
        out, n, fmt = unpack(open(a.input, 'rb').read())
    print('%s: %s, packed %d bytes ($%X), unpacked %d bytes ($%X)' % (a.input, fmt, n, n, len(out), len(out)))
    if a.output:
        open(a.output, 'wb').write(out)


def cmd_blocks(a):
    rom = open(ROM, 'rb').read()
    end = int(a.to, 16) if a.to else None
    lo = lorom_offset(int(a.start, 16))
    hi = len(rom) if end is None else ((end >> 16) & 0x7F) * 0x8000 + max(0, (end & 0xFFFF) - 0x8000)
    p = lo
    while p < hi - 5:
        fmt, size = header(rom, p)
        if fmt in UNPACK and size:
            try:
                out, n, name = unpack(rom, p)
                print('$%06X-$%06X  %-7s packed $%05X  unpacked $%05X' % (lorom_addr(p), lorom_addr(p + n - 1), name, n, size))
                p += n
                continue
            except (ValueError, IndexError):
                pass
        p += 1


def cmd_tiles(a):
    data = load(a.input)[a.offset:]
    if a.linear:
        data = linear_to_planar(data)
    n = a.count or len(data) // 32
    cols, row, w = palette(a.pal), a.palrow * 16, a.columns
    h = (n + w - 1) // w
    px = [[cols[0]] * (w * 8) for _ in range(h * 8)]
    for t in range(n):
        for y in range(8):
            for x in range(8):
                px[(t // w) * 8 + y][(t % w) * 8 + x] = cols[row + tile_pixel(data, t, x, y)]
    write_png(a.output, w * 8, h * 8, px, a.scale)
    print('%d tiles -> %s' % (n, a.output))


def cmd_map(a):
    mp = load(a.input)[a.map_offset:]
    tiles = load(a.tiles)[a.tiles_offset:]
    if a.linear:
        tiles = linear_to_planar(tiles)
    cols = palette(a.pal)
    width = a.width
    height = a.height or (len(mp) // 2 + width - 1) // width
    px = [[cols[0]] * (width * 8) for _ in range(height * 8)]
    for ty in range(height):
        for tx in range(width):
            i = 2 * (ty * width + tx)
            if i + 1 >= len(mp):
                continue
            e = mp[i] | mp[i + 1] << 8
            t, pal, hf, vf = (e & 0x3FF) - a.tile_base, (e >> 10) & 7, e & 0x4000, e & 0x8000
            for y in range(8):
                for x in range(8):
                    c = tile_pixel(tiles, t, x, y) if t >= 0 else 0
                    px[ty * 8 + (7 - y if vf else y)][tx * 8 + (7 - x if hf else x)] = cols[pal * 16 + c] if c else cols[0]
    write_png(a.output, width * 8, height * 8, px, a.scale)
    print('%d x %d tiles -> %s' % (width, height, a.output))


def cmd_pal(a):
    rows = []
    for spec in a.input:
        data = load(spec)
        cols = [snes_rgb(data[i] | data[i + 1] << 8) for i in range(0, len(data) - 1, 2)]
        rows += [cols[i:i + 16] for i in range(0, len(cols), 16)]
    w, cell = 16, a.cell
    px = []
    for row in rows:
        line = []
        for c in row + [(0, 0, 0)] * (w - len(row)):
            line += [c] * cell
        px += [line] * cell
    write_png(a.output, w * cell, len(rows) * cell, px, 1)
    print('%d palette rows -> %s' % (len(rows), a.output))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    num = lambda s: int(s, 0)

    p = sub.add_parser('unpack', help='unpack a packed file or a packed block in the ROM ($ADDR)')
    p.add_argument('input')
    p.add_argument('-o', '--output')
    p.set_defaults(func=cmd_unpack)

    p = sub.add_parser('blocks', help='list the packed blocks in a ROM range')
    p.add_argument('--from', dest='start', default='808000', help='first address (hex)')
    p.add_argument('--to', help='end address, exclusive (hex); default the end of the ROM')
    p.set_defaults(func=cmd_blocks)

    p = sub.add_parser('tiles', help='tile sheet PNG')
    p.add_argument('input')
    p.add_argument('-o', '--output', default='tiles.png')
    p.add_argument('--offset', type=num, default=0, help='byte offset of the first tile')
    p.add_argument('--count', type=num, default=0)
    p.add_argument('--columns', type=num, default=16)
    p.add_argument('--pal')
    p.add_argument('--palrow', type=num, default=0, help='palette row (16 colours) for the sheet')
    p.add_argument('--scale', type=num, default=2)
    p.add_argument('--linear', action='store_true', help='the tiles are linear 4bpp (converted as $9B85C2 does)')
    p.set_defaults(func=cmd_tiles)

    p = sub.add_parser('map', help='render BG map words with their tiles')
    p.add_argument('input')
    p.add_argument('--tiles', required=True)
    p.add_argument('-o', '--output', default='map.png')
    p.add_argument('--width', type=num, default=32, help='map width in tiles')
    p.add_argument('--height', type=num, default=0)
    p.add_argument('--map-offset', type=num, default=0)
    p.add_argument('--tiles-offset', type=num, default=0)
    p.add_argument('--tile-base', type=num, default=0, help='tile number of the first tile in --tiles')
    p.add_argument('--pal')
    p.add_argument('--scale', type=num, default=2)
    p.add_argument('--linear', action='store_true', help='the tiles are linear 4bpp (converted as $9B85C2 does)')
    p.set_defaults(func=cmd_map)

    p = sub.add_parser('sprites', help='sheet of the frames of a sprite set')
    p.add_argument('input')
    p.add_argument('-o', '--output', default='sprites.png')
    p.add_argument('--pal', help='palette IN[:OFFSET] for every frame')
    p.add_argument('--palrow', type=num, default=0, help='palette row (16 colours) of --pal')
    p.add_argument('--pal-table', help='ROM address of a table of long pointers, one 16-colour palette per frame')
    p.add_argument('--rom', action='store_true', help='IN is $ADDR of an unpacked sprite set in the ROM (frames in later banks)')
    p.add_argument('--first', type=num, default=0, help='first frame')
    p.add_argument('--count', type=num, default=0, help='number of frames (default all)')
    p.add_argument('--columns', type=num, default=6)
    p.add_argument('--cell', type=num, default=72, help='pixels per frame cell')
    p.add_argument('--origin-x', type=num, default=8, help='x of the frame origin in its cell')
    p.add_argument('--origin-y', type=num, default=8, help='y of the frame origin in its cell')
    p.add_argument('--scale', type=num, default=2)
    p.set_defaults(func=cmd_sprites)

    p = sub.add_parser('pal', help='colour swatches of palette files (BGR555 words)')
    p.add_argument('input', nargs='+', help='palette IN[:OFFSET]: a .pal file, a packed .pal.lz ... or $ADDR')
    p.add_argument('-o', '--output', default='pal.png')
    p.add_argument('--cell', type=num, default=16, help='pixels per colour')
    p.set_defaults(func=cmd_pal)

    a = ap.parse_args()
    a.func(a)


if __name__ == '__main__':
    main()
