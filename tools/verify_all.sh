#!/bin/sh
# verify_all.sh: clean full build, then every segment against its ROM slice (tools/verifySegment.js --all). Usage: tools/verify_all.sh
# Deletes the old output first; fails on any assembler error, missing output or byte difference. The last line is MATCH or FAIL.
cd "$(dirname "$0")/.."
rm -rf output
fail=0; mkdir -p output; LOG=output/verify_all.log
./build.sh >$LOG 2>&1
grep -qiE 'error' $LOG && { echo "ASM ERRORS"; fail=1; }
grep -q 'MATCH output/retail/nhl94snes.sfc' $LOG || { echo "TOP:"; tail -15 $LOG; fail=1; }
[ -s output/retail/nhl94snes.sfc ] || { echo "TOP NO BIN"; fail=1; }
node tools/verifySegment.js --all || fail=1
[ $fail = 0 ] && echo MATCH || { echo FAIL; exit 1; }
