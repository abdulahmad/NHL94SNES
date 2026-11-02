; Copy map [p0] (width, height) into the map at [p1], column X, row Y, adding A to each entry
PasteMap:							; called from DrawEditLinesBack, DrawMatchupPictures, DrawPlayerPicture...
	sta.b r7+2
	stx.b r5
	tya
	asl a
	ldx.b r7
	jsl.l Mul16U
	lda.b r5
	asl a
	clc
	adc.b r2
	adc.b p1
	sta.b p1
	ldy.w #$0000
	lda.b [p0],y
	sta.b r4
	iny
	iny
	lda.b [p0],y
	sta.b r4+2
	lda.b p0
	clc
	adc.w #$0006
	sta.b p0
.loop:								; loop: falls through
	ldx.b r4
	ldy.w #$0000
.loop2:								; loop: [p1],y = [p0],y + r7+2, Y + 1, Y + 1, ...
	lda.b [p0],y
	clc
	adc.b r7+2
	sta.b [p1],y
	iny
	iny
	dex
	bne .loop2
	lda.b r7
	asl a
	adc.b p1
	sta.b p1
	lda.b r4
	asl a
	adc.b p0
	sta.b p0
	dec.b r4+2
	bne .loop
	rtl
