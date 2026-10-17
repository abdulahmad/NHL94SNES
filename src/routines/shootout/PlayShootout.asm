; the shootout: both shooter lists, then a turn for each team every round, until after five rounds
PlayShootout:
		;   $178E and $1790 differ
	lda.l OptLine
	pha
	lda.w #$0000
	sta.l OptLine
	lda.w #$0001
	sta.w shootoutmode
	stz.b a2
	jsl.l InitShooters
	lda.w #$0002
	sta.b a2
	jsl.l InitShooters
	jsl.l StartGame_go
	jsl.l StartPer
	jsl.l Pausemode
	lda.w #$0001
	sta.w shootoutround
	stz.b d1
.loop:
	stz.w shootoutdecider
	lda.w #$0002
	sta.b a2
	stz.b a1
	jsl.l .t1
	lda.w shootoutround
	cmp.w #$0005
	bmi .1
	lda.w #$0001
	sta.w shootoutdecider
.1:
	stz.b a2
	lda.w #$0002
	sta.b a1
	jsl.l .t1
	jsl.l ShootoutStub
	inc.w shootoutround
	lda.w shootoutround
	cmp.w #$0006
	bmi .loop
	lda.w tmscore
	cmp.w tmscore+2
	beq .loop
	stz.w shootoutmode
	pla
	sta.l OptLine
	rtl

.t1:								; a shootout turn of team $91: the shooter of this round from its list
	stz.w shootoutstop
	stz.w shootoutturnover
	lda.b a2
	pha
	jsl.l ClearPenaltyBuffer
	stz.w gmode
	lda.b a2
	beq .1x
	lda.w #$0002
	sta.w gmode
.1x:
	jsl.l StartPer
	pla
	sta.b a2
	lda.w #$0000
	sta.w BA_Sktr_SCnum
	lda.b a2
	beq .2
	lda.w #$000C
	sta.w BA_Sktr_SCnum
.2:
	ldy.w #$0000
.loopx:
	lda.w padside,y
	cmp.b a2
	beq .t2
	iny
	iny
	cpy.w #$000A
	bcc .loopx
	lda.w #$FFFF
	sta.w pspad
	bra .3

.t2:
	sty.w pspad
.3:
	jsl.l StartPenaltyShot
	lda.b a2
	beq .t2x
	lda.w shootoutround
.loopxx:
	cmp.w #$0006
	bmi .t1x
	sec
	sbc.w #$0005
	bra .loopxx

.t1x:
	tay
	sep #$20
	lda.w awayshooters,y
	rep #$20
	and.w #$00FF
	dec a
	sta.w BA_Skater_Offset
	lda.w #$000C
	sta.w BA_Sktr_SCnum
	lda.w #$0002
	sta.w BA_Team
	bra .4

.t2x:
	lda.w shootoutround
.loopxxx:
	cmp.w #$0006
	bmi .t1xx
	sec
	sbc.w #$0005
	bra .loopxxx

.t1xx:
	tay
	sep #$20
	lda.w homeshooters,y
	rep #$20
	and.w #$00FF
	dec a
	sta.w BA_Skater_Offset
	lda.w #$0000
	sta.w BA_Sktr_SCnum
	stz.w BA_Team
.4:
	jsl.l Gameloop
	rtl
