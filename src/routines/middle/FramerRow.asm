; Draw one row of a frame into the text map at printx / printy: a corner, d0 - 2 middle tiles, a corner
FramerRow:							; called from Framer, FramerNineTile, FramerOutline
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.w printm
	sta.b tmp2
	tax
	lda.b [p0]
	clc
	adc.b tmp0
	sta.l textmap,x
	inc.b p0
	inc.b p0
	lda.b [p0]
	clc
	adc.b tmp0
	ldy.b d0
	dey
	dey
.loop:								; loop: X + 1, X + 1, textmap,x = A, ...
	inx
	inx
	sta.l textmap,x
	dey
	bne .loop
	inc.b p0
	inc.b p0
	lda.b [p0]
	clc
	adc.b tmp0
	sta.l textmap+2,x
	inc.w printy
	rts
