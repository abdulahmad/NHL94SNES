; Set up the scouting report screen: fade out, the logo sprites, fonts, background map and palettes, PPU
; registers and a clear text map
;
; Called from ScoutingReport. Takes no registers; it ends by building the picture map for the player
; pictures.
LoadScoutingScreen:					; set up the scouting screen graphics and palettes
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
	sta.w BG12NBA					;BG tile bases (BG1 $2000, BG2 $1000 words)
	lda.b #$03
	sta.w OBSEL						;sprite size and base
	lda.b #$13
	sta.w TM						;main screen layers
	rep #$30						; 16-bit: character offsets $FF00 for print, charofs2 = 0
	lda.w #$FF00
	sta.l charofs					;print tile offset
	sta.l printfontset				;print font set
	lda.w #$0000
	sta.l charofs2					;second map offset
	lda.l blankchar					;tile number
	asl a							;x16
	asl a
	asl a
	asl a
	adc.w #$1000					;plus VRAM $1000
	sta.w VMADDL					;VRAM address
	lda.l blankchar					;blank tile
	inc a							;+1
	sta.l smallfontchars			;small font
	sta.l outlinechars				;outline font starts there too
	lda.w #$0000					;fill value 0
	ldy.w #$FFFF					;increment mode
	ldx.w #$0020					;$20 bytes: the blank tile
	jsl.l FillVRAM					; fill VRAM with a word
	lda.w #SmallFontTiles>>16		; small font unpacked at unpackbuf; outlinechars and Framercset advance by
									; its size in tiles
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SmallFontTiles
	txa								;size in bytes
	lsr a							;/32
	lsr a
	lsr a
	lsr a
	lsr a							;tiles
	sta.b d0						;d0 = small font tiles
	clc
	adc.l outlinechars				;plus the outline start
	sta.l outlinechars				;outline font after it
	lda.b d0						;small font tiles
	clc
	adc.l smallfontchars			;plus the small font start
	sta.l Framercset				;framer after it
	lda.w #unpackbuf>>16			; remap the font pixels (PixelRemap8F)
	sta.b a0+2
	lda.w #unpackbuf
	sta.b a0
	lda.w #PixelRemap8F>>16
	sta.b a1+2
	lda.w #PixelRemap8F
	sta.b a1
	jsl.l RemapTiles
	lda.w #FramerTiles>>16			; framer tiles (4 tiles) remapped with PixelRemap87; scorechars follows
									; Framercset
	sta.b a0+2
	lda.w #FramerTiles
	sta.b a0
	lda.w #PixelRemap87>>16
	sta.b a1+2
	lda.w #PixelRemap87
	sta.b a1
	lda.w #$0004					;4 tiles
	sta.b d0
	clc
	adc.l outlinechars
	sta.l outlinechars				;outline after them
	lda.b d0
	clc
	adc.l Framercset				;plus the framer start
	sta.l scorechars				;score digits after it
	jsl.l RemapTiles
	lda.w #TeamBlocksTiles>>16		; team block tiles: outlinechars advances by their size, tiles copied to
									; VRAM at scorechars
	sta.b p0+2
	lda.w #TeamBlocksTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack TeamBlocksTiles
	txa								;size
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a							;/32
	clc
	adc.l outlinechars				;plus the outline start
	sta.l outlinechars				;outline after them
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
	tay								;VRAM address
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #FramerOutlineTiles>>16	; framer outline tiles to VRAM ($120 bytes)
	sta.b p0+2
	lda.w #FramerOutlineTiles
	sta.b p0
	ldx.w #$0120
	ldy.w #$FFFF					;follows on
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #MenuBackTiles>>16		; menu background tiles: backchars = their tile base, copied to VRAM
	sta.b p0+2
	lda.w #MenuBackTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack MenuBackTiles
	txa								;size
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a							;/32
	sta.l backchars					;menu back tiles start at 0
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$1000					;at VRAM $1000
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #MenuBackMap>>16			; menu background map pasted into textmap2 ($20 by $1C tiles), palette 3
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
	lda.w #$0020					;32 wide
	sta.b r7
	lda.w #$001C					;28 high
	sta.b r7+2
	ldx.w #$0000					;column 0
	ldy.w #$0000					;row 0
	lda.l charofs2					;second map offset
	clc
	adc.w #$0C00					;palette 3
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	lda.w #SetupScreenPalette>>16	; SetupScreenPalette to colours 0-$2F
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
	ldx.w #$0030					;48 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #RonBarrTiles>>16			; Ron Barr tiles unpacked and copied to VRAM
	sta.b p0+2
	lda.w #RonBarrTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack RonBarrTiles
	lda.w #unpackbuf>>16			;tiles
	sta.b p0+2						;follows on
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					;follows the previous tiles
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w HomeTeam					;home team
	cmp.w #$0018					;special team ($18 and up)?
	bcs .1							;yes
	stz.b a2						;home side
