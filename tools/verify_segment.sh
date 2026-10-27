#!/bin/sh
# verify_segment.sh bankXX_YYYY: compare that segment's 4 KB of output/retail/nhl94snes.sfc (from ./build.sh) with the same bytes of
# lst/nhl94snes.sfc. A segment whose end moved is compared over the range from its org to the next segment's org.
cd "$(dirname "$0")/.."
s=$1; [ -f "src/$s.asm" ] || [ -f "src/banks/$s.asm" ] || { echo "$s: no src/$s.asm"; exit 1; }
[ -s output/retail/nhl94snes.sfc ] || { echo "$s: run ./build.sh first"; exit 1; }
python3 - "$s" <<'PY'
import re, sys, glob, os
s = sys.argv[1]
def org(f):
    m = re.search(r'^\s*org\s+\$([0-9A-Fa-f]{6})', open(f).read(), re.M)
    a = int(m[1], 16); return ((a >> 16) & 0x7F) * 0x8000 + (a & 0x7FFF)
segs = sorted(glob.glob('src/bank*_*.asm') + glob.glob('src/banks/b*.asm'), key=org)
names = [os.path.basename(f)[:-4] for f in segs]; i = names.index(s)
lo = org(segs[i]); hi = org(segs[i + 1]) if i + 1 < len(segs) else os.path.getsize('lst/nhl94snes.sfc')
a = open('output/retail/nhl94snes.sfc', 'rb').read()[lo:hi]; b = open('lst/nhl94snes.sfc', 'rb').read()[lo:hi]
if a == b: print(f'{s}: MATCH'); sys.exit(0)
d = next(k for k in range(len(b)) if k >= len(a) or a[k] != b[k])
print(f'{s}: DIFFER at ROM offset ${lo + d:05X} (built {a[d] if d < len(a) else None}, retail {b[d]})'); sys.exit(1)
PY
