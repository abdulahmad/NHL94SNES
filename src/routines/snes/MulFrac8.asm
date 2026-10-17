; A * B (high byte of C) / 128 into A (8-bit); bit 6 of $07E2 set: shift-and-add loop instead of the mode 7
; multiplier
MulFrac8:
	bit.w Mode7InUse
	bvc .hw
	rep #$20
	asl a
	sta.b MulCand+2
	lsr a
	and.w #$00FF
	sta.b MulCand
	lda.w #$0000
	asl.b MulCand+2
	bcc .0
	adc.b MulCand
.0:
	asl a
	asl.b MulCand+2
	bcc .1
	adc.b MulCand
.1:
	asl a
	asl.b MulCand+2
	bcc .2
	adc.b MulCand
.2:
	asl a
	asl.b MulCand+2
	bcc .3
	adc.b MulCand
.3:
	asl a
	asl.b MulCand+2
	bcc .4
	adc.b MulCand
.4:
	asl a
	asl.b MulCand+2
	bcc .5
	adc.b MulCand
.5:
	asl a
	asl.b MulCand+2
	bcc .6
	adc.b MulCand
.6:
	asl a
	xba
	sep #$20
	rts
.hw:
	asl a
	sta.w M7A
	stz.w M7A
	xba
	sta.w M7B
	lda.w MPYM
	rts
