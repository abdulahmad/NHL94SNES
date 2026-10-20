; the shootout: both shooter lists, then a turn for each team every round, until after five rounds
PlayShootout:						; called from Restart
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
.loop:								; loop: shootoutdecider = 0, a2 = $0002, a1 = 0, ...
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
.1:									; a2 = 0, a1 = $0002, call .t1, ...
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
.1x:								; call StartPer, a2 = pulled value, BA_Sktr_SCnum = $0000, ...
	jsl.l StartPer
	pla
	sta.b a2
	lda.w #$0000
	sta.w BA_Sktr_SCnum
	lda.b a2
	beq .2
	lda.w #$000C
	sta.w BA_Sktr_SCnum
.2:									; falls through
	ldy.w #$0000
.loopx:								; loop: if padside,y = a2 go to .t2, ...
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

.t2:								; padside,y = a2: pspad = Y
	sty.w pspad
.3:									; call StartPenaltyShot, if a2 = 0 go to .t2x, ...
	jsl.l StartPenaltyShot
	lda.b a2
	beq .t2x
	lda.w shootoutround
.loopxx:							; loop: if minus go to .t1x, ...
	cmp.w #$0006
	bmi .t1x
	sec
	sbc.w #$0005
	bra .loopxx

.t1x:								; BA_Skater_Offset = awayshooters,y & $00FF - 1, BA_Sktr_SCnum = $000C...
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

.t2x:								; a2 = 0: falls through
	lda.w shootoutround
.loopxxx:							; loop: if minus go to .t1xx, ...
	cmp.w #$0006
	bmi .t1xx
	sec
	sbc.w #$0005
	bra .loopxxx

.t1xx:								; BA_Skater_Offset = homeshooters,y & $00FF - 1, BA_Sktr_SCnum = $0000...
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
.4:									; call Gameloop, return
	jsl.l Gameloop
	rtl
