; a1 = the full name of team A: its TeamList city, or LongNYIslanders / LongNYRangers for teams $0D / $0E
;
; Called from setoptions, PrintOtherScoreTeam, PauseTimeout, ScoutVisName, ScoutHotTeam, ScoutHomeName,
; TickerTeam and ShootoutWonBy.
GetTeamLongName:					; a1 = full name of team A
	cmp.w #$000D					; team $0D: NY Islanders long name
	beq .t1
	cmp.w #$000E					; team $0E: NY Rangers long name
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

.t1:								; long name of the Islanders
	lda.w #LongNYIslanders>>16
	sta.b a1+2
	lda.w #LongNYIslanders
	sta.b a1
	bra .1

.t2:								; long name of the Rangers
	lda.w #LongNYRangers>>16
	sta.b a1+2
	lda.w #LongNYRangers
	sta.b a1
.1:									; return
	rtl
