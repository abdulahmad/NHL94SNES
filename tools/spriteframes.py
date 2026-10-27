#!/usr/bin/env python3
"""spriteframes.py - write the source of SpriteFrames, the main DrawSprite sprite set ($828000, frames in banks $82-$8E).

SpriteFrames starts with a table of 4-byte offsets from $828000, one per frame (the first offset ends the table). The frames
follow in order, contiguous, in the ROM half of each bank. A frame: piece count, flags (bit 7: tiles in 16x16 blocks),
tile count, the box of its pixels (left, right, top, bottom; nothing reads it), the byte counts of the two tile
transfers, the offset of its tiles, the hot spot x / y (signed bytes, GetHot) and the stick point x / y (GetFrameHot),
the pieces (x, y, tile and attribute word, size byte), then its tiles. Frame labels are SpriteFrame_<group>_<n>, from the
SPF group equates in src/ram94s.asm (frame numbers count from 1: frame SPFgroup+n). The source writes the header and pieces, and includes the
tiles from the bank's data asset src/data/gfx/SpriteFramesXX.bin (tools/extractAssets94s.js assets).

Commands:
  frames FROM TO    the source of the frames that start at FROM up to (not including) TO, e.g. frames 82908B 82A000;
                    prints where the last one ends, which is where the next segment starts
  table             the offset table (dd lines)
  info              per bank: the frames, and the asset range for tools/extractAssets94s.js

Example:
  python3 tools/spriteframes.py frames 828F40 829000 > frames.asm
"""
import argparse
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.path.join(ROOT, 'lst', 'nhl94snes.sfc')
BASE = 0x828000
rom = open(ROM, 'rb').read()


def spf_groups():
    """[(first frame, group)] from the SPF equates in src/ram94s.asm."""
    g = []
    for l in open(os.path.join(ROOT, 'src', 'ram94s.asm'), encoding='latin-1'):
        m = re.match(r'SPF(\w+) = (\d+)\b', l)
        if m:
            g.append((int(m[2]), m[1]))
    return sorted(g)


GROUPS = spf_groups()


def label(n):
    """Label of frame index n (0-based; frame number n + 1)."""
    f = n + 1
    first, name = max((b, g) for b, g in GROUPS if b <= f)
    return 'SpriteFrame_%s_%d' % (name, f - first)


def lorom_offset(a):
    return ((a >> 16) & 0x7F) * 0x8000 + (a & 0x7FFF)


def byte(a):
    return rom[lorom_offset(a)]


def word(a):
    return byte(a) | byte(a + 1) << 8


def sword(a):
    v = word(a)
    return v - 0x10000 if v & 0x8000 else v


def frame_addrs():
    n = word(BASE) // 4
    return [BASE + (word(BASE + 4 * i) | word(BASE + 4 * i + 2) << 16) for i in range(n)]


def frame_end(a):
    tiles, s1, s2 = word(a + 0x10), word(a + 0xC), word(a + 0xE)
    return a + tiles + s1 + (s2 if byte(a + 1) & 0x80 else 0)


def asset_range(bank, addrs):
    """First and end address of the frames in a bank: the range of its asset SpriteFrames<bank>.bin."""
    inbank = [a for a in addrs if a >> 16 == bank]
    return min(inbank), max(frame_end(a) for a in inbank)


def frame_source(n, a, asset_start):
    pieces, tiles = byte(a), word(a + 0x10)
    if tiles != 0x16 + 7 * pieces:
        sys.exit('frame %d at $%06X: tiles at +$%X, not after its pieces' % (n, a, tiles))
    lab = label(n)
    lines = [lab + ':',
             '\tdb $%02X,$%02X' % (byte(a), byte(a + 1)),
             '\tdw $%04X' % word(a + 2),
             '\tdw %d,%d,%d,%d' % (sword(a + 4), sword(a + 6), sword(a + 8), sword(a + 10)),
             '\tdw $%04X,$%04X' % (word(a + 0xC), word(a + 0xE)),
             '\tdw .tiles-' + lab,
             '\tdb ' + ','.join('$%02X' % byte(a + i) for i in range(0x12, 0x16))]
    for k in range(pieces):
        q = a + 0x16 + 7 * k
        lines.append('\tdw %d,%d,$%04X : db $%02X' % (sword(q), sword(q + 2), word(q + 4), byte(q + 6)))
    lines += ['.tiles:', '\tincbin "../../../Extracted/data/gfx/SpriteFrames%02X.bin":%d..%d'
              % (a >> 16, a + tiles - asset_start, frame_end(a) - asset_start)]
    return lines


def cmd_frames(args):
    lo, hi = int(args.start, 16), int(args.to, 16)
    addrs = frame_addrs()
    out, end = [], None
    for n, a in enumerate(addrs):
        if lo <= a < hi:
            if end is not None and a != end:
                sys.exit('frames not contiguous at $%06X' % a)
            out += frame_source(n, a, asset_range(a >> 16, addrs)[0])
            end = frame_end(a)
    if not out:
        sys.exit('no frame starts in $%06X-$%06X' % (lo, hi))
    print('\n'.join(out))
    print('; next segment starts at $%06X' % end, file=sys.stderr)


def cmd_table(args):
    n = len(frame_addrs())
    for i in range(0, n, 4):
        print('\tdd ' + ','.join(label(k) + '-SpriteFrames' for k in range(i, min(n, i + 4))))


def cmd_info(args):
    addrs = frame_addrs()
    for bank in sorted({a >> 16 for a in addrs}):
        nums = [n for n, a in enumerate(addrs) if a >> 16 == bank]
        first, end = asset_range(bank, addrs)
        print("bank $%02X: frames %d-%d   ('SpriteFrames%02X.bin', 0x%06X, 0x%06X)" % (bank, nums[0], nums[-1], bank, first, end))


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    p = sub.add_parser('frames', help='source of the frames that start in a range')
    p.add_argument('start', help='first address (hex)')
    p.add_argument('to', help='end address, exclusive (hex)')
    p.set_defaults(func=cmd_frames)
    sub.add_parser('table', help='the offset table').set_defaults(func=cmd_table)
    sub.add_parser('info', help='frames and asset range per bank').set_defaults(func=cmd_info)
    a = ap.parse_args()
    a.func(a)


if __name__ == '__main__':
    main()
