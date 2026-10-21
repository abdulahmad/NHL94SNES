; password bits += d0
SuperAdd:							; called from PWtoBits, PushBits
	phx
	lda.l passbits
	clc
	adc.b d0
	sta.l passbits
	bcc .ex
	ldx.w #$0002
.carry:								; loop: passbits,x = passbits,x + 1, if not zero go to .ex, ...
	lda.l passbits,x
	inc a
	sta.l passbits,x
	bne .ex							; no carry out: done
	inx
	inx
	cpx.w #$0010
	bne .carry
.ex:								; return
	plx								; restore X
	clc
	rtl
