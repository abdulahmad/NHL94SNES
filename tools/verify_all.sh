#!/bin/sh
# verify_all.sh: clean full build, then every segment against its ROM slice. Usage: tools/verify_all.sh
# Deletes the old output first; fails on any assembler error, missing output or byte difference. The last line is MATCH or FAIL.
cd "$(dirname "$0")/.."
rm -rf output
fail=0; mkdir -p output; LOG=output/verify_all.log
./build.sh >$LOG 2>&1
grep -qiE 'error' $LOG && { echo "ASM ERRORS"; fail=1; }
grep -q 'MATCH output/retail/nhl94snes.sfc' $LOG || { echo "TOP:"; tail -15 $LOG; fail=1; }
[ -s output/retail/nhl94snes.sfc ] || { echo "TOP NO BIN"; fail=1; }
for f in src/bank*_*.asm src/banks/b*.asm; do
  [ -f "$f" ] || continue
  s=$(basename "$f" .asm)
  r=$(sh tools/verify_segment.sh "$s" 2>&1 | tail -1)
  [ "$r" = "$s: MATCH" ] || { echo "$r"; fail=1; }
done
[ $fail = 0 ] && echo MATCH || { echo FAIL; exit 1; }
