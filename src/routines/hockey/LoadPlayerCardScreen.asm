; Set up the player card screen: fade out, the logo sprites, fonts, card graphics, map and palettes, clear
; text maps, sprites on
LoadPlayerCardScreen:
	jsl.l FadeOut
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
	jsl.l forceblack
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
	rep #$30
	lda.w #$FF00
	sta.l charofs
	sta.l printfontset
	stz.w printm
	lda.w #$0000
	sta.l charofs2
	jsl.l ClearTextMap
	jsl.l ClearTextMap2
	lda.w #SmallFontTiles>>16
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	lda.l smallfontchars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	jsl.l Decompress
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	lda.w #$007F
	sta.b a0+2
	lda.w #$0000
	sta.b a0
	lda.w #PixelRemap8F>>16
	sta.b a1+2
	lda.w #PixelRemap8F
	sta.b a1
	jsl.l RemapTiles
	lda.w #FramerTiles>>16
	sta.b a0+2
	lda.w #FramerTiles
	sta.b a0
	lda.w #PixelRemap87>>16
	sta.b a1+2
	lda.w #PixelRemap87
	sta.b a1
	lda.w #$0004
	sta.b d0
	jsl.l RemapTiles
	lda.w #TeamBlocksTiles>>16
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
	adc.l scorechars
	sec
	sbc.w #$0100
	sta.l picchars
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	lda.l scorechars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	tay
	jsl.l DMAToVRAM
	lda.w #$0000
	sta.l cardbackchars
	lda.w #CardBackTiles>>16
	sta.b p0+2
	lda.w #CardBackTiles
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
	adc.l cardbackchars
	sta.w cardframechars
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	stx.b p1
	stx.b r0
	jsl.l LinearToPlanar
	lda.b p1
	sta.b p0
	tax
	ldy.w #$1000
	jsl.l DMAToVRAM
	lda.w #CardFrameTiles>>16
	sta.b p0+2
	lda.w #CardFrameTiles
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
	lda.w #CardPictureMap>>16
	sta.b p0+2
	lda.w #CardPictureMap
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
	adc.w cardframechars
	clc
	adc.l charofs2
	clc
	adc.w #$1000
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
	lda.w #CardBackMap>>16
	sta.b p0+2
	lda.w #CardBackMap
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
	lda.l cardbackchars
	clc
	adc.l charofs2
	clc
	adc.w #$1000
	jsl.l PasteMap
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
	ldx.w #$0040
	jsl.l SetColours
	sep #$20
	stz.w CGADD
	stz.w CGDATA
	stz.w CGDATA
	rep #$20
	lda.w #CardBackPalette>>16
	sta.b p0+2
	lda.w #CardBackPalette
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
	ldy.w #$0040
	ldx.w #$0010
	jsl.l SetColours
	lda.w #CardSpritePalette>>16
	sta.b p0+2
	lda.w #CardSpritePalette
	sta.b p0
	ldy.w #$0080
	ldx.w #$0010
	jsl.l SetColours
	lda.w #$0000
	sta.l colourbuf
	jsl.l SendColours
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #SwitchCardsYSwitchTeamsTxt>>16
	sta.b a1+2
	lda.w #SwitchCardsYSwitchTeamsTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l SendTextMap2
	ldx.w #$0000
	ldy.w #$0180
	lda.w #$6000
	jsl.l InitSprites
	jsl.l SpriteFrameStart
	jsl.l WaitFrame
	jsl.l SpriteFrameEnd
	lda.w #$0004
	sta.w BG1HScroll
	lda.w #$FFFB
	sta.w BG1VScroll
	rtl
