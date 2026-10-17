; Copy X colours from [p0] into the colour buffer at colour Y
SetColours:							; copy X colours from [p0] into the colour buffer $7F7500, from colour Y
	stx.b r3+2
	tya
	asl a
	tax
	ldy.w #$0000
.loop:
	lda.b [p0],y
	sta.l colourbuf,x
	iny
	iny
	inx
	inx
	dec.b r3+2
	bne .loop
	rtl
