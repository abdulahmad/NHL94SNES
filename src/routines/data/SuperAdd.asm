; password bits += d0
SuperAdd:
	phx
	lda.l passbits
	clc
	adc.b d0
	sta.l passbits
	bcc .ex
	ldx.w #$0002
.carry:
	lda.l passbits,x
	inc a
	sta.l passbits,x
	bne .ex
	inx
	inx
	cpx.w #$0010
	bne .carry
.ex:
	plx
	clc
	rtl
