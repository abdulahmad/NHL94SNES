; password bits *= d0
SuperMult:							; called from PWtoBits, PushBits
	phx
	ldx.w #$000E
.loop:								; loop: mulres,x = passbits,x, passbits,x = $0000, X - 1, ...
	lda.l passbits,x
	sta.b mulres,x
	lda.w #$0000
	sta.l passbits,x
	dex
	dex
	bpl .loop
	lda.b d0						; multiplier
	sta.b tmp4
.loop2:								; loop: lsr tmp4, if carry clear go to .1, ...
	lsr.b tmp4						; next multiplier bit
	bcc .1							; clear: no add
	lda.l passbits
	clc
	adc.b mulres
	sta.l passbits
	lda.l passbits+2
	adc.b mulres+2
	sta.l passbits+2
	lda.l passbits+4
	adc.b mulres+4
	sta.l passbits+4
	lda.l passbits+6
	adc.b mulres+6
	sta.l passbits+6
	lda.l passbits+8
	adc.b mulres+8
	sta.l passbits+8
	lda.l passbits+$A
	adc.b mulres+10
	sta.l passbits+$A
	lda.l passbits+$C
	adc.b mulres+12
	sta.l passbits+$C
	lda.l passbits+$E
	adc.b mulres+14
	sta.l passbits+$E
.1:									; asl mulres, rol mulres+2, rol mulres+4, ...
	asl.b mulres
	rol.b mulres+2
	rol.b mulres+4
	rol.b mulres+6
	rol.b mulres+8
	rol.b mulres+10
	rol.b mulres+12
	rol.b mulres+14
	lda.b tmp4						; more bits
	bne .loop2
	plx								; restore X
	clc								; clear carry
	rtl
