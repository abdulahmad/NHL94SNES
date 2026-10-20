; Skate toward d0 / d1, with a routine in a0 for avoiding others; slow down near the target
skateto:
	lda.w temp2,x					; skateto timer
	sec
	sbc.w timestep
	sta.w temp2,x
	bmi .t2
	jmp.w .7

.t2:
	adc.w #$000C
	sta.w temp2,x
	lda.b d0
	sta.b d0+2
	lda.b d1
	sta.b d1+2
	jsl.l avdgoal
	lda.w Xvel,x					; x velocity high byte
	xba
	and.w #$00FF
	bit.w #$0080
	beq .1
	ora.w #$FF00
.1:
	eor.w #$FFFF
	inc a
	sta.b r3
	clc
	adc.b d0						; plus the target x
	sec
	sbc.w Xpos,x					; minus my x
	sta.b d0
	lda.w Yvel,x					; y velocity high byte
	xba
	and.w #$00FF
	bit.w #$0080
	beq .2
	ora.w #$FF00
.2:
	eor.w #$FFFF
	inc a
	sta.b r3+2
	clc
	adc.b d1						; plus the target y
	sec
	sbc.w Ypos,x					; minus my y
	sta.b d1
	lda.w position,x
	bne .3
	lda.w goalieflags,x
	bit.w #$0002
	beq .5
.3:
	lda.b d0
	pha
	lda.b d1
	pha
	ldy.w Xvel,x
	lda.w Yvel,x
	jsl.l ApproxLength
	pha
	lda.b r3
	clc
	adc.b d0+2
	sec
	sbc.w Xpos,x
	tay
	lda.b r3+2
	clc
	adc.b d1+2
	sec
	sbc.w Ypos,x
	jsl.l ApproxLength
	tay
	pla
	sta.b r3
	pla
	sta.b d1
	pla
	sta.b d0
	lda.b r3
	cmp.w #$1000
	bcs .t1
	cpy.w #$0005
	bpl .5
	bra .4

.t1:
	cpy.w #$000C
	bpl .5
.4:
	lda.w #$0009
	sta.b d0
	bra .6
.5:
	jsl.l vtoa
.6:
	lda.b a0						; caller's avoidance routine
	sta.w jmlvector+1
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector					; may adjust the direction in d0
	lda.b d0						; remember the direction
	sta.w temp2b,x
	cmp.w #$0008
	bcc .7
	lda.w Xvel,x
	ora.w Yvel,x
	bne .7
	lda.w puckx
	sec
	sbc.w Xpos,x					; minus my x
	sta.b d0
	lda.w pucky
	sec
	sbc.w Ypos,x					; minus my y
	sta.b d1
	jsl.l vtoa						; vector to direction
.7:
	lda.w temp2b,x					; stored direction
	sta.b d0
	jml.l doplayeracc				; accelerate that way
