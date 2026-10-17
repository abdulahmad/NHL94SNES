; The stick is at the puck: launch it toward the goal
doshot:
	jsl.l shotdiradj
	lda.w #$0007
	pha
	lda.w #$0008
	trb.w sflags
	sta.w pfalock,x
	stx.w shotplayer
	cpx.w puckc
	beq .t2
	jmp.w .7

.t2:
	lda.w #$0001
	sta.b r0+1,s
	lda.w #$1000
	tsb.w sflags
	lda.w SPA,x
	cmp.w #SPAshotb
	bne .1
	lda.w #$0001
	sta.b r0+1,s
	lda.w passspeed
	lsr a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w passspeed
	sta.w passspeed
.1:
	lda.w passspeed
	sta.w lastshotspeed
	cmp.w #$001E
	bcc .2
	lda.w #$0002
	sta.b r0+1,s
.2:
	lda.w shotspd,x
	stx.b a0
	jsl.l makepde
	adc.w #$0014
	tax
	lda.w passspeed
	jsl.l Mul16x8U
	ldx.b r2
	lda.w #$2570
	jsl.l Mul16U
	lda.b r2+2
	sta.w passspeed
	lda.w breakaway
	beq .3
	jsl.l CheckBreakaway
	lda.w IsBreakaway
	sta.w breakaway
.3:
	ldx.b curobj
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0010
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	ldy.w #$0108
	lda.w pfgoal,x
	bne .4
	ldy.w #$FEF8
.4:
	sty.b d1
	lda.w passdir
	asl a
	asl a
	tay
	lda.w #shotsets>>16
	sta.b a0+2
	lda.w #shotsets
	sta.b a0
	lda.b [a0],y
	sec
	sbc.w puckx
	sta.b d0
	iny
	iny
	lda.b [a0],y
	sta.b d2
	pha
	lda.b d1
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.b d0
	pha
	lda.b d0
	ldy.b d1
	jsl.l ApproxLength
	cmp.w #$0000
	bne .5
	inc a
.5:
	sta.b d3
	lda.w gmode
	bit.w #$0010
	beq .t1
	jmp.w .6

.t1:
	lda.b d3
	cmp.w #$00C9
	bcs .1x
	lda.w #$0010
	adc.w shotacc,x
	jsl.l randoma8
	cmp.w #$000F
	bcs .6
.1x:
	lda.w passspeed
	lsr a
	lsr a
	lsr a
	sec
	sbc.w shotacc,x
	clc
	adc.w #$0010
	ldx.b d3
	jsl.l Mul16U
	lda.b r2
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	lda.b d3
	cmp.w #$00FB
	bcs .2x
	lsr.b d0
.2x:
	lda.b d0
	cmp.w #sideline
	bcc .3x
	lda.w #sideline
	sta.b d0
.3x:
	pha
	jsl.l randomd0s
	adc.b r0+3,s
	sta.b r0+3,s
	lda.b r0+1,s
	sta.b d0
	cmp.w #$003D
	bcc .4x
	lda.w #$003C
	sta.b d0
	sta.b r0+1,s
.4x:
	lda.b r1+1,s
	bpl .5x
	lsr.b d0
.5x:
	jsl.l randomd0sd0
	lda.b r1+1,s
	adc.b d0
	sta.b r1+1,s
	pla
	lsr a
	jsl.l randoma
	adc.b r1+1,s
	sta.b r1+1,s
.6:
	ldx.w passspeed
	lda.w #$0044
	jsl.l Mul8XS
	plx
	jsl.l Mul16S
	lda.b d3
	sta.b r1
	jsl.l Div32S
	lda.b r0
	asl a
	sta.w puckvx
	ldx.w passspeed
	lda.w #$0044
	jsl.l Mul8XS
	plx
	jsl.l Mul16S
	lda.b d3
	sta.b r1
	jsl.l Div32S
	lda.b r0
	asl a
	sta.w puckvy
	ldx.b curobj
	pla
	beq .7
	tax
	lda.w passspeed
	jsl.l Mul16x8U
	ldx.b r2
	lda.w #$0044
	jsl.l Mul16x8U
	lda.b d3
	sta.b r1
	jsl.l Div32U
	lda.b r0
	asl a
	sta.b d1
	lda.w #$0B33
	ldx.b d3
	jsl.l Mul16U
	lda.w passspeed
	sta.b r1
	jsl.l Div32U
	ldx.b curobj
	lda.b r0
	lsr a
	adc.b d1
	cmp.w #$1801
	bcc .1xx
	lda.w #$1800
.1xx:
	sta.w puckvz
.7:
	pla
	jsl.l PuckSfx
	ldx.b a3
	ldy.w #$0108
	lda.w pfgoal,x
	bne .1xxx
	ldy.w #$FEF8
.1xxx:
	sty.b tmp0
	tya
	sec
	sbc.w pucky
	eor.w puckvy
	bpl .2xx
	lda.w #$0000
	sec
	sbc.w puckvy
	sta.w puckvy
.2xx:
	lda.w PenShotActive
	beq .rtl
	lda.w #$0012
	sta.b d0
	jsl.l assreplace
.rtl:
	rtl
