# NHL 94 SNES vs NHL 94 Genesis: unmatched symbols

> **Status.** Made with the pull request that adds it. Applied there: the 18 renames and the 21 flag equates
> in the first two tables. The other tables are candidates only; rows below that name an applied symbol use the
> new name. The ROM stays byte-identical (`./build.sh` prints `MATCH`).

Source: every global label and `=` equate in `src/` (4028 symbols) against every label, `equ` / `=` and `rs`
symbol in NHL94Genesis `src/` (segacd skipped), with the 93G/94G/95G/96G `name_map.csv` lineage, the way
nhl-disasm-report matches names (lowercase). 3076 94S symbols had no 94G name: 586 labels in `src/routines`,
1653 data labels (1203 of them in `data/gfx`), 564 RAM equates in `ram94s.asm`, 207 hardware registers in
`inc/` and 63 data equates. Candidates came from five checks: the call order of each matched routine against
its 94G routine, name similarity, the strings in text tables, 94G names already written in 94S comments, and
the 93S renames of the same routines (`NHLPA93SNES/docs/history`). The applied rows and the LIKELY rows with
evidence were read in both games; rows that say "check first" rest on the 93S rename and an opcode comparison.

Confidence: **EXACT** same item, **LIKELY** same job with a different layout or body, **POSSIBLE** related
but not one to one, **NO MATCH** SNES only.

## Applied: renames

| old 94S name | new name | conf. | evidence |
|---|---|---|---|
| `GoalieCount` | `GetGoalieCount` | EXACT | count the goalie nibbles of the team's `GoalieOdds` word, the 94G and 93S body; 93S made the same rename |
| `PutDigits2` | `ConvertByteToDigits` | EXACT | two BCD digits to ASCII with a blank tens digit; same instructions as 93S `ConvertByteToDigits`; callers `getname`, `FormatPlayerNumInitial`, `pplpen` as in 94G |
| `PlayerNumName` | `getname` | EXACT | mesarea = "NN First Last" for player d0 of team a2; callers `GetNameandAttrib`, `GetPlayerName` as in 94G; 93S rename |
| `PlayerShortName` | `FormatPlayerNumInitial` | LIKELY | mesarea = number, initial and last name of player d0 of team a2 (94G "NN F. Last"); 93S rename |
| `PrintStringFromList` | `Fprint` | EXACT | print string d0 of the String list a1; same loop as 93S `Fprint` (92G name). 94G has the printsmall variant `Fprintsmall`; callers `AttribHanded` / `AttribStatus` match it |
| `ReadPausePad` | `getpzjoy` | LIKELY | read the pad of the controller that paused (`pausepad`); 94G reads pad 3 / 4 the same way in four way play; callers are the pause screens in both |
| `InitScoutDisplay` | `InitScoutingDisplay` | EXACT | same stores (`VertLineScrolling`, `PlayerScrollCtr`, `SelectedPlayerIdx`, `ScoutingReportTimer`, a0 = `TestList`); only caller `ScoutingReport` |
| `CountPowerPlayTime` | `updatePPTeamTime` | LIKELY | one more second of `tmPwrPlayTime` for the team on the power play; only caller `updatepentime` in both |
| `AttribMenuSkater` | `PAttribColumns` | EXACT | String header, nibble mask word, `attribjmp` offset per column, same strings; 93S rename |
| `AttribMenuGoalie` | `GAttribColumns` | EXACT | the goalie columns in the same format; 93S rename |
| `EraseScoutName` | `ClearRosterName` | EXACT | 93S rename of the same 8 line body; 94G has the name |
| `MesAreaDone` | `FinalizeTextBuffer` | EXACT | same instructions as 93S `FinalizeTextBuffer` (94G name) |
| `PositionNames` | `PlayerPositionText` | EXACT | LD, RD, LW, C, RW; 93S rename to the 94G name |
| `RemapTiles` | `remap` | EXACT | 93S rename (body 0.91 of the 93S opcodes); 94G `remap` |
| `projxy` | `find3d` | EXACT | rink position to screen; 93S rename (0.84); 94G `find3d` |
| `revplayeracc` | `noturn` | EXACT | flip d2 when skating backwards, then `playeracc`: the 94G `noturn` body exactly |
| `TickerTeam` | `PrintGameInfo` | LIKELY | team d0's name at x, score d1 further right, then print; 94G does the same with `PushNumberWidth`; 93S rename |
| `GetPadTeam` | `seta2` | LIKELY | a2 = the team of the controller that paused, from the `cont1team` sides; 94G `seta2` tests `cont1team` / `cont2team`; 93S rename |