.1:									; if VisTeam >= $0018 go to .2, ...
	lda.w VisTeam					;visitors
	cmp.w #$0018					;special team?
	bcs .2							;yes
	lda.w #$0002					;visitors side
	sta.b a2
.2:									; p0 = RonBarrMap, p1+2 = $007F, p1 = $0000, ...
	lda.w #RonBarrMap>>16			; Ron Barr map: add backchars, charofs2 and palette 2 ($0800) to
									; the non-empty words, store in textmap2
	sta.b p0+2
	lda.w #RonBarrMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack RonBarrMap
	txa								;size
	sec
	sbc.w #$0008					;minus 8
	tay								;last word
	lda.b p1
	clc
	adc.w #$0006
	sta.b p1						;the header
.loop:								; walk the map backwards (y = byte offset)
	lda.b [p1],y					;map word
	beq .3							;empty
	clc
	adc.l backchars					;plus the tile base
	clc
	adc.l charofs2					;plus the map offset
	clc
	adc.w #$0800					;palette 2
	tyx								;byte offset
	sta.l textmap2,x				;into the map
.3:									; next word
	dey
	dey
	bpl .loop
	lda.w #SetupScreenPalette>>16	; palettes: SetupScreenPalette to colours 0 and $10, Ron Barr palette to
									; $20
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
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.b p0						;source
	clc
	adc.w #$0020					;next 16
	sta.b p0						;of the palette
	ldy.w #$0010					;colour $10
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #RonBarrPalette>>16
	sta.b p0+2
	lda.w #RonBarrPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack RonBarrPalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0020					;colour $20
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	sep #$20						; backdrop colour 0
	stz.w CGADD						;colour 0
	stz.w CGDATA					;black
	stz.w CGDATA					;high byte
	rep #$20
	lda.w #MenuBackPalette>>16		; menu background palette to colour $30
	sta.b p0+2
	lda.w #MenuBackPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack MenuBackPalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0030					;colour $30
	ldx.w #$0020					;32 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.l outlinechars				; outlinechars + $1000 (palette bits)
	clc
	adc.w #$1000
	sta.l outlinechars
	lda.w #SetupSpritePalette>>16	; sprite palettes to colours $80 and $C0, send, clear and send the text
									; map
	sta.b p0+2
	lda.w #SetupSpritePalette
	sta.b p0
	ldy.w #$0080					;colour $80
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #UnusedSetupSpritePalette>>16
	sta.b p0+2
	lda.w #UnusedSetupSpritePalette
	sta.b p0
	ldy.w #$00C0					;colour $C0
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	jsl.l ClearTextMap				; fill the text map with the blank tile
	jsl.l SendTextMap2
	jsl.l WaitFrame
	ldx.w #$0000					; sprites: init at $6000, start a frame, then the picture map
	ldy.w #$0180
	lda.w #$6000					;sprite tiles at $6000
	jsl.l InitSprites
	jsl.l SpriteFrameStart
	jsl.l LoadPictureMap			; unpack the picture map and add the tile base
	rtl
