; Print strings: a length word, then position / control bytes and the text. Txt names come from the text, Pos
; names (position only) from the routine that prints them
DrawEditLinesTitlePos:
	dw $0005 : db $BF,$0B,$07
ClearEditLinesMenuPos:
	dw $0005 : db $BF,$00,$09
ReturnToGameTxt:
	dw $0013 : db $BF,$09,$0D,"Return to Game"
RestoreDefaultLinesTxt:
	dw $001A : db $9F,$06,$0E,"Restore default lines"
EditLinesMenuPos:
	dw $0005 : db $BF,$09,$0D
EditLinesMenuPos2:
	dw $0005 : db $9F,$09,$0D
ReturnToGame:
	%String("Return to Game")
EditLinesMenuPos3:
	dw $0005 : db $BF,$06,$0E
EditLinesMenuPos4:
	dw $0005 : db $9F,$06,$0E
RestoreDefaultLines:
	%String("Restore default lines")
PrintLinePlayersPos:
	dw $0005 : db $BF,$00,$0D
PrintLinePlayersPos2:
	dw $0005 : db $BF,$00,$0E
SelectLinePlayerPos:
	dw $0005 : db $BF,$00,$01
SelectLinePlayerPos2:
	dw $0005 : db $BF,$00,$01
PlayerTxt:
	dw $000B : db $AF,$03,$02,"Player"
LeftArrowTxt:
	dw $0006 : db $AF,$02,$02,"{"
RightArrowTxt:
	dw $0006 : db $AF,$09,$02,"}"
DrawEditLinesBackPos:
	dw $0005 : db $BF,$00,$00
DrawEditLinesBackPos2:
	dw $0005 : db $BF,$07,$09
PrintLinePlayerListPos:
	dw $0005 : db $BF,$00,$03
ScoringLabel:
	%String("Scoring")
ScoringSummaryHead:
	dw $0023 : db $AF,$01,$09,"Per Time Tm  Goal/Assist   P/S"
NoScoring:
	dw $000F : db $BF,$0B,$0D,"No Scoring"
ScoringPP2:
	%String("PP2")
ScoringPP:
	%String("PP")
ScoringSH:
	%String("SH")
ScoringSH2:
	%String("SH2")
PenaltiesLabel:
	%String("Penalties")
PenaltySummaryHead:
	dw $0023 : db $AF,$01,$09,"Per Time Tm  Player/Penalty PM"
NoPenalties:
	dw $0011 : db $BF,$0A,$0D,"No Penalties"
PrintScrollHintPos:
	dw $0005 : db $BF,$09,$06
ScrollHint:
	%String("   Scroll  }")
RightArrowTxt2:
	dw $0006 : db $AF,$15,$07,"}"
PrintScrollArrowsPos:
	dw $0006 : db $AF,$15,$07," "
LeftArrowTxt2:
	dw $0006 : db $AF,$0A,$07,"{"
PrintScrollArrowsPos2:
	dw $0006 : db $AF,$0A,$07," "
ShowCrowdMeterPos:
	dw $0005 : db $BF,$06,$0A
CrowdMeter:
	%String("CROWD METER")
CurrentTxt:
	dw $000C : db $AF,$05,$11,"Current"
DbTxt:
	dw $0007 : db $AF,$19,$11,"db"
CurrentTxt2:
	dw $000C : db $BF,$05,$11,"Current"
DbTxt2:
	dw $0007 : db $BF,$19,$11,"db"
PeakTxt:
	dw $0009 : db $AF,$05,$13,"Peak"
DbTxt3:
	dw $0007 : db $AF,$19,$13,"db"
PeakTxt2:
	dw $0009 : db $BF,$05,$13,"Peak"
DbTxt4:
	dw $0007 : db $BF,$19,$13,"db"
AverageTxt:
	dw $000C : db $AF,$05,$15,"Average"
DbTxt5:
	dw $0007 : db $AF,$19,$15,"db"
AverageTxt2:
	dw $000C : db $BF,$05,$15,"Average"
DbTxt6:
	dw $0007 : db $BF,$19,$15,"db"
OtherScores:
	%String("Other Scores")
NoOtherGames:
	dw $0014 : db $9F,$09,$0B,"No Other Games."
PasswordLabel:
	%String("Password")
PasswordScreenPos:
	dw $0005 : db $AF,$01,$12
PasswordTxt:
	dw $0010 : db $AF,$02,$0E,"Password",$AF,$15,$0E