## Applied: flag equates (94G names, 94S masks)

94S stores a flag as a mask where 94G has a bit number: sflags2 is the high byte of `sflags` (+8), pflags2 sits
at bit n+10 of `pflags`. Each mask below was written as a number in the 94S routine that loads that variable,
and the 94G routine of the same name uses the flag on the same variable. Sites are the instructions now
written with the name.

| name | value | variable | sites | 94G meaning |
|---|---|---|---|---|
| `pfdoff` | `$0001` | pflags | 5 | deceleration off |
| `pfjoycon` | `$0008` | pflags | 6 | joystick controlled |
| `pf2unav` | `$1000` | pflags | 16 | unavailable (bench or box) |
| `pf2pen` | `$4000` | pflags | 6 | caused a penalty |
| `pf2npc` | `$8000` | pflags | 3 | no player collision |
| `gmpendel` | `$0008` | gmode | 2 | delayed penalty called |
| `gmeog` | `$0040` | gmode | 2 | game over reached |
| `sfssdir` | `$0008` | sflags | 3 | set shot direction mode |
| `sf2faceoff` | `$0100` | sflags | 4 | face off in progress |
| `sf2shot` | `$1000` | sflags | 1 | a shot was taken |
| `sf2offsig` | `$8000` | sflags | 2 | offsides little ref on |
| `sf3rmplay` | `$0002` | sflags3 | 2 | play mode on for replay |
| `sf3alttree` | `$0004` | sflags3 | 1 | alternate playoff tree |
| `sf3sbut` | `$0008` | sflags3 | 2 | start button flag |
| `ifcgl` | `$0001` | iflags | 3 | crossed the goal line |
| `ifdir` | `$0002` | iflags | 2 | must cross the top line |
| `ifok` | `$0004` | iflags | 4 | icing |
| `tmflcc` | `$0001` | tmflags | 2 | line change on |
| `gsftf` | `$0001` | gsflags | 5 | teams are flipped |
| `gsfhl` | `$0002` | gsflags | 5 | highlight requested |
| `gsfso` | `$0004` | gsflags | 6 | series over |

Not applied: `sfscrl` (`$0020`) and `sf3fo` (`$0010`) are used in the 94G counterparts but no 94S site loads
the variable right before the mask.

## Not applied: LIKELY

| 94S | 94G | evidence | why not applied |
|---|---|---|---|
| `TeamStatNames`, `TeamStatNamesNoPen` | `TeamStatTextTbl`, `TeamStatTextTblNoPen` | the same rows in the same order (Score, Shots, Shooting Pct., Power Play ...; the NoPen list drops the power play rows) | 94G keeps the stat offsets in the same table; 93S `TeamStatTextTbl` is only the offsets. Needs a naming decision |
| `StatColumnNames` | `StatSortTitles` | the six sort column titles in order (Goalies / Goalie Saves, Goals, Assists, Points, Shots, Penalties) | read by `SortPlayerStats` here, `DrawStatsList` in 94G |
| `CreditNames` + `CreditTitles` | `CreditsList` | the same titles and names | 94S splits titles and names into two tables |
| `jdtab8F` | `jdtab` | the same 16 bytes | 93S has a different table called `jdtab`; `jdtab8F` is the 93S name of this copy |
| `doshot_shotsets` | `shotsets` | x / z offset per pass direction, read by `doshot`; values 15 here, 16 in 94G | `doshot_shotsets` is the 93S name |
| `ShowPlayerCards` | `PlayerCards` | the "Player Cards" pause item screen built with `DrawPlayerCard` | 94S also has `PausePlayerCards`; 94G `PlayerCards` is both |
| `ReloadRink` | `ExitStatsScreen` / `ReloadRinkGraphics` | every pause screen handler calls it to rebuild the rink, where 94G screens leave through `ExitStatsScreen` | different steps (SNES palettes, rink map) |
| `PauseFromPad` | `startpause2` / `startpause3` / `startpause4` | `pausepad` = A, then `startpause`; same callers (`demoread`, `doinput`) | one 94S routine for three 94G entries |
| `LineSlotNames` | `MatchupPosNames` | the matchup position names | 94S adds a "Team" row |
| `GameSetupNames` | `OptionNames` | the game setup option names (Play Mode, Penalties, Line Changes, ...) | different lists |
| `hotplayer1`, `coldplayer1` | `homehotplayer` / `awayhotplayer`, `homecoldplayer` / `awaycoldplayer` | hottest / coldest starter per team, visitors at +2 | 94S is one array per kind |
| `sfhormode` | `sfhor` | its own word here, a bit of sflags in 94G (the 94S comment says so) | the 94G name is a bit number |
| `Restart` | `Opening2` | 93S rename | body 0.33 of the 93S opcodes; check first |
| `TeamRoster` | `TeamRosterScreen` | 93S rename | 72 lines against 354 in 93S; check first |
| `randomd0sd0` / `randomd0s` | `randomd0s` / `randomas` | 93S swapped these two | needs the swap in one step |

