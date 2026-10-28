// playerCards.js: which player has which player card picture, read from the source (no ROM needed).
// playerCards() -> one entry per %Player row of src/data/teamdata94s.asm, in file order (the order of the ids P001 ...):
//   { team: 'Boston', slot: 17, card: 'Card036' or null }
// src/data/tables/PlayerPhotoTable.asm has 26 pictures per team (TeamList order), one per roster index: a CardNNN or a generic NoPic one.
const fs = require('fs');
const path = require('path');
const read = (f) => fs.readFileSync(path.join(__dirname, '..', 'src', 'data', f), 'latin1').split(/\r?\n/);

function playerCards() {
    const td = read('teamdata94s.asm');
    const order = [];                                         // team record labels in TeamList order
    for (const l of td) {
        const m = /^\s*dd\s+(\w+)\s*;\s*\d+/.exec(l);
        if (m) order.push(m[1]);
    }
    const rows = [];
    let team = null, slot = 0;
    for (const l of td) {
        const m = /^(\w+):/.exec(l);
        if (m && order.includes(m[1])) { team = m[1]; slot = 0; continue; }
        if (/^\s*%Player\(/.test(l)) rows.push({ team, slot: slot++, card: null });
    }
    const entries = [];
    for (const l of read('tables/PlayerPhotoTable.asm')) {
        const m = /^\s*dd\s+([\w,]+)/.exec(l);
        if (m) entries.push(...m[1].split(','));
    }
    for (const r of rows) {
        const e = entries[order.indexOf(r.team) * 26 + r.slot];
        r.card = /^Card\d+$/.test(e || '') ? e : null;
    }
    return rows;
}
module.exports = { playerCards };
