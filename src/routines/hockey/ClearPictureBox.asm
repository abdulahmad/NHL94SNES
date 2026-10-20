; Blank the 6 x 6 picture area at x, y of the text map (under a logo sprite)
ClearPictureBox:					; called from DrawMatchupPictures, DrawPlayerCard
	lda.w #textmap>>16
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	stx.b r3
	tya
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.b r3
	asl a
	adc.b p1
	sta.b p1
	lda.w #$0006
	sta.b r3
.loop:								; loop: call MemFill, p1 = p1 + $0040, decrement r3, ...
	lda.l blankchar
	clc
	adc.l charofs
	ldx.w #$000C
	jsl.l MemFill
	lda.b p1
	clc
	adc.w #$0040
	sta.b p1
	dec.b r3
	bne .loop
	rtl
