#!/bin/sh
# verify_segment.sh bankXX_YYYY: compare that segment of output/retail/nhl94snes.sfc (from ./build.sh) with the same bytes of the retail
# ROM (node tools/verifySegment.js).
cd "$(dirname "$0")/.." && exec node tools/verifySegment.js "$@"
