; Assignment: the goalie skates out to a loose puck
assgoalietopuck:					; X = goalie; asstab entry
	lda.w #$0006
	ora.w goalieflags,x
	sta.w goalieflags,x
	lda.w Xpos,x
	cmp.w #$FFD8
	bmi .2
	cmp.w #$0029
	bpl .2
	lda.w Ypos,x
	bit.w #$8000
	beq .1
	eor.w #$FFFF					; negate: two's complement
	inc a
.1:									; r0 = A, if minus go to .2, ...
	sta.b r0
	cmp.w #$00E4
	bmi .2
	cmp.w #$0104
	bpl .2
	lda.w #$FFFB
	and.w goalieflags,x
	sta.w goalieflags,x
.2:									; if Xpos,x - $FFD0 negative go to .4, ...
	lda.w Xpos,x
	cmp.w #$FFD0
	bmi .4
	cmp.w #$0031
	bpl .4
	lda.w Ypos,x
	bit.w #$8000
	beq .3
	eor.w #$FFFF					; negate: two's complement
	inc a
.3:									; if minus go to .4, ...
	cmp.w #$00E4
	bmi .4
	lda.w #$FFFD
	and.w goalieflags,x
	sta.w goalieflags,x
.4:									; if playerpad,x >= 0 go to .6, ...
	lda.w playerpad,x
	bpl .6
	lda.w gmclock
	bne .6
	jsl.l check4bench
	lda.w pflags,x
	bit.w #pfna
	beq .5
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w GoalieUnused
.5:									; temp1,x = temp1,x - d7, if plus go to .8, ...
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .8
	lda.w aidef,x
	lsr a
	lsr a
	clc
	adc.w temp1,x
	bpl .7
	lda.w #$0000
	bra .7
.6:									; go to assexit
	jmp.w assexit
.7:									; temp1,x = A, if puckc >= 0 go to .6, ...
	sta.w temp1,x
	lda.w puckc
	bpl .6
	lda.w puckvy
	ldy.w pfgoal,x
	beq .1x
	eor.w #$FFFF					; negate: two's complement
	inc a
.1x:								; if minus go to .6, ...
	cmp.w #$F800
	bmi .6
	stz.b a1
	lda.w #$0002
	sta.b a2
	lda.w pfteam,x
	beq .2x
	stz.b a2
	lda.w #$0002
	sta.b a1
.2x:								; if tmnear,y < $0096 go to .6
	ldy.b a2
	lda.w tmnear,y
	cmp.w #$0096
	bcc .6
.8:									; call GoaliePuckVector, call vtoa, call AdjustFacingDirection, ...
	jsr.w GoaliePuckVector
	jsl.l vtoa
	jsl.l AdjustFacingDirection
	asl.w legstr,x
	jsl.l .t2
	lsr.w legstr,x
	rtl

.t2:								; subroutine (jsl above): temp2 -= d7, then continue with .5x
	lda.w temp2,x
	sec
	sbc.b d7
	sta.w temp2,x
	bmi .t1
	jmp.w .5x

.t1:								; temp2 ran out: add 5 to it, aim at puckx + puckvx (high byte)
	adc.w #$0005
	sta.w temp2,x
	lda.w puckvx
	xba
	and.w #$00FF
	bit.w #$0080
	beq .1xx
	ora.w #$FF00
.1xx:								; adc puckx, d0 = A, xba, ...
	clc
	adc.w puckx
	sta.b d0
	lda.w puckvy
	xba
	and.w #$00FF
	bit.w #$0080
	beq .2xx
	ora.w #$FF00
.2xx:								; adc pucky, d1 = A, call avdgoal, ...
	clc
	adc.w pucky
	sta.b d1
	jsl.l avdgoal
	lda.b d1
	pha								; 3,s = the avoid-goal target y (d1)
	lda.b d0
	pha								; 1,s = the avoid-goal target x (d0)
	txa
	jsl.l GetHot
	lda.b d0
	eor.w #$FFFF					; negate: two's complement
	inc a
	sec
	sbc.w Xvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .3x
	ora.w #$FF00
.3x:								; adc 1,s, sbc Xpos,x, d0 = A, ...
	clc
	adc.b 1,s
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.b d1
	eor.w #$FFFF					; negate: two's complement
	inc a
	sec
	sbc.w Yvel+1,x
	and.w #$00FF
	bit.w #$0080
	beq .4x
	ora.w #$FF00
.4x:								; adc 3,s, sbc Ypos,x, d1 = A, ...
	clc
	adc.b 3,s
	sec
	sbc.w Ypos,x
	sta.b d1
	pla
	pla
	jsl.l vtoa
	lda.b d0
	sta.w temp2b,x
.5x:								; d0 = temp2b,x, go to doplayeracc
	lda.w temp2b,x
	sta.b d0
	jml.l doplayeracc
