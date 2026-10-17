; The puck is in the goal: the siren, the score, the log, the scoreboard and the celebration (shootout goals
; through EndPenaltyShot)
Goal:
	lda.w gmclock
	beq .t3
	stz.w puckvz
	stz.w puckvx
	stz.w puckvy
	rtl

.t3:
	lda.w PenShotActive
	beq .6
	lda.w pucky
	bpl .t1
	lda.w gmode
	bit.w #gmdir
	beq .in
	bra .t2

.t1:
	lda.w gmode
	bit.w #gmdir
	beq .t2
	bra .in

.t2:
	lda.w BA_Team
	beq .6
.1:
	jsl.l EndPenaltyShot
	jmp.w .16
.in:
	lda.w BA_Team
	beq .1
.6:
	jsl.l ChkShotStat
	jsl.l freezewindow
	lda.w #$001E
	sta.w replaydelay
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pucky
	bpl .1x
	stz.b a1
	lda.w #$0002
	sta.b a2
.1x:
	lda.w gmode
	bit.w #gmdir
	beq .2x
	lda.b a1
	sta.b a2
	eor.w #$0002
	sta.b a1
.2x:
	ldy.b a2
	lda.w tmscore,y
	inc a
	sta.w tmscore,y
	lda.w tmap
	sec
	sbc.w tmap+2
	beq .4
	bmi .t1x
	ldy.b a2
	beq .4
	bra .3

.t1x:
	ldy.b a2
	bne .4
.3:
	lda.w tmSHGoals,y
	inc a
	sta.w tmSHGoals,y
.4:
	lda.w penshot
	bne .t1xx
	lda.w breakaway
	beq .5
	ldy.b a2
	lda.w tmBreakawayGoals,y
	inc a
	sta.w tmBreakawayGoals,y
	bra .5

.t1xx:
	ldy.b a2
	lda.w tmPenShotGoals,y
	inc a
	sta.w tmPenShotGoals,y
.5:
	lda.w onetimer
	beq .1xx
	ldy.b a2
	lda.w tmOneTimerGoals,y
	inc a
	sta.w tmOneTimerGoals,y
.1xx:
	jsl.l MusicStop
	lda.w #$0002
	jsl.l StreamSfx
	stz.w benchcheer
	ldy.b a2
	beq .t1xxx
	lda.w #$0004
	jsl.l StartBenchCheer
	lda.l crowdlevel
	sec
	sbc.w #$0300
	bpl .2xx
	lda.w #$0000
.2xx:
	sta.l crowdlevel
	bra .score

.t1xxx:
	inc a
	inc a
	jsl.l StartBenchCheer
	lda.l crowdlevel
	clc
	adc.w #$01F4
	sta.l crowdlevel
	lda.w #$0078
	sta.b crowdhold
	lda.w #$0003
	jsl.l PlayTeamSong
.score:
	lda.b vcount
	sta.w sfxmutetime
	jsl.l EndPenaltyShot
	stz.w breakaway
	stz.w onetimer
	phx
	lda.w gsp
	asl a
	asl a
	tax
	lda.w CwdExciteLvl
	clc
	adc.w #$001E
	bmi .1xxx
	sta.w CwdExciteLvl
.1xxx:
	lda.b a2
	beq .2xxx
	inx
	inx
	lda.w CwdExciteLvl
	clc
	adc.w #$FFCE
	bmi .2xxx
	sta.w CwdExciteLvl
.2xxx:
	lda.w tmPerGoals,x
	inc a
	sta.w tmPerGoals,x
	plx
	lda.l ScoreSumbytes
	cmp.w #$0258
	bne .3x
	sec
	sbc.w #$0006
	sta.l ScoreSumbytes
.3x:
	lda.w #$007E
	sta.b a0+2
	lda.w #ScoreSum
	clc
	adc.l ScoreSumbytes
	sta.b a0
	lda.l ScoreSumbytes
	adc.w #$0006
	sta.l ScoreSumbytes
	jsl.l GetPeriodTimeRemaining
	lda.b d0
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$0002
	clc
	ldy.b a2
	adc.w tmap,y
	ldy.b a1
	sec
	sbc.w tmap,y
	ldy.b a2
	beq .4x
	ora.w #$0080
.4x:
	sta.b [a0]
	inc.b a0
	lda.w tmtouch1,y
	sta.b d0
	sta.b [a0]
	inc.b a0
	lda.w #$FFFF
	sta.b [a0]
	ldx.b a2
	lda.w tmgoalie,x
	cmp.b d0
	beq .6x
	lda.b a2
	beq .5x
	lda.w #$001A
.5x:
	clc
	adc.b d0
	tax
	sep #$20
	inc.w tmgoals,x
	rep #$20
.6x:
	ldy.b a2
	lda.w tmtouch2,y
	sta.b d0
	bmi .9
	sep #$20
	sta.b [a0]
	rep #$20
	lda.b a2
	beq .7
	lda.w #$001A
.7:
	clc
	adc.b d0
	tax
	sep #$20
	inc.w passists,x
	rep #$20
	inc.b a0
	lda.w tmtouch3,y
	sta.b d0
	bmi .9
	sep #$20
	sta.b [a0]
	rep #$20
	lda.b a2
	beq .8
	lda.w #$001A
.8:
	clc
	adc.b d0
	tax
	sep #$20
	inc.w passists,x
	rep #$20
.9:
	ldy.b a1
	lda.w tmgoalie,y
	sta.b d0
	bmi .11
	lda.b a1
	beq .10
	lda.w #$001A
.10:
	clc
	adc.b d0
	tax
	inc.w tmgoals,x
.11:
	jsl.l PenGoalStuff
	jsl.l printscores1
	lda.w #$0008
	sta.b d0
	jsl.l .t1xxxx
	lda.b a2
	bne .12
	lda.w tmscore+2
	sec
	sbc.w tmscore
	bmi .12
	cmp.w #$0003
	bcs .12
.12:
	stz.w collflag
	stz.w puckvx
	stz.w puckvy
	ldy.w #$0006
	lda.w puckx
	bpl .13
	ldy.w #$FFFA
.13:
	sty.w puckx
	ldy.w #$0110
	lda.w pucky
	bpl .14
	ldy.w #$FEF0
.14:
	sty.w pucky
	lda.w #$0600
	sta.w puckvz
	stz.w puckz
	lda.w #$FFFF
	sta.w puckcross+2
	sta.w puckcross+6
	sta.w pfnc+puckobj
	lda.w #$001A
	sta.b d0
	jsl.l assreplace
	inx
	inx
	lda.w #SPAsiren
	jsl.l SetSPAFromA
	ldy.b a2
	ldx.w tmsort,y
	stx.b a3
	lda.w #$000E
	sta.b d0
	jsl.l AddPenalty2
	ldx.w #$001C
	stx.b a3
	rtl

.t1xxxx:
	phx
	ldy.b a2
	lda.w tmsort,y
	tax
	lda.w #$0005
	sta.b d3
.loop:
	lda.w position,x
	bmi .1xxxx
	beq .1xxxx
	stz.w pfnc,x
	jsl.l assinsert
.1xxxx:
	inx
	inx
	dec.b d3
	bpl .loop
	plx
.16:
	rtl