PasswordScreenPos2:
	dw $0005 : db $BF,$02,$10
PrintSelectLeftPos:
	dw $0005 : db $AF,$01,$11
SelectLeft:
	%String(" < ")
PlacePasswordCursorPos:
	dw $0005 : db $AF,$14,$0D
BadPassword:
	dw $0014 : db $BF,$02,$13,"Bad Password   "
ARetryTxt:
	dw $0014 : db $BF,$02,$14,"A - Retry      "
YExitScreenTxt:
	dw $0014 : db $BF,$02,$15,"Y - Exit Screen"
BadPasswordPromptPos:
	dw $0010 : db $AF,$0A,$18,"           "
BadPasswordPromptPos2:
	dw $0005 : db $AF,$02,$13
SelectTxt:
	dw $0014 : db $AF,$02,$13," {}[] - Select "
ANextTxt:
	dw $0014 : db $AF,$02,$14,"    A - Next   "
YBackTxt:
	dw $0014 : db $AF,$02,$15,"    Y - Back   "
PressStartTxt:
	dw $0010 : db $AF,$0A,$18,"Press start"
PlayerStatsTitle:
	%String("Player Stats")
ShowPlayerStatsPos:
	dw $0005 : db $BF,$09,$06
YSwitchTeamsTxt:
	dw $0015 : db $9F,$08,$1A,"Y - Switch Teams"
PlayerStatsHeading:
	%String("Player Stats")
PlayerGAPtShPmTxt:
	dw $0023 : db $9F,$01,$09,"  Player         G  A Pt Sh PM"
GoalieGaShPtgTxt:
	dw $0023 : db $9F,$01,$09,"  Goalie          GA  Sh  Ptg "
SortPlayerStatsPos:
	dw $0005 : db $AF,$0A,$07
GameStats:
	%String("Game Stats")
ShowGameStatsPos:
	dw $0005 : db $BF,$01,$09
ShowGameStatsPos2:
	dw $0005 : db $BF,$16,$09
StatPercent:
	%String("%")
StatSlash:
	%String("/")
ShowStarsPos:
	dw $0005 : db $BF,$0B,$02
ShowStarsPos2:
	dw $0005 : db $BF,$0B,$02
StarsOfTheGame:
	dw $0016 : db $BF,$0D,$03,"Stars of the Game"
ScoutingReportPos:
	dw $0005 : db $BF,$01,$0D
ScoutingReportPos2:
	dw $0005 : db $FF,$02,$0E
ShowMatchupsPos:
	dw $0005 : db $FF,$00,$00
MatchupsLabel:
	%String("Matchups")
ShowMatchupsPos2:
	dw $0005 : db $BF,$01,$0A
ShowMatchupsPos3:
	dw $0005 : db $BF,$16,$0A
ShowMatchupsPos4:
	dw $0005 : db $EF,$03,$09
ShowMatchupsPos5:
	dw $0005 : db $EF,$01,$08
ShowMatchupsPos6:
	dw $0005 : db $EF,$19,$09
ShowMatchupsPos7:
	dw $0005 : db $EF,$14,$08
OverallTxt:
	dw $000F : db $EF,$01,$08,"Overall",$EF,$03,$09
OverallTxt2:
	dw $000F : db $EF,$18,$08,"Overall",$EF,$19,$09
ShowMatchupsPos8:
	dw $0005 : db $EF,$0A,$04
AdvantageTxt:
	dw $000E : db $EF,$0B,$06,"Advantage"
UpArrowsTxt:
	dw $000A : db $FF,$0D,$09,"[ [ ["
DownArrowsTxt:
	dw $000A : db $FF,$0D,$09,"] ] ]"
NoneTxt:
	dw $0009 : db $FF,$0D,$09,"None"
PlayoffScreenPos:
	dw $0005 : db $AF,$00,$00
PlayoffScreenPos2:
	dw $0005 : db $CF,$00,$00
N8hTxt:
	dw $0005 : db $DF,"8h"
TeamRosterTitle:
	%String("Team Roster")
PlayerRatingTxt:
	dw $0017 : db $9F,$07,$0C,"Player",$9F,$19,$0C,"Rating",$BF,$01,$08
TeamRosterPos:
	dw $0005 : db $BF,$10,$08
TeamRosterPos2:
	dw $0005 : db $BF,$0B,$06
