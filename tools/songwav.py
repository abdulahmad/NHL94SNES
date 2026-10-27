#!/usr/bin/env python3
"""songwav.py - play the NHL '94 (SNES) organ songs and sound samples to WAV files.

The songs are the TeamSongs / DefaultSongs data that MusicStart plays. The music player runs on the main CPU (SequencerTick,
StepTrack, ReadTrackEvent, ReadVarLen) and starts each note as a sound on a voice (StartSoundVoice). This tool follows the
same rules:
  Timing     each frame adds 64 to a counter; a tick passes each time it reaches (10080 / tempo) & $FF (the header's
             second byte is the tempo; event $DD sets the divisor)
  Events     a variable-length wait, then a status byte: below $D9 a note (number, velocity, variable-length duration);
             $D9/$DA end; $E2 marks the loop start, $DB jumps back to it; $DC sets the instrument (a sound number;
             $6A is sound $14); $DE / controller 7 ($DF 7,v) set the track volume; $E5 is a pitch bend (not played)
  Instrument the sound's entry in GameSfxTable: byte 4 is added to the note (pitch PitchTable[(note + byte 4) & $7F],
             $1000 = the sample's own rate at 32 kHz), bytes 18/19 are the left/right volume, scaled by the track
             volume / 128; byte 20 is the sample, a block in GameSampleList
  Velocity   VolumeCurve[velocity] / 64
  Samples    BRR blocks of 9 bytes after a 4-byte header: the loop point and the length (big-endian)
Not played: volume envelopes, echo and pitch bends, so notes start and stop more sharply than in the game. A looping
track plays its loop twice.

Needs nhl94retail.sfc and the symbol file from a build (output/retail/obj/nhl94snes.sym). Songs and samples are given by label or
$ADDR. Writes 16-bit stereo WAV at 32 kHz without other modules.

Commands:
  list                        the songs, with the team slots that play them, and the teams with none
  song NAME... [-o OUT]       render songs (-o: a file for one song, else a folder; default the current folder)
  all [-o DIR]                render every song in TeamSongs / DefaultSongs, named by label and team slots
  sample NAME... [-o OUT]     decode samples (--rate, default 8000; a looping sample repeats its loop for a second)

Song slots (PlayTeamSong A = slot, six per home team; a team with no song for a slot gets one of the 8 DefaultSongs at
random). At a faceoff (puckfaceoff2), when no music plays: 0 the first faceoff of a period; 1 the home team has fewer
players in the penalty box (PBnum); 4 the home team has more; 2 otherwise, one time in 4. 3 a home goal (Goal). 5 in the
third period (gsp 2), when no music plays, a 1 in 4096 chance each frame (Gameloop).

Examples:
  python3 tools/songwav.py list
  python3 tools/songwav.py song SongBrassBonanza -o brass.wav
  python3 tools/songwav.py all -o songs
  python3 tools/songwav.py sample SampleOrgan SampleEASportsVoice
"""
import argparse
import os
import re
import struct
import sys
from array import array

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROM = os.path.join(ROOT, 'nhl94retail.sfc')
SYM = os.path.join(ROOT, 'output', 'retail', 'obj', 'nhl94snes.sym')
TABLES = os.path.join(ROOT, 'src', 'data', 'tables')
SR = 32000
NONE = '-'

rom = b''
sym = {}


def load():
    global rom
    if not os.path.exists(SYM):
        sys.exit('no %s: run ./build.sh first' % SYM)
    rom = open(ROM, 'rb').read()
    for line in open(SYM):
        p = line.split()
        if len(p) == 2 and ':' in p[0]:
            sym[p[1]] = int(p[0].replace(':', ''), 16)


def off(addr):
    return ((addr >> 16) & 0x7F) * 0x8000 + (addr & 0x7FFF)


def addr(name):
    if name.startswith('$'):
        return int(name[1:], 16)
    if name not in sym:
        sys.exit('unknown label ' + name)
    return sym[name]


def word(o):
    return rom[o] | rom[o + 1] << 8


def table(fname, label):
    """The entries of a dd / dw table in src/data/tables (labels, or NONE for $FFFFFFFF)."""
    text = open(os.path.join(TABLES, fname)).read().split(label + ':', 1)[1]
    out = []
    for line in text.splitlines()[0:]:
        code = line.split(';')[0]
        if re.match(r'\s*\w+:', code) and out:
            break
        m = re.match(r'\s*(?:\w+:)?\s*d[dw]\s+(.*)', code)
        if m:
            out += [NONE if x.strip() == '$FFFFFFFF' else x.strip() for x in m.group(1).split(',')]
    return out


def teams():
    text = open(os.path.join(ROOT, 'src', 'data', 'text', 'TeamPlaceNames.asm')).read()
    return re.findall(r'\.(\w+)', ''.join(re.findall(r'dw\s+(.*)', text)))


