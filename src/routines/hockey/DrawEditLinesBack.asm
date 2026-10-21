; Redraw the line editor background: clear the top, the frame, and the background map in map 2
DrawEditLinesBack:					; called from DrawEditLinesTitle
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawEditLinesBackPos>>16
	sta.b a1+2
	lda.w #DrawEditLinesBackPos
	sta.b a1
	jsl.l print						; print DrawEditLinesBackPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$000D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawEditLinesBackPos2>>16
	sta.b a1+2
	lda.w #DrawEditLinesBackPos2
	sta.b a1
	jsl.l print						; print DrawEditLinesBackPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa
	lda.w #$0011
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l FramerOutline
	lda.w #MenuBackMap>>16
	sta.b p0+2
	lda.w #MenuBackMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack MenuBackMap
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020
	sta.b r7
	lda.w #$0014
	sta.b r7+2
	ldx.w #$0000
	ldy.w #$0000
	lda.l charofs2
	clc
	adc.w #$0C00
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	pla
	rts
