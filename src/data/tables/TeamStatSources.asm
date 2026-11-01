; Per stat of TeamStatNames: a kind word, then the RAM word of the home and away team ($FFFF = none); $FFFF
; ends them
TeamStatSources:
	dw $0010,tmscore,$FFFF
	dw $0010,tmshots,$FFFF
	dw $0012,tmscore,tmshots
	dw $0001,tmPwrGoals,tmPwrPlays
	dw $0003,tmPwrPlayTime,$FFFF
	dw $0000,tmPPShots,$FFFF
	dw $0000,tmSHGoals,$FFFF
	dw $0011,tmBreakawayGoals,tmBreakaways
	dw $0011,tmOneTimerGoals,tmOneTimers
	dw $0011,tmPenShotGoals,tmPenShots
	dw $0010,tmfowon,$FFFF
	dw $0010,tmchecks,$FFFF
	dw $0001,tmPenalties,tmPenmin
	dw $0013,tmATOP,$FFFF
	dw $0011,tmpasscomp,tmpasses
	dw $0012,tmpasscomp,tmpasses
	dw $FFFF,$FFFF,$FFFF
