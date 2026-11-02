; A = the approximate length of the vector (A, Y)
ApproxLength:						; called from CollisionSfx, FallDown, Holdplayer, assdumpin, assgoalie...
	cmp.w #$0000
	bpl .1
	eor.w #$FFFF					; negate: two's complement
	inc a
.1:									; r3 = A, if plus go to .2, ...
	sta.b r3
	tya
	bpl .2
	eor.w #$FFFF					; negate: two's complement
	inc a
.2:									; falls through
	ldy.b r3
ApproxLength_abs:					; called from CalcPuckDistances, updateplayers
	sty.b r3
	cmp.b r3
	bcs .1
	sta.b r3
	tya
.1:									; r3+2 = A, lsr a, if carry clear go to .t1, ...
	sta.b r3+2
	lsr a
	cmp.b r3
	bcc .t1
	lda.b r3
	lsr a
	lsr a
	clc
	adc.b r3+2
	rtl

.t1:								; return
	lda.b r3
	lsr a
	clc
	adc.b r3
	lsr a
	lsr a
	clc
	adc.b r3+2
	rtl