## Not applied: POSSIBLE

`EndPenaltyShot` / `EndPenaltyShotPlay` (both end a penalty shot, different steps), `DrawShootersBack` /
`ClearShooterScreen` (first step of `ShootersBackground`), `PrintShooterRows` / `PrintShooterSlots`,
`PrintScrollArrows` / `DrawScrollArrows` and `PrintStatScrollArrows`, `WaitDMAQueue` / `WaitDMA`,
`Decompress` / `DecompressGraphics` (different formats), `checkpuckcoll_ccx` (the 94G local
`checkpuckcoll.ccx`, not a global), `pmenulist` / `menulist`, `star1score`.. / `starscores`.
Checked and rejected: `Pausemode_menu` / `Pausemode_Pmenu`, `GetPadTeam` / `GetCardTeam`, `FadeOut` / `forcefade`,
`CheckBreakaway` / `getBAplayerInfo`.

## Constants

Same name, different value, as expected from the layouts:

* Flags: 94S masks against 94G bit numbers (`gm*`, `sf*`, `sf2*` at +8, `tmf*`, `pfna`). All agree.
* Penalty numbers from `$10`: 94S has `PenNoText` at `$10`, `PenOffsides` `$12`, `PenRoughing2` `$14`, a second
  no-text entry `PenNoText2` at `$16`, and `PenShot` at `$24`, so every later number is 2 or 4 above 94G. 94G has the
  penalty shot variants at `$2E`-`$3C` instead of `PenShot`.
* `replaysize` 122 against 98 (bytes per replay frame), `cbut` `$80` against bit 5, `SPFarrow` 374 against 384
  (the 94S frame numbers are not the 94G SPF values).

Worth a look:

* `pf2inj = $0004` is bit 2 of `pflags` (the 94G `pfnc` position), and `noturn0` tests it for the stumble.
  94G `pf2inj` is pflags2 bit 6, which would be `$10000` in this layout. `setInjuryType` sets `$1000`, which 94G
  sets as `pf2unav` there; that site is now written `pf2unav`.
* `rosterNone = $FFFC`: 94G compares `tmpdst` with `$FFFC` as "injured for the game" (collide94.asm around
  `ResetBench`).

94S names, 94G uses the number: `TMPDICE` / `TMPDBENCH` / `TMPDOUT` / `rosterNone` (`$FFFF`-`$FFFC` in `tmpdst`) and
`TMPDINJ` (`$1000`). 94G has no name for them.

94S only (NO MATCH): `SoundBankGame` / `SoundBankMenu`, the `DSP_*` registers, `pwlength` / `PWrange` (94G saves to
SRAM, no password), `PenShot` / `PenNoText2` / `PenNoText3`, the `SPF*` frame bases, the RAM buffers (`textmap`,
`palbuffer`, `unpackbuf`, ...), and the hardware registers in `inc/`.

Sound numbers: the sample headers in `data/sound` name the 94G effect (`SFXpuckbody`, `SFXwhistle`, ...), but the 94S
sound numbers are different (the puck off a body is sound 8 here, `SFXpuckbody` = 36 in 94G). 94S `SFX*` equates
with the 94S numbers would be the next step.
