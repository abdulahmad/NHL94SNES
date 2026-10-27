#!/usr/bin/env python3
"""spc700dis.py - disassemble SPC700 (sound CPU) code from the ROM in asar `arch spc700` syntax (the syntax
src/data/tables/SoundDriver.asm uses; every opcode round-trips through asar 1.91).

Usage: python3 tools/spc700dis.py ROMADDR LENGTH BASE [ENTRY ...]
  ROMADDR  first byte in the ROM (hex SNES address), LENGTH bytes (hex), BASE its sound RAM address (hex);
  ENTRY    extra code entry points (hex sound RAM addresses) besides BASE, e.g. the handlers of a jmp (table+x).
Prints address, bytes and instruction; branch / jump / call targets in range get labels lXXXX; bytes no path reaches
are listed as db.
Operand codes in the templates: D dp byte, A abs word, I immediate, R relative branch, S/T dp source/dest of the
three-byte dp,dp forms (byte 1 = source, byte 2 = dest), M 13-bit abs + 3-bit bit (mem.bit), U pcall byte."""

T = {}
for b, m in ((0x00, 'or'), (0x20, 'and'), (0x40, 'eor'), (0x60, 'cmp'), (0x80, 'adc'), (0xA0, 'sbc')):
    T[b + 0x04] = m + ' a,D'
    T[b + 0x05] = m + ' a,A'
    T[b + 0x06] = m + ' a,(x)'
    T[b + 0x07] = m + ' a,(D+x)'
    T[b + 0x08] = m + ' a,#I'
    T[b + 0x09] = m + ' T,S'
    T[b + 0x14] = m + ' a,D+x'
    T[b + 0x15] = m + ' a,A+x'
    T[b + 0x16] = m + ' a,A+y'
    T[b + 0x17] = m + ' a,(D)+y'
    T[b + 0x18] = m + ' T,#I'
    T[b + 0x19] = m + ' (x),(y)'
for n in range(16):
    T[n * 0x10 + 0x01] = 'tcall %d' % n
for n in range(8):
    T[n * 0x20 + 0x02] = 'set1 D.%d' % n
    T[n * 0x20 + 0x12] = 'clr1 D.%d' % n
    T[n * 0x20 + 0x03] = 'bbs D.%d,R' % n
    T[n * 0x20 + 0x13] = 'bbc D.%d,R' % n
T.update({
    0x00: 'nop', 0x0A: 'or1 c,M', 0x0B: 'asl D', 0x0C: 'asl A', 0x0D: 'push p', 0x0E: 'tset A,a', 0x0F: 'brk',
    0x10: 'bpl R', 0x1A: 'decw D', 0x1B: 'asl D+x', 0x1C: 'asl a', 0x1D: 'dec x', 0x1E: 'cmp x,A', 0x1F: 'jmp (A+x)',
    0x20: 'clrp', 0x2A: 'or1 c,!M', 0x2B: 'rol D', 0x2C: 'rol A', 0x2D: 'push a', 0x2E: 'cbne D,R', 0x2F: 'bra R',
    0x30: 'bmi R', 0x3A: 'incw D', 0x3B: 'rol D+x', 0x3C: 'rol a', 0x3D: 'inc x', 0x3E: 'cmp x,D', 0x3F: 'call A',
    0x40: 'setp', 0x4A: 'and1 c,M', 0x4B: 'lsr D', 0x4C: 'lsr A', 0x4D: 'push x', 0x4E: 'tclr A,a', 0x4F: 'pcall U',
    0x50: 'bvc R', 0x5A: 'cmpw ya,D', 0x5B: 'lsr D+x', 0x5C: 'lsr a', 0x5D: 'mov x,a', 0x5E: 'cmp y,A', 0x5F: 'jmp A',
    0x60: 'clrc', 0x6A: 'and1 c,!M', 0x6B: 'ror D', 0x6C: 'ror A', 0x6D: 'push y', 0x6E: 'dbnz D,R', 0x6F: 'ret',
    0x70: 'bvs R', 0x7A: 'addw ya,D', 0x7B: 'ror D+x', 0x7C: 'ror a', 0x7D: 'mov a,x', 0x7E: 'cmp y,D', 0x7F: 'reti',
    0x80: 'setc', 0x8A: 'eor1 c,M', 0x8B: 'dec D', 0x8C: 'dec A', 0x8D: 'mov y,#I', 0x8E: 'pop p', 0x8F: 'mov T,#I',
    0x90: 'bcc R', 0x9A: 'subw ya,D', 0x9B: 'dec D+x', 0x9C: 'dec a', 0x9D: 'mov x,sp', 0x9E: 'div ya,x', 0x9F: 'xcn a',
    0xA0: 'ei', 0xAA: 'mov1 c,M', 0xAB: 'inc D', 0xAC: 'inc A', 0xAD: 'cmp y,#I', 0xAE: 'pop a', 0xAF: 'mov (x+),a',
    0xB0: 'bcs R', 0xBA: 'movw ya,D', 0xBB: 'inc D+x', 0xBC: 'inc a', 0xBD: 'mov sp,x', 0xBE: 'das a', 0xBF: 'mov a,(x+)',
    0xC0: 'di', 0xC4: 'mov D,a', 0xC5: 'mov A,a', 0xC6: 'mov (x),a', 0xC7: 'mov (D+x),a', 0xC8: 'cmp x,#I', 0xC9: 'mov A,x',
    0xCA: 'mov1 M,c', 0xCB: 'mov D,y', 0xCC: 'mov A,y', 0xCD: 'mov x,#I', 0xCE: 'pop x', 0xCF: 'mul ya',
    0xD0: 'bne R', 0xD4: 'mov D+x,a', 0xD5: 'mov A+x,a', 0xD6: 'mov A+y,a', 0xD7: 'mov (D)+y,a', 0xD8: 'mov D,x',
    0xD9: 'mov D+y,x', 0xDA: 'movw D,ya', 0xDB: 'mov D+x,y', 0xDC: 'dec y', 0xDD: 'mov a,y', 0xDE: 'cbne D+x,R', 0xDF: 'daa a',
    0xE0: 'clrv', 0xE4: 'mov a,D', 0xE5: 'mov a,A', 0xE6: 'mov a,(x)', 0xE7: 'mov a,(D+x)', 0xE8: 'mov a,#I', 0xE9: 'mov x,A',
    0xEA: 'not1 M', 0xEB: 'mov y,D', 0xEC: 'mov y,A', 0xED: 'notc', 0xEE: 'pop y', 0xEF: 'sleep',
    0xF0: 'beq R', 0xF4: 'mov a,D+x', 0xF5: 'mov a,A+x', 0xF6: 'mov a,A+y', 0xF7: 'mov a,(D)+y', 0xF8: 'mov x,D',
    0xF9: 'mov x,D+y', 0xFA: 'mov T,S', 0xFB: 'mov y,D+x', 0xFC: 'inc y', 0xFD: 'mov y,a', 0xFE: 'dbnz y,R', 0xFF: 'stop',
})
assert len(T) == 256, len(T)


