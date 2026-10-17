; Assignment $14: the puck carrier dumps the puck in: shoot when close in (CompShoot), else lift it (puckflip)
; toward the target DumpInTarget picked (over the blue line, a corner or the front of the net) and let go of
; it
assdumpin:
	cpx.w puckc
	bne .t2
	lda.w pflags,x
	bit.w #$0002
	beq .t3
	jsl.l DumpInTarget
	lda.w pflags,x
	and.w #$FFFD
	sta.w pflags,x
	lda.w playerpad,x
	bpl .t3
	lda.w dumpintarget
	cmp.w #$0014
	beq .t1
	cmp.w #$0008
	beq .t1
.rtl:
	rtl

.t1:
	jmp.w CompShoot

.t2:
	jmp.w assexit

.t3:
	ldy.w #$0000
	lda.w passdir
	cmp.w facedir,x
	beq .t1x
	iny
	dec a
	and.w #$0007
	cmp.w facedir,x
	beq .t1x
	iny
	inc a
	inc a
	and.w #$0007
	cmp.w facedir,x
	beq .t1x
	lda.w passdir
	sta.b d0
	jsl.l AdjustFacingDirection
	rtl

.t1x:
	lda.w position,x
	bne .2
.1:
	tya
	asl a
	adc.w dumpintarget
	sta.w dumpintarget
	lda.w facedir,x
	sta.w passdir
.2:
	jsl.l .t2x
	jmp.w assexit

.t2x:
	phk
	plb
	lda.w #$000F
	sec
	sbc.w passacc,x
	asl a
	sta.b d4
	ldy.w dumpintarget
	lda.w .6,y
	clc
	adc.b d4
	jsl.l randomd0s
	clc
	adc.w .8,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w .7,y
	clc
	adc.b d4
	jsl.l randomd0s
	clc
	adc.w .ytab,y
	sec
	sbc.w pucky
	sta.b d1
	ldy.b d0
	jsl.l ApproxLength
	sta.b d2
	asl a
	asl a
	asl a
	asl a
	tax
	lda.w #$0078
	jsl.l DivX8U
	cmp.w #$0060
	bcc .2x
.1x:
	lda.w #$0060
.2x:
	ldx.b curobj
	ldy.w position,x
	beq .t1xx
	cmp.w #$0010
	bcs .4
.3:
	lda.w #$0010
.4:
	bra .5

.t1xx:
	cmp.w #$0020
	bcs .5
	lda.w #$0020
.5:
	sta.b d3
	ldx.b d0
	jsl.l Mul16x8XS
	lda.b d2
	sta.b r1
	jsl.l Div32S
	lda.b r0
	xba
	and.w #$FF00
	sta.w puckvx
	lda.b d3
	ldx.b d1
	jsl.l Mul16x8XS
	lda.b d2
	sta.b r1
	jsl.l Div32S
	lda.b r0
	xba
	and.w #$FF00
	sta.w puckvy
	asl a
	asl a
	asl a
	asl a
	lda.w #$03C0
	sec
	sbc.b d4
	jsl.l randoma
	clc
	adc.w #$10E0
	sta.w puckvz
	jsl.l puckflip
	ldx.b curobj
	lda.w #$FFFF
	sta.w dumpinplayer
	sta.w puckc
	lda.w #$001E
	sta.w nopuck,x
	txa
	lsr a
	sta.w lastplayer
	jmp.w dopass_swing
.6:									; by target: the x spread (plus the rating term)
	dw 25,25,25,25,20,25,25,25,25,25,20,25
.7:									; by target: the y spread
	dw 20,25,25,70,20,70,20,25,25,70,20,70
.8:									; by target: x
	dw 0,-80,80,-80,0,80,0,80,-80,-80,0,80
.ytab:								; by target: y (toward the goal; the second half for the other end)
	dw -105,-115,-115,-180,-215,-180,105,115,115,180,215,180
