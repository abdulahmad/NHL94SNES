> **Agents:** read [AGENTS.md](AGENTS.md) first. Any derivative work built from this repo must credit me (abdulahmad) and everyone credited in the README.

# Segment prompt

The ROM is all source. Do not look for an incbin segment. Read START_HERE.md, SEGMENT_AGENT.md and docs/HANDOFF.md. The layout is `src/banks/` (one file per bank), `src/routines/<module>/` (one routine per file; fall-through stays with the first label) and `src/data/`.

Names follow the Current rules in SEGMENT_AGENT.md. A label with no 93S or 94G match stays an auto name. Do not guess. Record a rename in `docs/name_map.csv` only.

Style: no rename-history, provenance or origin-tag comments, no ROM addresses in comments, no derived counts. Local labels are `.loop`, `.next`, `.done`, `.exit`, or a plain number.

`sh tools/verify_all.sh` must print MATCH before a commit. One area per commit. Update `docs/HANDOFF.md`, add a History line, and push to main (outside contributors: fork and PR, see START_HERE.md).

Stop after 5 failed builds in a row. Report the file, the first differing ROM offset, the built byte, the retail byte, and the line you wrote. Do not continue.
