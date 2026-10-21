; Unpack the 7 x 7 picture map (PictureMap) to picboxmap and add the second font tile base and palette 3 to
; each word
;
; Called from SetupScreen and LoadScoutingScreen. Decompresses to picboxmap.
LoadPictureMap:						; unpack the picture map and add the tile base
	lda.w #PictureMap>>16			; unpack PictureMap to picboxmap
	sta.b p0+2
	lda.w #PictureMap
	sta.b p0
	lda.w #picboxmap>>16
	sta.b p1+2
	lda.w #picboxmap
	sta.b p1
	jsl.l Decompress				; unpack PictureMap
	lda.l picboxmap					; r3 = bytes per row, x = number of rows (from picboxmap); skip the 3
									; header words
	asl a
	sta.b r3
	lda.l picboxmap+2
	tax
	lda.b p1
	clc
	adc.w #$0006
	sta.b p1
.loop:								; one row, last word first
	ldy.b r3
	dey
	dey
.loop2:								; add the font tile base (charofs2) and palette 3 ($0C00) to each tile
									; word
	lda.b [p1],y
	clc
	adc.l charofs2
	clc
	adc.w #$0C00
	sta.b [p1],y
	dey
	dey
	bpl .loop2
	lda.b p1						; next row
	clc
	adc.b r3
	sta.b p1
	dex
	bne .loop
	rtl
