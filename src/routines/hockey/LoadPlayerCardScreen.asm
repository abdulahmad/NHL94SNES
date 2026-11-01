; Set up the player card screen: fade out, the logo sprites, fonts, card graphics, map and palettes, clear
; text maps, sprites on
;
; Called from ShowPlayerCards. Takes no registers; the screen is shown with sprites on when it returns.
LoadPlayerCardScreen:				; set up the player card screen graphics and palettes
	jsl.l FadeOut					; fade out while the team logo sprites unpack to logosprbuf
	lda.w #TeamLogoSprites>>16
	sta.b p0+2
	lda.w #TeamLogoSprites
	sta.b p0
	lda.w #logosprbuf>>16
	sta.b p1+2
	lda.w #logosprbuf
	sta.b p1
	jsl.l Decompress				; unpack TeamLogoSprites
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; screen off; BG1 map at 0, BG2 map at $400 words, BG tiles/OBJ size set,
									; BG1 BG2 and sprites on (TM $13)
	sep #$20
	lda.b #$00
	sta.w BG1SC						;BG1 map at 0
	lda.b #$04
	sta.w BG2SC						;BG2 map at $400 words
	lda.b #$12
	sta.w BG12NBA					;BG tile bases
	lda.b #$03
	sta.w OBSEL						;sprite size and base
	lda.b #$13
	sta.w TM						;main screen layers
	rep #$30						; 16-bit: character offsets $FF00 for print, clear both text maps
	lda.w #$FF00
	sta.l charofs					;print tile offset
	sta.l printfontset				;print font set
	stz.w printm					;print mode 0
	lda.w #$0000
	sta.l charofs2					;second map offset
	jsl.l ClearTextMap				; fill the text map with the blank tile
	jsl.l ClearTextMap2				; fill the second text map with the blank tile
	lda.w #SmallFontTiles>>16		; small font to VRAM at smallfontchars * 16 + $1000, unpacked at unpackbuf
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	lda.l smallfontchars			;small font tile
	asl a							;x16
	asl a
	asl a
	asl a
	adc.w #$1000					;plus VRAM $1000
	sta.w VMADDL					;VRAM address
	jsl.l Decompress				; unpack SmallFontTiles
	txa								; d0 = tile count; remap the font pixels (PixelRemap8F) and the framer
									; tiles (PixelRemap87, 4 tiles)
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0						;tiles
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #unpackbuf
	sta.b a0
	lda.w #PixelRemap8F>>16
	sta.b a1+2
	lda.w #PixelRemap8F
	sta.b a1
	jsl.l remap
	lda.w #FramerTiles>>16
	sta.b a0+2
	lda.w #FramerTiles
	sta.b a0
	lda.w #PixelRemap87>>16
	sta.b a1+2
	lda.w #PixelRemap87
	sta.b a1
	lda.w #$0004					;4 tiles
	sta.b d0
	jsl.l remap
	lda.w #TeamBlocksTiles>>16		; unpack the team block tiles; picchars = scorechars + their size - $100,
									; then copy them to VRAM at scorechars
	sta.b p0+2
	lda.w #TeamBlocksTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack TeamBlocksTiles
	txa								;size
	lsr a							;/32
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l scorechars				;plus the score digits tile
	sec
	sbc.w #$0100					;minus $100
	sta.l picchars					;picture tile base
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.l scorechars				;score digits tile
	asl a							;x16
	asl a
	asl a
	asl a
	adc.w #$1000					;plus VRAM $1000
	tay
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #$0000					; card back tiles: unpack, cardframechars follows them, convert to planar
									; and copy to VRAM $1000
	sta.l cardbackchars				;card back starts at tile 0
	lda.w #CardBackTiles>>16
	sta.b p0+2
	lda.w #CardBackTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack CardBackTiles
	txa								;size
	lsr a							;/32
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l cardbackchars				;plus the card back start
	sta.w cardframechars			;frame tiles follow
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	stx.b p1						;planar copy after the data
	stx.b r0						;size
	jsl.l LinearToPlanar			;convert
	lda.b p1						;planar copy
	sta.b p0
	tax								;size
	ldy.w #$1000					;VRAM $1000
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #CardFrameTiles>>16		; card frame tiles: unpack and copy to VRAM straight after
	sta.b p0+2
	lda.w #CardFrameTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack CardFrameTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					;follows on
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #CardPictureMap>>16		; card picture map unpacked at picboxmap
	sta.b p0+2
	lda.w #CardPictureMap
	sta.b p0
	lda.w #picboxmap>>16
	sta.b p1+2
	lda.w #picboxmap
	sta.b p1
	jsl.l Decompress				; unpack CardPictureMap
	lda.l picboxmap					; r3 = bytes per row, x = rows; skip the 3 header words
	asl a							;x2
	sta.b r3						;bytes per row
	lda.l picboxmap+2				;rows
	tax								;X
	lda.b p1
	clc
	adc.w #$0006					;skip the header
	sta.b p1
