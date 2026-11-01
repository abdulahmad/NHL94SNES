; After a pause screen: unpack the rink map, tiles and palettes again, set the colours, SetHor and the
; sprites, then fade in
ReloadRink:							; called from PauseCrowdLevel, PauseEditLines, PauseGameStats, PauseOth...
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	lda.w #$FFFF					;no cached sprite frame
	sta.w FrameByNumber				;forget the frame cache
	jsl.l BuildRinkMap				;rebuild the rink map
	lda.w #IceRinkTiles>>16
	sta.b p0+2
	lda.w #IceRinkTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack IceRinkTiles
	phx								;tiles size
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	jsl.l SpriteFrameStart
	jsl.l SpriteFrameEnd			;empty sprite table
	jsl.l setplayercolors			; set the team colours and send the whole palette to CGRAM
	sep #$20
	lda.b #$00
	sta.w BG1SC						;BG1 map at 0
	lda.b #$05
	sta.w BG2SC						;BG2 map at $500 words
	lda.b #$12
	sta.w BG12NBA					;BG tile bases
	lda.b #$13
	sta.w TM						;main screen layers
	lda.b #$03
	sta.w OBSEL						;sprite size and base
	rep #$20
	lda.w #palbuffer>>16
	sta.b p0+2
	lda.w #palbuffer
	sta.b p0
	ldy.w #$0000					;colour 0
	ldx.w #$0040					;32 colours
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	lda.w #$FF00					;print tile offset
	sta.l charofs
	lda.w #$0000
	sta.l charofs2					;second map offset
	plx								;tile size
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$1000					;rink tiles at VRAM $1000
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w HomeTeam					;home team
	asl a							;x8
	asl a
	asl a
	tax								;entry
	lda.l CenterIceTable+2,x		;its centre ice logo
	sta.b p0+2
	lda.l CenterIceTable,x
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	stx.b p1						;logo size
	stx.b r0						;r0 too
	lda.w #unpackbuf>>16
	sta.b p0+2						;same bank
	sta.b p1+2
	stz.b p0						;at unpackbuf
	jsl.l LinearToPlanar			;to bitplanes after it
	ldx.b p1						;converted
	stx.b p0
	lda.l centericechars			;centre ice tile
	asl a							;x16
	asl a
	asl a
	asl a
	adc.w #$1000					;plus VRAM $1000
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
	lda.l faceoffvrcset				;faceoff dot tile
	asl a							;x16
	asl a
	asl a
	asl a
	adc.w #$1000					;plus VRAM $1000
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
	ldy.w #$FFFF					;follows on
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
	ldy.w #$FFFF					;follows on
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
	ldy.w #$FFFF					;follows on
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
	txa								;size
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a							;/32
	sta.b d0						;d0 = font tiles
	lda.l smallfontchars			;small font tile
	asl a							;x16
	asl a
	asl a
	asl a
	adc.w #$1000					;plus VRAM $1000
	sta.w VMADDL					;VRAM address
	lda.w #unpackbuf>>16
	sta.b a0+2
	lda.w #unpackbuf
	sta.b a0
	lda.w #PixelRemap83>>16
	sta.b a1+2
	lda.w #PixelRemap83
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
	lda.w #BigFontTiles>>16
	sta.b p0+2
	lda.w #BigFontTiles
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack BigFontTiles
	txa								;size
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a							;/32
	sta.b d0						;tiles
	adc.l BigFontchars				;after the big font
	sta.l scorechars				;score digits after it
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					;follows on
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #TeamBlocksTiles>>16
	sta.b p0+2
	lda.w #TeamBlocksTiles
	sta.b p0
	jsl.l Decompress				; unpack TeamBlocksTiles
	txa								;size
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a							;/32
	adc.l scorechars				;result unused
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					;follows on
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w reloadtime				;reload time
	adc.w #$003C					;plus a second
	sta.w reloadtime				;counted
	lda.w #$FFFF					;nothing dirty
	sta.w textdirtylo
	stz.w textdirtyhi
	jsl.l SetHor					; switches to the horizontal rink
	ldx.w #$0000
	ldy.w #$01C0
	lda.w #$6000					;sprite tiles at $6000
	jsl.l InitSprites
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l SpriteFrameEnd
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l ScreenOn
	rtl
