#!/usr/bin/env node
// verifySegment.js: compare one segment (a bank file) of the built ROM with the same bytes of the retail ROM.
// Usage: node tools/verifySegment.js bankXX_YYYY   (a file src/<name>.asm or src/banks/<name>.asm)
//        node tools/verifySegment.js --all         (every segment; prints only the ones that differ, then MATCH or FAIL)
// The built ROM is output/retail/nhl94snes.sfc (node tools/build.js); the retail ROM is the one in the repo folder (tools/roms.js).
// A segment is compared from its org to the next segment's org (the last one to the end of the ROM), so a segment whose end moved is
// still checked over its range. Prints "<name>: MATCH" or "<name>: DIFFER at ROM offset $...".
const fs = require('fs');
const path = require('path');
const { ROOT, romPath } = require('./roms');

const BUILT = path.join(ROOT, 'output', 'retail', 'nhl94snes.sfc');
const rom = romPath('retail');
if (!rom) { console.error('The retail ROM is not in the repo folder (see node tools/prebuild.js).'); process.exit(1); }
if (!fs.existsSync(BUILT) || fs.statSync(BUILT).size === 0) { console.error('run node tools/build.js first'); process.exit(1); }

// The bank files, sorted by the file offset of their org.
const files = [];
for (const dir of ['src', path.join('src', 'banks')]) {
    const full = path.join(ROOT, dir);
    for (const f of fs.existsSync(full) ? fs.readdirSync(full) : []) {
        if (dir === 'src' ? /^bank.*_.*\.asm$/.test(f) : /^b.*\.asm$/.test(f)) files.push(path.join(full, f));
    }
}
const offset = (a) => ((a >> 16) & 0x7F) * 0x8000 + (a & 0x7FFF);
const segs = files.map((f) => {
    const m = fs.readFileSync(f, 'latin1').match(/^\s*org\s+\$([0-9A-Fa-f]{6})/m);
    return m ? { name: path.basename(f, '.asm'), org: offset(parseInt(m[1], 16)) } : null;
}).filter(Boolean).sort((a, b) => a.org - b.org);

const built = fs.readFileSync(BUILT), ref = fs.readFileSync(rom);
function check(i) {
    const lo = segs[i].org, hi = i + 1 < segs.length ? segs[i + 1].org : ref.length;
    const a = built.subarray(lo, hi), b = ref.subarray(lo, hi);
    if (a.equals(b)) return null;
    let d = 0;
    while (d < b.length && d < a.length && a[d] === b[d]) d++;
    return `${segs[i].name}: DIFFER at ROM offset $${(lo + d).toString(16).toUpperCase().padStart(5, '0')} (built ${d < a.length ? a[d] : null}, retail ${b[d]})`;
}

const arg = process.argv[2];
if (arg === '--all') {
    let bad = 0;
    segs.forEach((s, i) => { const r = check(i); if (r) { console.log(r); bad++; } });
    console.log(bad ? 'FAIL' : 'MATCH');
    process.exit(bad ? 1 : 0);
}
const i = segs.findIndex((s) => s.name === arg);
if (!arg || i < 0) { console.error(arg ? `${arg}: no src/${arg}.asm or src/banks/${arg}.asm` : 'usage: node tools/verifySegment.js <bankXX_YYYY | --all>'); process.exit(1); }
const r = check(i);
console.log(r || `${arg}: MATCH`);
process.exit(r ? 1 : 0);
