# NHL 94 SNES: the manual's features and the code behind them

The manual is a lead; the code is what shows the feature is there. Pages are the archive.org scan (SNESManuals),
PDF p.N. Written 2026-11-24.

| Feature (manual page) | Code |
| --- | --- |
| Shootout (p.5) | `ShootoutWonBy`, `ShootoutShooters` (src/routines/shootout/) |
| New Playoffs, one win a round (p.5) | not confirmed in code |
| Goalie control, press X (p.3) | `GoalieOptionText` (src/data/text/), `assgoalie` |
| One-timers (p.3) | `SPAonetimerf` (src/data/frames94s.asm), used in `dopass` |
| Super Multitap (p.8) | `Multi5Init`, `Multi5ConnectCheck` (src/routines/middle/) |
| Penalty shots (p.9) | `PenShotChk` (src/routines/penalty/) |

Two more rules from the manual (PDF p.9), not confirmed in code yet:

- On a delayed penalty the computer pulls its goalie for a forward, and he returns when you touch the puck.
- No team ever has fewer than three skaters on the ice.

Penalty shots come from a trip or hold on a breakaway (p.9). The manual explains goalie control on its own page 23.
