; Game setup screen tiles: blankchar = $200, smallfontchars = $201, clear their VRAM, unpack the font
; (SmallFontTiles), then Framercset after it and scorechars 4 tiles further
;
; Called from setoptions.
InitSetupChars:						; set the tile numbers and load the font of the setup screen
	lda.w #$0200					; blank tile $200, small font tiles after it
	sta.l blankchar
	inc a
	sta.l smallfontchars
	lda.w #$0000					; fill VRAM $3000 words with 0 starting at tile 0
	ldy.w #$3000
	ldx.w #$0020
	jsl.l FillVRAM
	lda.w #SmallFontTiles>>16		; unpack SmallFontTiles to $7F0000
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	txa								; d0 = size in tiles (bytes / 32)
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	adc.l smallfontchars			; Framercset follows the font, scorechars 4 tiles after that
	sta.l Framercset
	adc.w #$0004
	sta.l scorechars
	rtl
