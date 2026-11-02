; a1 = the full name of team A: its TeamList city, or LongNYI / LongNYR for teams $0D / $0E
;
; Called from setoptions, PrintOtherScoreTeam, PauseTimeout, ScoutVisName, ScoutHotTeam, ScoutHomeName,
; PrintGameInfo and ShootoutWonBy.
GetTeamLongName:					; a1 = full name of team A
	cmp.w #$000D					; team $0D: NYI long name
	beq .t1
	cmp.w #$000E					; team $0E: NYR long name
	beq .t2
	asl a							; other teams: index * 4 into TeamList, then the city offset (word at +4)
	asl a
	tay
	lda.w #TeamList>>16
	sta.b a1+2
	lda.w #TeamList
	sta.b a1
	lda.b [a1],y
	sta.b a1
	ldy.w #$0004
	clc
	adc.b [a1],y
	sta.b a1
	bra .1

.t1:								; long name of NYI
	lda.w #LongNYI>>16
	sta.b a1+2
	lda.w #LongNYI
	sta.b a1
	bra .1

.t2:								; long name of NYR
	lda.w #LongNYR>>16
	sta.b a1+2
	lda.w #LongNYR
	sta.b a1
.1:									; return
	rtl
