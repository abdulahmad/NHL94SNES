; Turn the password characters into the password bits
PWtoBits:							; called from DecodePW
	jsl.l ClrPassBits
	ldx.w #$0000
.char:								; loop: d0 = PWrange, call SuperMult, d0 = PassWord,x & $00FF, ...
	lda.w #PWrange
	sta.b d0
	jsl.l SuperMult
	lda.l PassWord,x
	and.w #$00FF
	sta.b d0
	stz.b d0+2
	jsl.l SuperAdd
	inx
	cpx.w #pwlength
	bne .char
	rtl
