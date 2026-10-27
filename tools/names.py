#!/usr/bin/env python3
# names.py: put the real licensed names back into the source files that have placeholders.
# src/data/teamdata94s.asm, src/data/text/LongNYI.asm and src/data/text/PregameText.asm hold placeholders instead of the NHLPA
# player names and the NHL team nicknames (licensed data that is not in the repository). tools/extract.py writes the real ones
# from the ROM to Extracted/PlayerNames.txt and Extracted/TeamNicknames.txt; this writes copies of the three files to
# output/names/ with each placeholder replaced, and the bank files include the copies. A name must have the length of its
# placeholder (the macros write a length word, so a different length would move the data after it).
#   - a player: the text of a %Player("...", ...) row, replaced in order from PlayerNames.txt;
#   - a nickname: N<two digits> padded with '_' (N01 = the first line of TeamNicknames.txt), alone in a string or after other
#     text ("NY N12______", the long name of a New York team).
# Run by tools/prebuild.py (so by build.sh and build.ps1). Stops with a message if a length or a count does not match.
import os, re, sys
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
FILES = ['data/teamdata94s.asm', 'data/text/LongNYI.asm', 'data/text/PregameText.asm']
def lines(name):
    path = os.path.join(ROOT, 'Extracted', name)
    if not os.path.exists(path): sys.exit(f'names: Extracted/{name} is missing (run python3 tools/extract.py lst/nhl94snes.sfc)')
    return open(path, encoding='latin1').read().split('\n')[:-1]
players, nicks = lines('PlayerNames.txt'), lines('TeamNicknames.txt')
used, count = set(), 0
def player(m):
    global count
    if count >= len(players): sys.exit(f'names: more %Player rows than names ({len(players)})')
    real = players[count]; count += 1
    if len(real) != len(m.group(2)):
        sys.exit(f"names: Player row {count}: the name '{real}' has {len(real)} characters, its placeholder '{m.group(2)}' has {len(m.group(2))}")
    return m.group(1) + real + m.group(3)
def nick(m):
    i = int(m.group(2))
    if not 1 <= i <= len(nicks): sys.exit(f"names: nickname placeholder '{m.group(1)}' has no entry in TeamNicknames.txt ({len(nicks)})")
    real = nicks[i - 1]
    if len(real) != len(m.group(1)):
        sys.exit(f"names: nickname {i}: '{real}' has {len(real)} characters, its placeholder '{m.group(1)}' has {len(m.group(1))}")
    used.add(i)
    return real
out_dir = os.path.join(ROOT, 'output', 'names')
os.makedirs(out_dir, exist_ok=True)
for f in FILES:
    text = open(os.path.join(ROOT, 'src', f), encoding='latin1', newline='').read()
    text = re.sub(r'(?m)^([ \t]*%Player\(")([^"]*)(")', player, text)
    text = re.sub(r'\b(N(\d\d)_*)(?=")', nick, text)
    open(os.path.join(out_dir, os.path.basename(f)), 'w', encoding='latin1', newline='').write(text)
if count != len(players): sys.exit(f'names: PlayerNames.txt has {len(players)} names, src/data/teamdata94s.asm has {count} %Player rows')
print(f'names: {count} player names, {len(used)} team nicknames -> output/names/')