TeamRosterSwap:
	%String("Team Roster")
ShowRosterLinePos:
	dw $0005 : db $9F,$02,$09
ShowRosterLinePos2:
	dw $0005 : db $BF,$00,$0D
YSwitchTeamsTxt2:
	dw $0018 : db $9F,$08,$1A,"Y - Switch Teams",$BF,$00,$0E
NotTxt:
	dw $0008 : db $BF,$05,$0A,"Not"
PlayingTxt:
	dw $000C : db $BF,$03,$0B,"Playing"
NotTxt2:
	dw $0008 : db $BF,$0F,$0A,"Not"
PlayingTxt2:
	dw $000C : db $BF,$0D,$0B,"Playing"
UseToSelectTeamTxt:
	dw $001A : db $EF,$05,$19,"Use [] to select team"
PressStartWhenDoneTxt:
	dw $001A : db $EF,$05,$1A,"Press START when done"
AtLeastOnePersonMustTxt:
	dw $001D : db $BF,$04,$19,"At least one person must"
PlayInPlayoffModeTxt:
	dw $001B : db $BF,$04,$1A,"  play in playoff mode"
OnlyOnePlayerPerTeamTxt:
	dw $001D : db $BF,$04,$19,"Only one player per team"
IsAllowedInShootoutTxt:
	dw $001C : db $BF,$04,$1A," is allowed in shootout"
UseToSelectTeamTxt2:
	dw $001D : db $EF,$04,$19," Use [] to select team  "
PressStartWhenDoneTxt2:
	dw $001D : db $EF,$04,$1A," Press START when done  "
PlayerSelectTitle:
	%String("Player select")
GameSetupTitle:
	%String("Game Setup")
setoptionsPos:
	dw $0005 : db $AF,$00,$00
GameSetupAlt:
	%String("Game Setup")
PlayerSelectAlt:
	%String("Player select")
TheMultiPlayer5MustBeTxt:
	dw $001E : db $EF,$04,$10,"The MultiPlayer 5 must be"
ConnectedToControllerTxt:
	dw $001C : db $EF,$04,$12,"connected to Controller"
Socket2Txt:
	dw $000F : db $EF,$0A,$14,"Socket #2."
TheMultiPlayer5IsNotTxt:
	dw $001E : db $EF,$04,$10,"The MultiPlayer 5 is not "
DesignedForUseWithTheTxt:
	dw $001E : db $EF,$04,$12,"designed for use with the"
SuperNesSuperScopeTxt:
	dw $001B : db $EF,$06,$14,"Super NES Super Scope."
TheMultiPlayer5IsNotTxt2:
	dw $001D : db $EF,$04,$10,"The MultiPlayer 5 is not"
DesignedForUseWithTheTxt2:
	dw $001E : db $EF,$04,$12,"designed for use with the"
SuperNesMouseTxt:
	dw $0015 : db $EF,$09,$14,"Super NES mouse."
DrawPlayerCardPos:
	dw $0005 : db $9F,$00,$03
StrengthsLabel:
	%String("Strengths:")
StrengthsLabelB:
	%String("Strengths:")
OverallRating:
	%String("Overall Rating")
DrawPlayerCardPos2:
	dw $0005 : db $9F,$0C,$04
TeamRating:
	%String("Team Rating")
SwitchCardsYSwitchTeamsTxt:
	dw $0026 : db $AF,$08,$18,"[] Switch cards",$AF,$08,$19,"Y  Switch teams"
updatepwrplayPos:
	dw $0012 : db $BF,$01,$19,"   ",$16,$17,$18,$19,$BF,$01,$1A,"   "
updatepwrplayPos2:
	dw $0005 : db $BF,$01,$19
prefmesPos:
	dw $0005 : db $BF,$00,$0A
prefmesPos2:
	dw $0005 : db $BF,$05,$0A
prefmesPos3:
	dw $0005 : db $BF,$11,$0D
ShowInjuryBoxPos:
	dw $0005 : db $BF,$0B,$03
InjuryToOutForPeriodTxt:
	dw $0023 : db $BF,$0C,$04,"Injury to:",$BF,$0C,$06,"Out for period",$BF,$0C,$05
TheGameTxt:
	dw $0010 : db $BF,$14,$06,"the game",$BF,$0C,$05
ClearPenaltyMessagePos:
	dw $0005 : db $BF,$04,$0C
ClearPenaltyMessagePos2:
	dw $001B : db $BF,$05,$0D,"                      "