def decode(mem, pc, base, label=None):
    """(text, length, branch target or None, abs operand or None) of the instruction at mem[pc - base]."""
    o = pc - base
    op = mem[o]
    t = T[op]
    args = mem[o + 1:o + 6]
    out = ''
    i = 0
    tgt = None
    absv = None
    needw = False
    # operand bytes are consumed in template order, except the dp,dp / dp,#imm forms (source byte first)
    if 'T,S' in t:
        s, d = args[0], args[1]
        return t.replace('T', '$%02X' % d).replace('S', '$%02X' % s), 3, None, None
    if 'T,#I' in t:
        imm, d = args[0], args[1]
        return t.replace('T', '$%02X' % d).replace('#I', '#$%02X' % imm), 3, None, None
    k = 0
    pos = 0
    res = []
    for ch in t:
        if ch == 'D':
            v = args[k]; k += 1
            res.append('$%02X' % v)
        elif ch == 'I':
            v = args[k]; k += 1
            res.append('$%02X' % v)
        elif ch == 'U':
            v = args[k]; k += 1
            res.append('$%02X' % v)
        elif ch == 'A':
            v = args[k] | args[k + 1] << 8; k += 2
            absv = v
            res.append(label(v) if label and label(v) else '$%04X' % v)
            if v < 0x100:
                needw = True
        elif ch == 'M':
            v = args[k] | args[k + 1] << 8; k += 2
            res.append('$%04X.%d' % (v & 0x1FFF, v >> 13))
        elif ch == 'R':
            r = args[k]; k += 1
            if r >= 0x80: r -= 0x100
            tgt = pc + 1 + k + r
            res.append(label(tgt) if label and label(tgt) else '$%04X' % tgt)
        else:
            res.append(ch)
    text = ''.join(res)
    if needw:
        sp = text.index(' ')
        text = text[:sp] + '.w' + text[sp:]
    return text, 1 + k, tgt, absv

def main():
    import os, sys
    if len(sys.argv) < 4:
        sys.exit(__doc__)
    import rompath
    rom = open(rompath.rom_path(), 'rb').read()
    a, n, base = int(sys.argv[1], 16), int(sys.argv[2], 16), int(sys.argv[3], 16)
    o = ((a >> 16) & 0x7F) * 0x8000 + (a & 0x7FFF)
    mem = rom[o:o + n]; top = base + n
    code = {}; labels = set(); todo = [base] + [int(x, 16) for x in sys.argv[4:]]
    while todo:
        pc = todo.pop()
        while base <= pc < top and pc not in code:
            op = mem[pc - base]
            text, k, tgt, absv = decode(mem, pc, base)
            code[pc] = k
            if tgt is not None and base <= tgt < top: todo.append(tgt); labels.add(tgt)
            if op in (0x3F, 0x5F) and absv is not None and base <= absv < top: todo.append(absv); labels.add(absv)
            if op in (0x6F, 0x7F, 0xFF, 0xEF, 0x5F, 0x2F, 0x1F):
                break
            pc += k
    lab = lambda v: 'l%04X' % v if v in labels else None
    pc = base
    while pc < top:
        if pc in labels:
            print('l%04X:' % pc)
        if pc in code:
            text, k, _, _ = decode(mem, pc, base, label=lab)
            print('	%-24s ; %04X  %s' % (text, pc, mem[pc - base:pc - base + k].hex()))
            pc += k
        else:
            print('	db $%02X			 ; %04X' % (mem[pc - base], pc))
            pc += 1


if __name__ == '__main__':
    main()
