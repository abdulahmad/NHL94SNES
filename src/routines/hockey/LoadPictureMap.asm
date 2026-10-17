; Unpack the 7 x 7 picture map (PictureMap) to $7F7780 and add the second font tile base and palette 3 to each
; word
LoadPictureMap:
	lda.w #PictureMap>>16
	sta.b p0+2
	lda.w #PictureMap
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$7780
	sta.b p1
	jsl.l Decompress
	lda.l picboxmap
	asl a
	sta.b r3
	lda.l picboxmap+2
	tax
	lda.b p1
	clc
	adc.w #$0006
	sta.b p1
.loop:
	ldy.b r3
	dey
	dey
.loop2:
	lda.b [p1],y
	clc
	adc.l charofs2
	clc
	adc.w #$0C00
	sta.b [p1],y
	dey
	dey
	bpl .loop2
	lda.b p1
	clc
	adc.b r3
	sta.b p1
	dex
	bne .loop
	rtl
