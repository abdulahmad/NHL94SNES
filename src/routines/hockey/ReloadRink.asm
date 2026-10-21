; After a pause screen: unpack the rink map, tiles and palettes again, set the colours, SetHor and the
; sprites, then fade in
ReloadRink:							; called from PauseCrowdLevel, PauseEditLines, PauseGameStats, PauseOth...
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	lda.w #$FFFF
	sta.w FrameByNumber
	jsl.l BuildRinkMap
	lda.w #IceRinkTiles>>16
	sta.b p0+2
	lda.w #IceRinkTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack IceRinkTiles
	phx
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l SpriteFrameStart
	jsl.l SpriteFrameEnd
	jsl.l setplayercolors			; set the team colours and send the whole palette to CGRAM
	sep #$20
	lda.b #$00
	sta.w BG1SC
	lda.b #$05
	sta.w BG2SC
	lda.b #$12
	sta.w BG12NBA
	lda.b #$13
	sta.w TM
	lda.b #$03
	sta.w OBSEL
	rep #$20
	lda.w #palbuffer>>16
	sta.b p0+2
	lda.w #palbuffer
	sta.b p0
	ldy.w #$0000
	ldx.w #$0040
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	lda.w #$FF00
	sta.l charofs
	lda.w #$0000
	sta.l charofs2
	plx
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$1000
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w HomeTeam
	asl a
	asl a
	asl a
	tax
	lda.l CenterIceTable+2,x
	sta.b p0+2
	lda.l CenterIceTable,x
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	stx.b p1
	stx.b r0
	lda.w #unpackbuf>>16
	sta.b p0+2
	sta.b p1+2
	stz.b p0
	jsl.l LinearToPlanar
	ldx.b p1
	stx.b p0
	lda.l centericechars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	tay
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #FaceOffTiles>>16
	sta.b p0+2
	lda.w #FaceOffTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack FaceOffTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.l faceoffvrcset
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	tay
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #RinkLogoTiles>>16
	sta.b p0+2
	lda.w #RinkLogoTiles
	sta.b p0
	jsl.l Decompress				; unpack RinkLogoTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #RefTilesHor>>16
	sta.b p0+2
	lda.w #RefTilesHor
	sta.b p0
	jsl.l Decompress				; unpack RefTilesHor
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #RefTiles>>16
	sta.b p0+2
	lda.w #RefTiles
	sta.b p0
	jsl.l Decompress				; unpack RefTiles
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #SmallFontTiles>>16
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack SmallFontTiles
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	lda.l smallfontchars
	asl a
	asl a
	asl a
	asl a
	adc.w #$1000
	sta.w VMADDL
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #unpackbuf
	sta.b a0
	lda.w #PixelRemap83>>16
	sta.b a1+2
	lda.w #PixelRemap83
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
	lda.w #BigFontTiles>>16
	sta.b p0+2
	lda.w #BigFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack BigFontTiles
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	adc.l BigFontChars
	sta.l scorechars
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #TeamBlocksTiles>>16
	sta.b p0+2
	lda.w #TeamBlocksTiles
	sta.b p0
	jsl.l Decompress				; unpack TeamBlocksTiles
	txa
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l scorechars
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w reloadtime
	adc.w #$003C
	sta.w reloadtime
	lda.w #$FFFF
	sta.w textdirtylo
	stz.w textdirtyhi
	jsl.l SetHor					; switches to the horizontal rink
	ldx.w #$0000
	ldy.w #$01C0
	lda.w #$6000
	jsl.l InitSprites
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l SpriteFrameEnd
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l ScreenOn
	rtl
