; Game setup screen tiles: blankchar = $200, smallfontchars = $201, clear their VRAM, unpack the font
; (SmallFontTiles), then Framercset after it and scorechars 4 tiles further
InitSetupChars:
	lda.w #$0200
	sta.l blankchar
	inc a
	sta.l smallfontchars
	lda.w #$0000
	ldy.w #$3000
	ldx.w #$0020
	jsl.l FillVRAM
	lda.w #SmallFontTiles>>16
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	adc.l smallfontchars
	sta.l Framercset
	adc.w #$0004
	sta.l scorechars
	rtl
