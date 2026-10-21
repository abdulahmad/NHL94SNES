; Puck contact with a player's stick, body or the goalie
checkpuckcoll_ccx:					; called from checkpuckcoll
	sty.b a2
	cpy.w puckc
	beq .rtl
	cpy.w #$0018
	bcs .rtl
	lda.w position,y
	bmi .rtl
	lda.w pfnc,y
	ora.w nopuck,y
	beq .4
.rtl:								; return
	rtl
.1:									; go to .5
	jmp.w .5
.2:									; position,y = 0: go to .9
	jmp.w .9
.4:									; xsave = X
	stx.b xsave
	ldx.w #$0000
.loop:								; loop: X + 1, X + 1, if not zero go to .loop, ...
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .loop
	ldx.b xsave
	lda.w pflags,y
	bit.w #$1000
	bne .1
	lda.w position,y
	beq .2
	lda.w puckz
	cmp.w #$0005
	bpl .1
	lda.w puckvz
	cmp.w #$0100
	bpl .1
	tya
	jsl.l GetHot
	ldy.b a2
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	bit.w #$8000
	beq .1x
	eor.w #$FFFF					; negate: two's complement
	inc a
.1x:								; if carry set go to .5, ...
	cmp.w #$000F
	bcs .5
	sta.b d0
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	bit.w #$8000
	beq .2x
	eor.w #$FFFF					; negate: two's complement
	inc a
.2x:								; if carry set go to .5, ...
	cmp.w #$000F
	bcs .5
	sta.b d1
	lda.b d0
	tax
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	sta.b d0
	lda.b d1
	tax
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	ldx.b curobj
	clc
	adc.b d0
	sta.b d0
	lda.w #$00C4
	sta.b d1
	lda.w nopuck+puckobj
	bmi .3
	beq .3
	lsr.b d1
	lsr.b d1
.3:									; if d1 < d0 go to .5, ...
	lda.b d1
	cmp.b d0
	bcc .5
	jsl.l puckstick					; the puck hits player a2's stick
	bra .6
.5:									; if position,y = 0 go to .7, ...
	lda.w position,y
	beq .7
	lda.w Xpos,y
	sec
	sbc.w puckx
	bit.w #$8000
	beq .1xx
	eor.w #$FFFF					; negate: two's complement
	inc a
.1xx:								; if carry set go to .6, ...
	cmp.w #$0009
	bcs .6
	sta.b d0
	lda.w Ypos,y
	sec
	sbc.w pucky
	bit.w #$8000
	beq .2xx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xx:								; if carry set go to .6, ...
	cmp.w #$0009
	bcs .6
	sta.b d1
	lda.b d0
	tax
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	sta.b d0
	lda.b d1
	tax
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	clc
	adc.b d0
	sta.b d0
	ldx.b a3
	cmp.w #$0041
	bcs .6
	jsl.l puckbody					; the puck hits player a2: a fast high puck knocks him down
.6:									; xsave = X
	stx.b xsave
	ldx.w #$001A
.loopx:								; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b d0,x
	dex
	dex
	bpl .loopx
	ldx.b xsave
	rtl
.7:									; d0 = Xpos,y - puckx, if minus go to .6, ...
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	cmp.w #$FFF5
	bmi .6
	cmp.w #$000B
	bpl .6
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	cmp.w #$FFF5
	bmi .6
	cmp.w #$000B
	bpl .6
	jsl.l puckgoalie				; the puck hits goalie a2: a save or not, by his save ratings
	bra .6
.8:									; index * 2 / 3, rounded (words)
	dw 0,1,1,2,3,3,4,5,5,6,7,7,8,9,9,10
	dw 11,11,12,13,13,14,15,15,16,17,17,18,19,19,20,21
	dw 21,22,23,23,24,25,25,26,27,27,28,29,29,30,31,31
.9:									; call GetFrameHot, if d0 bits $8000 clear go to .1xxx, ...
	tya
	jsl.l GetFrameHot
	lda.b d0
	bit.w #$8000
	beq .1xxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.1xxx:								; d2 = A, asl a, d4 = .8,x, ...
	sta.b d2
	asl a
	tax
	lda.l .8,x
	sta.b d4
	lda.b d1
	bit.w #$8000
	beq .2xxx
	eor.w #$FFFF					; negate: two's complement
	inc a
.2xxx:								; asl a, d3 = .8,x, call GetHot, ...
	asl a
	tax
	lda.l .8,x
	sta.b d3
	ldx.b curobj
	lda.b a2
	jsl.l GetHot
	ldy.b a2
	lda.b d0
	clc
	adc.w Xpos,y
	sec
	sbc.w puckx
	bit.w #$8000
	beq .3x
	eor.w #$FFFF					; negate: two's complement
	inc a
.3x:								; if carry set go to .6x, ...
	cmp.b d2
	bcs .6x
	sta.b d0
	lda.b d1
	clc
	adc.w Ypos,y
	sec
	sbc.w pucky
	bit.w #$8000
	beq .4x
	eor.w #$FFFF					; negate: two's complement
	inc a
.4x:								; if carry set go to .6x, ...
	cmp.b d2
	bcs .6x
	sta.b d1
	lda.b d3
	clc
	adc.b d4
	cmp.w #$0005
	bpl .5x
	lda.w #$0005
.5x:								; if carry clear go to .6x, ...
	cmp.w puckz
	bcc .6x
	lda.b d3
	sec
	sbc.b d4
	bmi .t1
	cmp.w puckz
	bcc .t1
.6x:								; go to .7
	jmp.w .7

.t1:								; call Mul8U, d0 = A, call Mul8U, ...
	lda.b d0
	tax
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	sta.b d0
	lda.b d1
	tax
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	clc
	adc.b d0
	sta.b d0
	lda.b d2
	tax
	jsl.l Mul8U						; A * X, 8 by 8 bits, unsigned, into A
	ldx.b curobj
	sta.b d1
	lda.w nopuck+puckobj
	bmi .2xxxx
	beq .2xxxx
.1xxxx:								; lsr d1, lsr d1
	lsr.b d1
	lsr.b d1
.2xxxx:								; if d1 < d0 go to .3xx, ...
	lda.b d1
	cmp.b d0
	bcc .3xx
	jsl.l puckstick					; the puck hits player a2's stick
.3xx:								; go to .7
	jmp.w .7
