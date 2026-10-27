#!/bin/sh
# Runs the build (node tools/build.js): check the ROM, extract, put the real names back, assemble with asar, verify.
cd "$(dirname "$0")" && exec node tools/build.js "$@"
