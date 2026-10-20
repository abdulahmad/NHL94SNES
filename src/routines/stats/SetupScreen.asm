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
	lda.w #$007F
	sta.b p1+2
	lda.w #$7800
	sta.b p1
	jsl.l Decompress
	jsl.l WaitFadeOut				; wait for black
	jsl.l forceblack				; force the screen black
	sep #$20						; BG1 map, BG2 map, BG1/2 character base, sprite size and TM
									; (BG1, BG2, sprites)
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
	rep #$30
	lda.w #$FF00					; character offset and font set for printing
	sta.l charofs
	sta.l printfontset
	lda.w #$0000
	sta.l charofs2
	lda.l smallfontchars			; next free character after the small font
	sta.l nextfreechar
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	lda.w #SmallFontTiles>>16		; small font tiles are decompressed and sent to VRAM
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	txa								; tile count = X / 32
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	clc
	adc.l nextfreechar
	sta.l nextfreechar
	sta.l Framercset				; first character of the frame tiles
	lda.w #$007F
	sta.b a0+2
	lda.w #$0000
	sta.b a0
	lda.w #PixelRemap8F>>16			; remap the pixels of the frame tiles
	sta.b a1+2
	lda.w #PixelRemap8F
	sta.b a1
	jsl.l RemapTiles
	lda.w #FramerTiles>>16			; frame tiles
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
	adc.l nextfreechar
	sta.l nextfreechar
	sta.l scorechars
	jsl.l RemapTiles
	lda.w #TeamBlocksTiles>>16		; team blocks tiles
	sta.b p0+2
	lda.w #TeamBlocksTiles
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
	clc
	adc.l nextfreechar
	sta.l nextfreechar
	sta.l ninetilechars
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	ldy.w #$FFFF					; send the tiles to VRAM
	jsl.l DMAToVRAM
	lda.l nextfreechar
	sta.l ninetilechars
	lda.w #FramerNineTileTiles>>16	; nine tile frame tiles
	sta.b p0+2
	lda.w #FramerNineTileTiles
	sta.b p0
	ldx.w #$0140
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	clc
	adc.l nextfreechar
	sta.l nextfreechar
	sta.l outlinechars
	ldy.w #$FFFF
	jsl.l DMAToVRAM
	lda.l nextfreechar
	sta.l outlinechars
	lda.w #FramerOutlineTiles>>16	; outline tiles
	sta.b p0+2
	lda.w #FramerOutlineTiles
	sta.b p0
	ldx.w #$0120
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
	jsl.l DMAToVRAM
	lda.l nextfreechar
	sec
	sbc.w #$0100
	sta.l picchars
	lda.w #MenuBackTiles>>16		; menu background tiles
	sta.b p0+2
	lda.w #MenuBackTiles
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
	sta.l backchars
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	ldy.w #$1000
	jsl.l DMAToVRAM
	lda.w #MenuBackMap>>16			; menu background map, pasted twice below
	sta.b p0+2
	lda.w #MenuBackMap
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$7706
	sta.b p1
	lda.w #$0007
	sta.b r7
	sta.b r4
	sta.b r4+2
	lda.w #$0001
	sta.b r6
	sta.b r6+2
	ldx.w #$0000
	ldy.w #$0000
	lda.w #$0C00
	jsl.l PasteMapPart
	lda.w #$0007
	sta.l logoboxmap
	sta.l logoboxmap+2
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
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
	lda.w #SetupScreenPalette>>16	; palette of the setup screen
	sta.b p0+2
	lda.w #SetupScreenPalette
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	ldy.w #$0000
	ldx.w #$0030
	jsl.l SetColours
	lda.l setupvis
	cmp.w #$0021
	bcs .t1
	jmp.w .3

.t1:								; extra background for setupvis of $21 and up
	sbc.w #$0021
	sta.l setupvis
	lda.w #SetupBackTiles>>16
	sta.b p0+2
	lda.w #SetupBackTiles
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM
	lda.w #SetupBackMap>>16
	sta.b p0+2
	lda.w #SetupBackMap
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
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
.loop:								; add the character offset to the map entries
	lda.b [p1],y
	beq .1
	clc
	adc.l backchars
	clc
	adc.l charofs2
	clc
	adc.w #$0800
	tyx
	sta.l textmap2,x
.1:									; next map entry
	dey
	dey
	bpl .loop
	lda.w #SetupScreenPalette>>16
	sta.b p0+2
	lda.w #SetupScreenPalette
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
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
	lda.w #SetupBackPalette>>16
	sta.b p0+2
	lda.w #SetupBackPalette
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	ldy.w #$0020
	ldx.w #$0010
	jsl.l SetColours
.3:									; common end: colour 0 is black
	sep #$20
	stz.w CGADD
	stz.w CGDATA
	stz.w CGDATA
	rep #$20
	lda.w #MenuBackPalette>>16		; menu background palette
	sta.b p0+2
	lda.w #MenuBackPalette
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	ldy.w #$0030
	ldx.w #$0020
	jsl.l SetColours
	lda.l ninetilechars
	clc
	adc.w #$1400
	sta.l ninetilechars
	lda.l outlinechars
	clc
	adc.w #$1000
	sta.l outlinechars
	lda.w HomeTeam
	cmp.w #$0018
	bcs .1x
	stz.b a2
.1x:								; visitors: below $18 (a2 = 2) when they are a real team
	lda.w VisTeam
	cmp.w #$0018
	bcs .2
	lda.w #$0002
	sta.b a2
.2:									; sprite palettes
	lda.w #SetupSpritePalette>>16
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
	jsl.l ClearTextMap				; clear the text map
	jsl.l SendTextMap2
	jsl.l WaitFrame
	ldx.w #$0000					; set up the sprites
	ldy.w #$0180
	lda.w #$6000
	jsl.l InitSprites
	jsl.l SpriteFrameStart
	jsl.l LoadPictureMap			; draw the matchup pictures
	lda.w #$3568
	sta.l colourbuf
	jsl.l DrawMatchupPictures
	pla								; restore the team offset
	sta.b a2
	rtl
