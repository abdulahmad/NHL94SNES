; Common start of the stats screens: blank, the fonts, the team logos and the background
; Takes a2 = team offset (saved and restored), setupvis = team of the logos shown (a value of $21 and up
; selects the extra background of SetupBackTiles and is reduced by $21). Fades out, sets up the video
; registers and loads fonts, frame tiles, team blocks and the menu background into VRAM and the palettes,
; then clears the text map and starts the sprites and the matchup pictures.
;
; Called from TeamRoster, setoptions, ShowPeriodStats, ShowGameStats, ShowOtherScores and EditLinesScreen.
SetupScreen:						; common setup of the stats screens
	stz.w FrameByNumber				; no frame picture
	lda.b a2						; keep the team offset
	pha
	jsl.l FadeOut					; fade the old screen out
	lda.w #TeamLogoSprites>>16		; decompress the team logo sprites to the work RAM
	sta.b p0+2
	lda.w #TeamLogoSprites
	sta.b p0
	lda.w #logosprbuf>>16
	sta.b p1+2
	lda.w #logosprbuf
	sta.b p1
	jsl.l Decompress				; unpack TeamLogoSprites
	jsl.l WaitFadeOut				; wait for black
	jsl.l forceblack				; force the screen black
	sep #$20						; BG1 map, BG2 map, BG1/2 character base, sprite size and TM
									; (BG1, BG2, sprites)
	lda.b #$00						;BG1 map at $0000
	sta.w BG1SC
	lda.b #$04						;BG2 map at $0400 words
	sta.w BG2SC
	lda.b #$12						;BG1 chars $2000, BG2 chars $1000
	sta.w BG12NBA
	lda.b #$03						;sprite chars at $6000, 8x8/16x16
	sta.w OBSEL
	lda.b #$13						;main screen: BG1, BG2, sprites
	sta.w TM
	rep #$30
	lda.w #$FF00					; character offset and font set for printing
	sta.l charofs
	sta.l printfontset
	lda.w #$0000					;second text set from character 0
	sta.l charofs2
	lda.l smallfontchars			; next free character after the small font
	sta.l nextfreechar
	asl a							;times 16 words per tile
	asl a
	asl a
	asl a
	adc.w #$1000					;plus the BG2 character base
	sta.w VMADDL					;VRAM address of the font
	lda.w #SmallFontTiles>>16		; small font tiles are decompressed and sent to VRAM
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SmallFontTiles
	txa								;X = bytes unpacked
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a							;/32 bytes per tile
	sta.b d0
	clc
	adc.l nextfreechar				;advance the free character
	sta.l nextfreechar
	sta.l Framercset				; first character of the frame tiles
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #unpackbuf
	sta.b a0
	lda.w #PixelRemap8F>>16			; remap the pixels of the frame tiles
	sta.b a1+2
	lda.w #PixelRemap8F
	sta.b a1
	jsl.l RemapTiles				;send them remapped
	lda.w #FramerTiles>>16			; frame tiles
	sta.b a0+2
	lda.w #FramerTiles
	sta.b a0
	lda.w #PixelRemap87>>16
	sta.b a1+2
	lda.w #PixelRemap87
	sta.b a1
	lda.w #$0004					;4 frame tiles
	sta.b d0
	clc
	adc.l nextfreechar
	sta.l nextfreechar
	sta.l scorechars				;score characters start here
	jsl.l RemapTiles
	lda.w #TeamBlocksTiles>>16		; team blocks tiles
	sta.b p0+2
	lda.w #TeamBlocksTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack TeamBlocksTiles
	txa								;tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.l nextfreechar
	sta.l nextfreechar
	sta.l ninetilechars				;team block characters
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					;$FFFF: continue at the current VRAM address
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.l nextfreechar
	sta.l ninetilechars				;nine-tile frame characters
	lda.w #FramerNineTileTiles>>16	; nine tile frame tiles
	sta.b p0+2
	lda.w #FramerNineTileTiles
	sta.b p0
	ldx.w #$0140					;$140 bytes = 10 tiles
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.l nextfreechar
	sta.l nextfreechar
	sta.l outlinechars				;outline characters
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.l nextfreechar
	sta.l outlinechars
	lda.w #FramerOutlineTiles>>16	; outline tiles
	sta.b p0+2
	lda.w #FramerOutlineTiles
	sta.b p0
	ldx.w #$0120					;$120 bytes = 9 tiles
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.l nextfreechar
	sta.l nextfreechar
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.l nextfreechar
	sec
	sbc.w #$0100					;pictures go $100 before the free character
	sta.l picchars					;picture characters
	lda.w #MenuBackTiles>>16		; menu background tiles
	sta.b p0+2
	lda.w #MenuBackTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack MenuBackTiles
	txa								;tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.l backchars					;background characters
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$1000					;at VRAM $1000
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #MenuBackMap>>16			; menu background map, pasted twice below
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
	lda.w #(logoboxmap+$6)>>16		;paste it into the logo box map
	sta.b p1+2
	lda.w #logoboxmap+$6
	sta.b p1
	lda.w #$0007
	sta.b r7						;7 columns
	sta.b r4
	sta.b r4+2
	lda.w #$0001
	sta.b r6						;1 row
	sta.b r6+2
	ldx.w #$0000
	ldy.w #$0000
	lda.w #$0C00					;palette 3
	jsl.l PasteMapPart				; copy part of map [p0] into the map at [p1], column X, row Y
	lda.w #$0007					;box is 7 wide
	sta.l logoboxmap
	sta.l logoboxmap+2				;and 7 high
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #textmap2>>16				;and fill the whole BG2 text map
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020					;32 columns
	sta.b r7
	lda.w #$001C					;28 rows
	sta.b r7+2
	ldx.w #$0000
	ldy.w #$0000
	lda.l charofs2
	clc
	adc.w #$0C00					;palette 3
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	lda.w #SetupScreenPalette>>16	; palette of the setup screen
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
	lda.l setupvis					;which background?
	cmp.w #$0021					;$21 and up have extra art
	bcs .t1
	jmp.w .3						;no: plain screen

