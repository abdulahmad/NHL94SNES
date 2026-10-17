; cos A into A; 1024 steps a circle, $0100 = 1
Cos:
	clc
	adc.w #$0100
Sin:								; sin A into A; 1024 steps a circle, $0100 = 1
	phx
	and.w #$03FF
	cmp.w #$0200
	bcc .pos
	sbc.w #$0200
	cmp.w #$0100
	bcc .neg
	eor.w #$FFFF
	adc.w #$0200
.neg:
	asl a
	tax
	lda.w #$0000
	sec
	sbc.l SineTable,x
	plx
	rtl
.pos:
	cmp.w #$0100
	bcc .look
	eor.w #$FFFF
	adc.w #$0200
.look:
	asl a
	tax
	lda.l SineTable,x
	plx
	rtl
