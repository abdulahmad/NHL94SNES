; Puck contact with a player's stick, body or the goalie
checkpuckcoll_ccx:					; called from checkpuckcoll
	sty.b a2						;the player
	cpy.w puckc						;carrying it already?
	beq .rtl						;yes: nothing
	cpy.w #$0018					;a player?
	bcs .rtl						;no
	lda.w position,y				;on the ice?
	bmi .rtl						;no
	lda.w pfnc,y					;no-collision
	ora.w nopuck,y					;or puck lockout
	beq .4							;clear: check
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
	cpx.w #$001C					;14 words
	bne .loop
	ldx.b xsave
	lda.w pflags,y					;flags
	bit.w #$1000					;falling?
	bne .1							;yes: body only
	lda.w position,y				;goalie?
	beq .2							;yes: goalie check
	lda.w puckz						;puck height
	cmp.w #$0005					;5 or more?
	bpl .1							;too high for the stick
	lda.w puckvz					;rising?
	cmp.w #$0100					;fast: too high
	bpl .1
	tya								;his stick spot
	jsl.l GetHot
	ldy.b a2
	lda.b d0						;stick x offset
	clc
	adc.w Xpos,y					;plus his x
	sec
	sbc.w puckx						;minus the puck x
	bit.w #$8000
	beq .1x							;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|dx|
.1x:								; if carry set go to .5, ...
	cmp.w #$000F					;within 15?
	bcs .5							;no: body
	sta.b d0
	lda.b d1						;stick y offset
	clc
	adc.w Ypos,y					;plus his y
	sec
	sbc.w pucky						;minus the puck y
	bit.w #$8000
	beq .2x							;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|dy|
.2x:								; if carry set go to .5, ...
	cmp.w #$000F					;within 15?
	bcs .5							;no: body
	sta.b d1
	lda.b d0
	tax
	jsl.l Mul8U						;dx^2
	sta.b d0
	lda.b d1
	tax								;dy
	jsl.l Mul8U						;dy^2
	ldx.b curobj
	clc
	adc.b d0						;plus dx^2
	sta.b d0						;squared distance
	lda.w #$00C4					;reach^2 196 (14)
	sta.b d1
	lda.w nopuck+puckobj			;puck lockout
	bmi .3							;none
	beq .3							;none
	lsr.b d1						;locked out: 7
	lsr.b d1
.3:									;reach^2
	lda.b d1
	cmp.b d0						;in reach?
	bcc .5							;no: body
	jsl.l puckstick					;stick on the puck
	bra .6
.5:									; if position,y = 0 go to .7, ...
	lda.w position,y				;goalie?
	beq .7							;yes: goalie check
	lda.w Xpos,y					;his x
	sec
	sbc.w puckx						;minus the puck x
	bit.w #$8000
	beq .1xx						;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|dx|
.1xx:								; if carry set go to .6, ...
	cmp.w #$0009					;within 9?
	bcs .6							;no: done
	sta.b d0
	lda.w Ypos,y					;his y
	sec
	sbc.w pucky						;minus the puck y
	bit.w #$8000
	beq .2xx						;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|dy|
.2xx:								; if carry set go to .6, ...
	cmp.w #$0009					;within 9?
	bcs .6							;no: done
	sta.b d1
	lda.b d0
	tax
	jsl.l Mul8U						;dx^2
	sta.b d0
	lda.b d1
	tax								;dy
	jsl.l Mul8U						;dy^2
	clc
	adc.b d0						;plus dx^2
	sta.b d0
	ldx.b a3
	cmp.w #$0041					;within 8 (64)?
	bcs .6							;no
	jsl.l puckbody					;puck hits his body
.6:									; xsave = X
	stx.b xsave
	ldx.w #$001A					;14 words
.loopx:								; loop: d0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b d0,x
	dex
	dex
	bpl .loopx
	ldx.b xsave
	rtl
