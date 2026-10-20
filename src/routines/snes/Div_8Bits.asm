; $09-$0A:$08 / $04 when the quotient fits in 8 bits
Div_8Bits:							; called from Div16U_Go, Div32U
	stz.b r0
	rep #$20
	lda.b r2+1
	ldx.w #$0008
.loop:								; loop: asl r1+3, rol a, if carry set go to .sub, ...
	asl.b r1+3
	rol a
	bcs .sub
	cmp.b r1
	bcc .bit
.sub:								; sbc r1
	sbc.b r1
	sec
.bit:								; rol r0, X - 1, if X not yet 0 go to .loop, ...
	rol.b r0
	dex
	bne .loop
	rtl