ScoutNamePosAt:
	dw $0005 : db $EF,$02,$0E
	dw $0005 : db $BF,$01,$0A
UpdatePAPos:
	dw $0005 : db $BF,$11,$0D
PeriodStats:
	%String("Period Stats")
DrawPeriodStatsPos:
	dw $0005 : db $BF,$01,$0B
DrawPeriodStatsPos2:
	dw $0005 : db $BF,$01,$0E
DrawPeriodStatsPos3:
	dw $0005 : db $BF,$01,$13
TotalShotsLine:
	%String("Total")
	%String("Shots")
	dw $000E : db $EF,$0B,$19,"Y - Goals"
GoalsLabel:
	%String("Goals")
YShotsTxt:
	dw $000E : db $EF,$0B,$19,"Y - Shots"
HighlightFrom:
	%String("Highlight from game:")
SaveRegsStartHL2Pos:
	dw $0005 : db $BF,$05,$0C
PausemodePos:
	dw $0005 : db $BF,$05,$0C
AttribFightingPos:
	%String("  ")
AttribWeightPos:
	%String("   ")
printscores1Pos:
	dw $0005 : db $BF,$00,$17
printscores1Pos2:
	dw $0005 : db $BF,$01,$18
RoundTxt:
	dw $000A : db $BF,$01,$1A,"Round"
printscores1Pos3:
	dw $0005 : db $BF,$17,$17
printscores1Pos4:
	dw $0005 : db $BF,$1C,$18
printscores1Pos5:
	dw $0005 : db $BF,$18,$18
printscores1Pos6:
	dw $0005 : db $BF,$0F,$01
printscores1Pos7:
	dw $0005 : db $BF,$0F,$1A
printscores1Pos8:
	dw $0005 : db $BF,$0F,$02
printscores1Pos9:
	dw $0005 : db $BF,$1B,$04
printscores1Pos10:
	dw $0005 : db $BF,$09,$04
USBoardPos:
	dw $0005 : db $BF,$14,$08
IntermissionPos:
	dw $0005 : db $BF,$03,$08
	dw $0005 : db $BF,$05,$0C
NewTicker3Pos:
	dw $0005 : db $BF,$02,$17
NewTicker3Pos2:
	dw $0005 : db $BF,$02,$17
NewTicker3Pos3:
	%String("                          ")
boxPos:
	dw $0005 : db $FF,$0B,$02
ShowGoalBoxPos:
	dw $0005 : db $BF,$0B,$02
AssistByTxt:
	dw $0012 : db $BF,$0E,$06,"Assist by:",$BF,$0C,$07
ShowGoalBoxPos2:
	dw $0005 : db $BF,$0C,$08
puckfaceoff2Pos:
	dw $0005 : db $BF,$00,$00
VersusText:
	%String("vs.")
ShootoutPenShot:
	%String("Shootout")
	%String("Pen. Shot")
updatefaceoffPos:
	dw $0005 : db $BF,$00,$00
EASNLogoPos:
	dw $0005 : db $BF,$01,$19
PlayerNumNamePos:
	%String(" ")
StatsReportPos:
	dw $0005 : db $FF,$00,$00
StatsReportPos2:
	dw $0005 : db $FF,$00,$00
setlccordsPos:
	dw $0005 : db $BF,$13,$01
PauseTimeoutPos:
	dw $0005 : db $BF,$05,$0C
TimeoutTxt:
	dw $000F : db $BF,$0C,$0E,"Timeout",$BF,$0A,$0F
PmenuPos:
	dw $0005 : db $BF,$06,$0D
PmenuPos2:
	%String("                    ")
DrawExitPromptPos:
	dw $0005 : db $BF,$05,$0C
DrawExitPromptPos2:
	dw $0005 : db $BF,$06,$0D
DrawExitPromptPos3:
	dw $0005 : db $BF,$06,$0F
DrawExitPromptPos4:
	dw $0005 : db $BF,$06,$10
ShowMP5WarningPos:
	dw $0005 : db $BF,$05,$0C
PrintMP5Line1Pos:
	dw $0005 : db $BF,$0C,$0D
PrintMP5Line2Pos:
	dw $0005 : db $BF,$0C,$0E
PrintMP5Line3Pos:
	dw $0005 : db $BF,$0C,$0F
PrintMP5Line4Pos:
	dw $0005 : db $BF,$0C,$10