.7:									; d0 = Xpos,y - puckx, if minus go to .6, ...
	lda.w Xpos,y					;his x
	sec
	sbc.w puckx						;minus the puck x
	sta.b d0
	cmp.w #$FFF5					;within 11 left?
	bmi .6							;no
	cmp.w #$000B					;within 11 right?
	bpl .6							;no
	lda.w Ypos,y					;his y
	sec
	sbc.w pucky						;minus the puck y
	sta.b d1
	cmp.w #$FFF5					;within 11 up?
	bmi .6							;no
	cmp.w #$000B					;within 11 down?
	bpl .6							;no
	jsl.l puckgoalie				;goalie save check
	bra .6
.8:									; index * 2 / 3, rounded (words)
	dw 0,1,1,2,3,3,4,5,5,6,7,7,8,9,9,10
	dw 11,11,12,13,13,14,15,15,16,17,17,18,19,19,20,21
	dw 21,22,23,23,24,25,25,26,27,27,28,29,29,30,31,31
.9:									; call GetFrameHot, if d0 bits $8000 clear go to .1xxx, ...
	tya
	jsl.l GetFrameHot				;frame's stick spot
	lda.b d0						;x offset
	bit.w #$8000
	beq .1xxx						;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|x|
.1xxx:								; d2 = A, asl a, d4 = .8,x, ...
	sta.b d2						;reach
	asl a
	tax								;word index
	lda.l .8,x						;two thirds of it
	sta.b d4						;d4
	lda.b d1						;y offset
	bit.w #$8000
	beq .2xxx						;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|y|
.2xxx:								; asl a, d3 = .8,x, call GetHot, ...
	asl a							;word index
	tax
	lda.l .8,x						;two thirds
	sta.b d3						;d3 = stick height
	ldx.b curobj
	lda.b a2
	jsl.l GetHot					;stick spot of this frame
	ldy.b a2
	lda.b d0						;x offset
	clc
	adc.w Xpos,y					;plus his x
	sec
	sbc.w puckx						;minus the puck x
	bit.w #$8000
	beq .3x							;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|dx|
.3x:								; if carry set go to .6x, ...
	cmp.b d2						;within reach?
	bcs .6x							;no: goalie body
	sta.b d0
	lda.b d1						;y offset
	clc
	adc.w Ypos,y					;plus his y
	sec
	sbc.w pucky						;minus the puck y
	bit.w #$8000
	beq .4x							;plus
	eor.w #$FFFF					; negate: two's complement
	inc a							;|dy|
.4x:								; if carry set go to .6x, ...
	cmp.b d2						;within reach?
	bcs .6x							;no: goalie body
	sta.b d1
	lda.b d3						;height
	clc
	adc.b d4						;plus the low part
	cmp.w #$0005					;at least 5
	bpl .5x
	lda.w #$0005					;floor 5
.5x:								; if carry clear go to .6x, ...
	cmp.w puckz						;puck over the top?
	bcc .6x							;yes: body
	lda.b d3						;height
	sec
	sbc.b d4						;minus the low part
	bmi .t1							;at the ice: check
	cmp.w puckz						;puck below the bottom?
	bcc .t1							;no: check
.6x:								; go to .7
	jmp.w .7

.t1:								; call Mul8U, d0 = A, call Mul8U, ...
	lda.b d0						;dx
	tax
	jsl.l Mul8U						;dx^2
	sta.b d0
	lda.b d1						;dy
	tax
	jsl.l Mul8U						;dy^2
	clc
	adc.b d0						;plus dx^2
	sta.b d0						;d0
	lda.b d2						;reach
	tax
	jsl.l Mul8U						;reach^2
	ldx.b curobj
	sta.b d1						;d1
	lda.w nopuck+puckobj			;puck lockout
	bmi .2xxxx						;none
	beq .2xxxx						;none
.1xxxx:								; lsr d1, lsr d1
	lsr.b d1						;quartered
	lsr.b d1
.2xxxx:								; if d1 < d0 go to .3xx, ...
	lda.b d1						;reach^2
	cmp.b d0						;in reach?
	bcc .3xx						;no
	jsl.l puckstick					;goalie's stick on the puck
.3xx:								; go to .7
	jmp.w .7