def song_slots():
    """Song label -> ['BOS0', ...], with 'DefaultSongs' for the random pool."""
    names = teams()
    ts = table('TeamSongs.asm', 'TeamSongs')
    slots = {}
    for i, s in enumerate(ts):
        if s != NONE:
            slots.setdefault(s, []).append('%s%d' % (names[i // 6], i % 6))
    for s in table('DefaultSongs.asm', 'DefaultSongs'):
        slots.setdefault(s, []).append('DefaultSongs')
    empty = [names[t] for t in range(len(ts) // 6) if all(x == NONE for x in ts[t * 6:t * 6 + 6])]
    return slots, empty


def brr(o, n):
    out = []
    p1 = p2 = 0
    for i in range(o, o + n - 8, 9):
        h = rom[i]
        r = h >> 4
        f = (h >> 2) & 3
        for j in range(16):
            b = rom[i + 1 + j // 2]
            v = (b >> 4) if j % 2 == 0 else (b & 15)
            if v >= 8:
                v -= 16
            s = (v << r) >> 1 if r <= 12 else (-2048 if v < 0 else 0)
            if f == 1:
                s += p1 + ((-p1) >> 4)
            elif f == 2:
                s += (p1 << 1) + ((-((p1 << 1) + p1)) >> 5) - p2 + (p2 >> 4)
            elif f == 3:
                s += (p1 << 1) + ((-(p1 + (p1 << 2) + (p1 << 3))) >> 6) - p2 + (((p2 << 1) + p2) >> 4)
            s = max(-32768, min(32767, s))
            s = (s << 1) & 0xFFFF
            s = (s - 65536 if s >= 32768 else s) >> 1
            p2, p1 = p1, s
            out.append(s)
        if h & 1:
            break
    return out


def sample(name):
    """Decoded sample (floats) and the loop start in samples (None: one-shot)."""
    o = off(addr(name))
    loop = rom[o] << 8 | rom[o + 1]
    n = rom[o + 2] << 8 | rom[o + 3]
    s = [x / 32768.0 for x in brr(o + 4, n)]
    return s, (loop // 9 * 16 if loop < n else None)


class Sounds:
    def __init__(self):
        self.samples = table('GameSampleList.asm', 'GameSampleList')
        self.sfx = off(sym['GameSfxTable'])
        pt = off(sym['PitchTable'])
        self.pitch = [word(pt + 2 * i) for i in range(128)]
        vc = off(sym['VolumeCurve'])
        self.curve = rom[vc:vc + 128]
        self.cache = {}

    def sound(self, n):
        e = self.sfx + word(self.sfx + 2 * n)
        return rom[e + 4], rom[e + 18], rom[e + 19], self.samples[rom[e + 20]]

    def wave(self, name):
        if name not in self.cache:
            self.cache[name] = sample(name)
        return self.cache[name]


def varlen(p):
    v = 0
    while True:
        b = rom[p]
        p += 1
        v = (v << 7) | (b & 0x7F)
        if not b & 0x80:
            return v, p


def read_track(p):
    """The notes of a track: (tick, duration, sound, note, velocity, volume); and its last tick, and tempo changes."""
    notes, tempos = [], []
    tick, inst, vol, mark, loops, first = 0, 0x0B, 127, p, 0, True
    for _ in range(20000):
        d, p = varlen(p)
        if not first:
            tick += d
        first = False
        st = rom[p]
        p += 1
        if st < 0xD9:
            vel = rom[p]
            dur, p = varlen(p + 1)
            notes.append((tick, dur, inst, st, vel, vol))
        elif st in (0xD9, 0xDA):
            break
        elif st == 0xDB:
            loops += 1
            if loops > 1:
                break
            p, first = mark, True
        elif st == 0xE7:
            p += 1 + rom[p]
        elif st in (0xDC, 0xEA, 0xDD, 0xDE, 0xE2):
            a = rom[p]
            p += 1
            if st == 0xDC:
                inst = 0x14 if a == 0x6A else a
            elif st == 0xDE:
                vol = a
            elif st == 0xDD:
                tempos.append((tick, a))
            elif st == 0xE2:
                mark = p - 2
        elif st == 0xDF:
            if rom[p] == 7:
                vol = rom[p + 1]
            p += 2
        elif st == 0xE5:
            p += 2
    return notes, tick, tempos


def render(name, snd):
    """Stereo float buffers (left, right) and the song's tempo."""
    base = addr(name)
    o = off(base)
    tempo = rom[o + 1]
    notes, tempos, end = [], [], 0
    k = 0
    while word(o + 8 + 2 * k):
        n, t, tc = read_track(o + word(o + 8 + 2 * k))
        notes += n
        tempos += tc
        end = max(end, t)
        k += 1
    # tick -> seconds
    last = max([t + d for t, d, *_ in notes] + [end]) + 2
    div = dict(tempos)
    secs, acc, frame, T = [], 0, 0, (10080 // tempo) & 0xFF
    while len(secs) <= last and frame < 60 * 600:
        acc += 64
        while acc >= T and len(secs) <= last:
            secs.append(frame / 60.0)
            acc -= T
            T = div.get(len(secs) - 1, T)
        frame += 1
    secs += [secs[-1]] * (last + 2 - len(secs))
    size = int((secs[last] + 2.0) * SR)
    left, right = array('f', bytes(4 * size)), array('f', bytes(4 * size))
    rel = int(0.03 * SR)
    for t, dur, inst, note, vel, vol in notes:
        tr, lv, rv, smp = snd.sound(inst)
        wave, loop = snd.wave(smp)
        step = snd.pitch[(note + tr) & 0x7F] / 4096.0
        c = snd.curve[vel & 0x7F]
        g = (1.0 if c == 0x40 else c / 64.0) * vol / 128.0
        gl, gr = g * lv / 128.0, g * rv / 128.0
        t0 = int(secs[t] * SR)
        n = int(secs[min(t + dur, len(secs) - 1)] * SR) - t0 + rel
        span = len(wave) - 1
        for i in range(max(0, n)):
            pos = i * step
            if pos >= span:
                if loop is None:
                    break
                pos = loop + (pos - loop) % (len(wave) - loop)
            j = int(pos)
            fr = pos - j
            w = wave[j] * (1 - fr) + wave[min(j + 1, span)] * fr
            if i > n - rel:
                w *= (n - i) / rel
            if t0 + i < size:
                left[t0 + i] += w * gl
                right[t0 + i] += w * gr
    return left, right, tempo


def wavwrite(path, left, right, rate=SR):
    peak = max(max(map(abs, left)), max(map(abs, right))) or 1.0
    k = 0.8 * 32767 / peak
    data = array('h', [0]) * (2 * len(left))
    data[0::2] = array('h', (int(x * k) for x in left))
    data[1::2] = array('h', (int(x * k) for x in right))
    if sys.byteorder == 'big':
        data.byteswap()
    d = data.tobytes()
    with open(path, 'wb') as f:
        f.write(b'RIFF' + struct.pack('<I', 36 + len(d)) + b'WAVEfmt ' +
                struct.pack('<IHHIIHH', 16, 1, 2, rate, rate * 4, 4, 16) + b'data' + struct.pack('<I', len(d)) + d)


def outpath(o, name, many):
    if o and not many and not os.path.isdir(o):
        return o
    d = o or '.'
    os.makedirs(d, exist_ok=True)
    return os.path.join(d, name)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest='cmd', required=True)
    sub.add_parser('list')
    p = sub.add_parser('song')
    p.add_argument('names', nargs='+')
    p.add_argument('-o')
    p = sub.add_parser('all')
    p.add_argument('-o', default='songs')
    p = sub.add_parser('sample')
    p.add_argument('names', nargs='+')
    p.add_argument('-o')
    p.add_argument('--rate', type=int, default=8000)
    a = ap.parse_args()
    load()
    if a.cmd == 'list':
        slots, empty = song_slots()
        for s in sorted(slots, key=lambda x: addr(x)):
            print('%-14s $%06X  %s' % (s, addr(s), ' '.join(slots[s])))
        print('no songs: %s (they get DefaultSongs)' % ' '.join(empty))
    elif a.cmd in ('song', 'all'):
        snd = Sounds()
        if a.cmd == 'all':
            slots, _ = song_slots()
            todo = [(s, '%s - %s.wav' % (s, ' '.join(slots[s]))) for s in sorted(slots, key=lambda x: addr(x))]
        else:
            todo = [(s, s.lstrip('$') + '.wav') for s in a.names]
        for s, fname in todo:
            left, right, tempo = render(s, snd)
            path = outpath(a.o, fname, len(todo) > 1 or a.cmd == 'all')
            wavwrite(path, left, right)
            print('%s  tempo %d  %.1fs  %s' % (s, tempo, len(left) / SR, path))
    elif a.cmd == 'sample':
        for s in a.names:
            wave, loop = sample(s)
            while loop is not None and len(wave) < a.rate:
                wave = wave + wave[loop:]
            path = outpath(a.o, s.lstrip('$') + '.wav', len(a.names) > 1)
            wavwrite(path, wave, wave, a.rate)
            print('%s  %s  %.2fs  %s' % (s, 'loop' if loop is not None else 'one-shot', len(wave) / a.rate, path))


if __name__ == '__main__':
    main()