.loop:								; one row, last word first
	ldy.b r3						;row width
	dey
	dey
.loop2:								; add the frame tile base, charofs2 and $1000 to each map word
	lda.b [p1],y					;map word
	clc
	adc.w cardframechars			;plus the frame tile base
	clc
	adc.l charofs2					;plus the map offset
	clc
	adc.w #$1000					;palette 4
	sta.b [p1],y					;stored
	dey
	dey
	bpl .loop2
	lda.b p1						; next row
	clc
	adc.b r3						;plus the row
	sta.b p1						;next row
	dex
	bne .loop
	lda.w #CardBackMap>>16			; card back map unpacked, pasted into textmap2 ($20 by $1C tiles)
	sta.b p0+2
	lda.w #CardBackMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack CardBackMap
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020					;32 wide
	sta.b r7
	lda.w #$001C					;28 high
	sta.b r7+2
	ldx.w #$0000					;column 0
	ldy.w #$0000					;row 0
	lda.l cardbackchars				;card back tile base
	clc
	adc.l charofs2					;plus the map offset
	clc
	adc.w #$1000					;palette 4
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	lda.w #SetupScreenPalette>>16	; SetupScreenPalette to colours 0-$3F; colour 0 of the CGRAM is black
	sta.b p0+2
	lda.w #SetupScreenPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SetupScreenPalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0000					;colour 0
	ldx.w #$0040					;64 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	sep #$20
	stz.w CGADD						;colour 0
	stz.w CGDATA					;black
	stz.w CGDATA					;high byte
	rep #$20
	lda.w #CardBackPalette>>16		; card back palette to colour $40, sprite palette to colour $80
	sta.b p0+2
	lda.w #CardBackPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack CardBackPalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0040					;colour $40
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #CardSpritePalette>>16
	sta.b p0+2
	lda.w #CardSpritePalette
	sta.b p0
	ldy.w #$0080					;colour $80
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #$0000					; backdrop colour 0 and send the colours
	sta.l colourbuf					;black backdrop
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.b a1+2						; print the "switch cards" text (save and restore a1), show text map 2
	pha
	lda.b a1
	pha
	lda.w #SwitchCardsYSwitchTeamsTxt>>16
	sta.b a1+2
	lda.w #SwitchCardsYSwitchTeamsTxt
	sta.b a1
	jsl.l print						; print SwitchCardsYSwitchTeamsTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l SendTextMap2
	ldx.w #$0000					; sprites: init at $6000, run one empty frame
	ldy.w #$0180
	lda.w #$6000					;sprite tiles at $6000
	jsl.l InitSprites
	jsl.l SpriteFrameStart
	jsl.l WaitFrame
	jsl.l SpriteFrameEnd
	lda.w #$0004					; BG1 scroll (4, -5)
	sta.w BG1HScroll
	lda.w #$FFFB
	sta.w BG1VScroll
	rtl
