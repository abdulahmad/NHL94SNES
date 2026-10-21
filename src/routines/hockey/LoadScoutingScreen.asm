; Set up the scouting report screen: fade out, the logo sprites, fonts, background map and palettes, PPU
; registers and a clear text map
;
; Called from ScoutingReport. Takes no registers; it ends by building the picture map for the player
; pictures.
LoadScoutingScreen:					; set up the scouting screen graphics and palettes
	jsl.l FadeOut					; fade out while the team logo sprites unpack to $7F7800
	lda.w #TeamLogoSprites>>16
	sta.b p0+2
	lda.w #TeamLogoSprites
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$7800
	sta.b p1
	jsl.l Decompress
	jsl.l WaitFadeOut
	jsl.l forceblack				; screen off; BG1 map at 0, BG2 map at $400 words, BG tiles/OBJ size set,
									; BG1 BG2 and sprites on (TM $13)
	sep #$20
	lda.b #$00
	sta.w BG1SC
	lda.b #$04
	sta.w BG2SC
	lda.b #$12
	sta.w BG12NBA
	lda.b #$03
	sta.w OBSEL
	lda.b #$13
	sta.w TM
	rep #$30						; 16-bit: character offsets $FF00 for print, charofs2 = 0
	lda.w #$FF00
	sta.l charofs
	sta.l printfontset
	lda.w #$0000
	sta.l charofs2
	lda.l blankchar					; clear VRAM from blankchar; the small font follows the blank tile
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	lda.l blankchar
	inc a
	sta.l smallfontchars
	sta.l outlinechars
	lda.w #$0000
	ldy.w #$FFFF
	ldx.w #$0020
	jsl.l FillVRAM
	lda.w #SmallFontTiles>>16		; small font unpacked at $7F0000; outlinechars and Framercset advance by
									; its size in tiles
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	clc
	adc.l outlinechars
	sta.l outlinechars
	lda.b d0
	clc
	adc.l smallfontchars
	sta.l Framercset
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
	lda.w #$0004
	sta.b d0
	clc
	adc.l outlinechars
	sta.l outlinechars
	lda.b d0
	clc
	adc.l Framercset
	sta.l scorechars
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
	jsl.l Decompress
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.l outlinechars
	sta.l outlinechars
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.l scorechars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	tay
	jsl.l DMAToVRAM
	lda.w #FramerOutlineTiles>>16	; framer outline tiles to VRAM ($120 bytes)
	sta.b p0+2
	lda.w #FramerOutlineTiles
	sta.b p0
	ldx.w #$0120
	ldy.w #$FFFF
	jsl.l DMAToVRAM
	lda.w #MenuBackTiles>>16		; menu background tiles: backchars = their tile base, copied to VRAM
	sta.b p0+2
	lda.w #MenuBackTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.l backchars
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$1000
	jsl.l DMAToVRAM
	lda.w #MenuBackMap>>16			; menu background map pasted into textmap2 ($20 by $1C tiles), palette 3
	sta.b p0+2
	lda.w #MenuBackMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
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
	lda.w #$001C
	sta.b r7+2
	ldx.w #$0000
	ldy.w #$0000
	lda.l charofs2
	clc
	adc.w #$0C00
	jsl.l PasteMap
	lda.w #SetupScreenPalette>>16	; SetupScreenPalette to colours 0-$2F
	sta.b p0+2
	lda.w #SetupScreenPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0000
	ldx.w #$0030
	jsl.l SetColours
	lda.w #RonBarrTiles>>16			; Ron Barr tiles unpacked and copied to VRAM
	sta.b p0+2
	lda.w #RonBarrTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM
	lda.w HomeTeam					; a2 = 0 if the home team is below $18; a2 = 2 if the visitors are
	cmp.w #$0018
	bcs .1
	stz.b a2
.1:									; if VisTeam >= $0018 go to .2, ...
	lda.w VisTeam
	cmp.w #$0018
	bcs .2
	lda.w #$0002
	sta.b a2
.2:									; p0 = RonBarrMap, p1+2 = $007F, p1 = $0000, ...
	lda.w #RonBarrMap>>16			; Ron Barr map: add backchars, charofs2 and the priority bit ($0800) to
									; the non-empty words, store in textmap2
	sta.b p0+2
	lda.w #RonBarrMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	txa
	sec
	sbc.w #$0008
	tay
	lda.b p1
	clc
	adc.w #$0006
	sta.b p1
.loop:								; walk the map backwards (y = byte offset)
	lda.b [p1],y
	beq .3
	clc
	adc.l backchars
	clc
	adc.l charofs2
	clc
	adc.w #$0800
	tyx
	sta.l textmap2,x
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
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0000
	ldx.w #$0010
	jsl.l SetColours
	lda.b p0
	clc
	adc.w #$0020
	sta.b p0
	ldy.w #$0010
	ldx.w #$0010
	jsl.l SetColours
	lda.w #RonBarrPalette>>16
	sta.b p0+2
	lda.w #RonBarrPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0020
	ldx.w #$0010
	jsl.l SetColours
	sep #$20						; backdrop colour 0
	stz.w CGADD
	stz.w CGDATA
	stz.w CGDATA
	rep #$20
	lda.w #MenuBackPalette>>16		; menu background palette to colour $30
	sta.b p0+2
	lda.w #MenuBackPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0030
	ldx.w #$0020
	jsl.l SetColours
	lda.l outlinechars				; outlinechars + $1000 (palette bits)
	clc
	adc.w #$1000
	sta.l outlinechars
	lda.w #SetupSpritePalette>>16	; sprite palettes to colours $80 and $C0, send, clear and send the text
									; map
	sta.b p0+2
	lda.w #SetupSpritePalette
	sta.b p0
	ldy.w #$0080
	ldx.w #$0010
	jsl.l SetColours
	lda.w #UnusedSetupSpritePalette>>16
	sta.b p0+2
	lda.w #UnusedSetupSpritePalette
	sta.b p0
	ldy.w #$00C0
	ldx.w #$0010
	jsl.l SetColours
	jsl.l SendColours
	jsl.l ClearTextMap
	jsl.l SendTextMap2
	jsl.l WaitFrame
	ldx.w #$0000					; sprites: init at $6000, start a frame, then the picture map
	ldy.w #$0180
	lda.w #$6000
	jsl.l InitSprites
	jsl.l SpriteFrameStart
	jsl.l LoadPictureMap
	rtl