.t1:								; extra background for setupvis of $21 and up
	sbc.w #$0021					;carry set: minus $21
	sta.l setupvis					;leaves the logo team
	lda.w #SetupBackTiles>>16
	sta.b p0+2
	lda.w #SetupBackTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SetupBackTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					;at the current VRAM address
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #SetupBackMap>>16
	sta.b p0+2
	lda.w #SetupBackMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SetupBackMap
	txa								;bytes unpacked
	sec
	sbc.w #$0008					;minus the 8-byte header
	tay								;index of the last entry
	lda.b p1
	clc
	adc.w #$0006					;skip the header
	sta.b p1
.loop:								; add the character offset to the map entries
	lda.b [p1],y
	beq .1							;blank entry stays blank
	clc
	adc.l backchars					;plus the background characters
	clc
	adc.l charofs2					;plus the text set offset
	clc
	adc.w #$0800					;palette 2
	tyx
	sta.l textmap2,x				;into the text map
.1:									; next map entry
	dey
	dey
	bpl .loop						;all entries
	lda.w #SetupScreenPalette>>16
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
	lda.b p0
	clc
	adc.w #$0020
	sta.b p0
	ldy.w #$0010					;colour 16
	ldx.w #$0010
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #SetupBackPalette>>16
	sta.b p0+2
	lda.w #SetupBackPalette
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SetupBackPalette
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$0020					;colour 32
	ldx.w #$0010
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
.3:									; common end: colour 0 is black
	sep #$20
	stz.w CGADD						;colour 0
	stz.w CGDATA					;black, low byte
	stz.w CGDATA					;high byte
	rep #$20
	lda.w #MenuBackPalette>>16		; menu background palette
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
	ldy.w #$0030					;colour 48
	ldx.w #$0020					;32 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.l ninetilechars
	clc
	adc.w #$1400					;palette 5
	sta.l ninetilechars				;nine-tile entry base
	lda.l outlinechars
	clc
	adc.w #$1000					;palette 4
	sta.l outlinechars				;outline entry base
	lda.w HomeTeam
	cmp.w #$0018					;a real team?
	bcs .1x							;no: keep a2
	stz.b a2						;home logo
.1x:								; visitors: below $18 (a2 = 2) when they are a real team
	lda.w VisTeam
	cmp.w #$0018
	bcs .2							;no: keep a2
	lda.w #$0002					;visitors' logo
	sta.b a2
.2:									; sprite palettes
	lda.w #SetupSpritePalette>>16
	sta.b p0+2
	lda.w #SetupSpritePalette
	sta.b p0
	ldy.w #$0080					;sprite palette 0
	ldx.w #$0010
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #UnusedSetupSpritePalette>>16
	sta.b p0+2
	lda.w #UnusedSetupSpritePalette
	sta.b p0
	ldy.w #$00C0
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	jsl.l ClearTextMap				; clear the text map
	jsl.l SendTextMap2
	jsl.l WaitFrame
	ldx.w #$0000					;sprite characters from 0
	ldy.w #$0180					;at VRAM $6000 / $0180
	lda.w #$6000
	jsl.l InitSprites				;start the sprite list
	jsl.l SpriteFrameStart			;begin the sprite frame
	jsl.l LoadPictureMap			; draw the matchup pictures
	lda.w #$3568					;backdrop colour
	sta.l colourbuf					;colour 0
	jsl.l DrawMatchupPictures
	pla								; restore the team offset
	sta.b a2
	rtl
