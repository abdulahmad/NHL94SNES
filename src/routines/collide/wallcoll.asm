; Bounce object X off a wall
wallcoll:
	lda.b d0
	sta.w Wallcos,x
	lda.b d1
	sta.w Wallsin,x
	lda.b d2
	pha
	lda.b d3
	pha
	lda.b d1
	pha
	lda.b d0
	pha
	txy
	ldx.w Yvel,y
	jsl.l Mul16x8S
	lda.b r2+1
	sta.b d0
	ldx.w Xvel,y
	lda.b d1
	jsl.l Mul16x8S
	lda.b d0
	sec
	sbc.b r2+1
	eor.w #$FFFF
	inc a
	sta.b d2
	ldx.w Xvel,y
	lda.b r0+1,s
	jsl.l Mul16x8S
	lda.b r2+1
	sta.b d0
	ldx.w Yvel,y
	lda.b d1
	jsl.l Mul16x8S
	lda.b r2+1
	clc
	adc.b d0
	sta.b d3
	tyx
	cpx.w #$001C
	beq .t2
	jmp.w .6

.t2:
	lda.w #$1000
	trb.w sflags
	lda.b d2
	bmi .t1
	jmp.w .8

.t1:
	lsr a
	lsr a
	bit.w #$2000
	beq .1
	ora.w #$C000
.1:
	sta.b d2
	sec
	sbc.w #$FC00
	bpl .3
	jsl.l RandomWord
	and.w #$07FF
	eor.w #$FFFF
	inc a
	sta.w puckvz
	sta.b d0
	jsl.l puckflip
	lda.w #$000A
	ldy.w puckz
	cpy.w #$000B
	bcs .2
	lda.w #$0004
.2:
	jsl.l PuckSfx
.3:
	lda.b d3
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0200
	beq .4
	ora.w #$FC00
.4:
	sta.b d0
	pha
	asl a
	pla
	ror a
	sta.b d0+2
	lda.b d3
	sec
	sbc.b d0
org $9E9000
	sec
	sbc.b d0+2
	sta.b d3
	bra .7
.5:
	jmp.w .8
.6:
	lda.b d2
	sec
	sbc.w #$03E8
	bpl .5
	lda.b d2
	sec
	sbc.w #$F000
	bpl .1x
	lda.w impact,x
	sec
	sbc.w #$000A
	bmi .1x
	lda.w Xvel,x
	sta.b p0
	lda.w Yvel,x
	sta.b p0+2
	lda.w #$000D
	jsl.l sfx
.1x:
	lda.b d2
	lsr a
	lsr a
	bit.w #$2000
	beq .2x
	ora.w #$C000
.2x:
	sta.b d2
	sec
	sbc.w #$FC7C
	bmi .7
	lda.w #$FC18
	sta.b d2
.7:
	lda.b r0+1,s
	ldx.b d3
	jsl.l Mul16x8S
	lda.b r2+1
	sta.b tmp0
	lda.b r0+3,s
	ldx.b d2
	jsl.l Mul16x8S
	lda.b tmp0
	sec
	sbc.b r2+1
	ldx.b a3
	sta.w Xvel,x
	lda.b r0+3,s
	ldx.b d3
	jsl.l Mul16x8S
	lda.b r2+1
	sta.b d3
	lda.b r0+1,s
	ldx.b d2
	jsl.l Mul16x8S
	lda.b r2+1
	clc
	adc.b d3
	ldx.b a3
	sta.w Yvel,x
	lda.w puckvz
	bmi .8
	stz.w puckvz
.8:
	pla
	pla
	pla
	sta.b d3
	pla
	sta.b d2
	cpx.w #$001C
	bne .rtl
	lda.w puckc
	bpl .rtl
	jsl.l EndPenaltyShot
	stz.w breakaway
	stz.w onetimer
.rtl:
	rtl
