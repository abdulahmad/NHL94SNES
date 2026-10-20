; A * Y / 128 into A and $43; bit 6 of $07E2 set: shift-and-add loop instead of the mode 7 multiplier
MulFrac16:							; called from StartSoundVoice, StepTrack
	bit.w Mode7InUse-1
	bvc .hw
	cpy.b #$00
	beq .zero
	cmp.w #$0000
	bne .soft
.zero:								; return
	lda.w #$0000
	rts
.soft:								; MulPlier = Y, MulCand = A, MulCand+2 = 0, ...
	sty.b MulPlier
	sta.b MulCand
	stz.b MulCand+2
	stz.b MulProd
	stz.b MulProd+2
	ldy.b #$07
.loop:								; loop: asl MulCand, rol MulCand+2, if MulPlier = 0 go to .done, ...
	asl.b MulCand
	rol.b MulCand+2
	lda.b MulPlier
	beq .done
	lsr a
	sta.b MulPlier
	bcc .next
	lda.b MulProd
	clc
	adc.b MulCand
	sta.b MulProd
	lda.b MulProd+2
	adc.b MulCand+2
	sta.b MulProd+2
.next:								; Y - 1, if Y not yet 0 go to .loop
	dey
	bne .loop
.done:								; return
	lda.b MulProd+1
	rts
.hw:								; M7A = A, xba, M7A = A, ...
	sep #$20
	sta.w M7A
	xba
	sta.w M7A
	sty.w M7B
	rep #$20
	lda.w MPYM
	asl a
	sta.b MulProd+1
	rts
