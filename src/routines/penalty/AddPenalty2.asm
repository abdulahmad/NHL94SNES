; Call penalty d0 on player X without the checks
AddPenalty2:						; called from AddPenalty, FallDown, Goal, ShootoutWonBy, assgoalie and...
	lda.w sfhormode
	beq .t2
	jmp.w .5

.t2:								; sfhormode = 0: if d0 != PenGoal go to .1
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.b d0
	cmp.w #PenGoal
	bne .1
.1:									; sbc #PenGoal, if minus go to .3, ...
	sec
	sbc.w #PenGoal
	bmi .3
	lda.l Crowdlevel
	clc
	adc.w #$00C8
	sta.l Crowdlevel
	lda.w #$002D
	sta.b crowdhold
	lda.w pfteam,x
	beq .3
	lda.l Crowdlevel
	sec
	sbc.w #$00C8
	bcs .2
	lda.w #$0000
.2:									; Crowdlevel = A
	sta.l Crowdlevel
.3:									; a1 = PenBuf, d1 = $001F
	lda.w #PenBuf>>16
	sta.b a1+2
	lda.w #PenBuf
	sta.b a1
	lda.w #$001F
	sta.b d1
.loop:								; loop: increment a1, increment a1, if zero go to .loop, ...
	lda.b [a1]
	inc.b a1
	inc.b a1
	and.w #$00FF
	cmp.w #$0034
	beq .loop
	tay
	beq .t1
	dec.b d1
	bpl .loop
	bra .4

.t1:								; decrement a1, decrement a1, xba, ...
	dec.b a1
	dec.b a1
	txa								; store (SCnum << 8) | penalty
	lsr a
	xba
	and.w #$FF00
	ora.b d0
	sta.b [a1]
	lda.w #Penaltylist>>16			; a0 = Penaltylist + [d0]
	sta.b a0+2
	lda.w #Penaltylist
	sta.b a0
	ldy.b d0
	clc
	adc.b [a0],y
	sta.b a0
	lda.b [a0]						; penalty minutes
	and.w #$00FF
	beq .4
	lda.w pflags,x
	pha
	ora.w #$4000
	sta.w pflags,x
	pla
	bit.w #$4000
	beq .4
	lda.w #$0000
	sta.b [a1]
.4:									; a1+2 = pulled value, a1 = pulled value, a0+2 = pulled value, ...
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d1+2
	pla
	sta.b d1
.5:									; return
	rtl
