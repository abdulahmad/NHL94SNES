; Set up the rink: the rink and text graphics, the palettes and the objects
;
; Takes nothing, returns nothing. Called from StartGame. Waits for the screen to fade out, sets the video
; mode,
; unpacks every tile set into VRAM one after the other (each set starts where the last ended, counting
; 32 byte tiles) and falls into setupice_reset.
setupice:							; set up the rink screen
	lda.w brightness				; wait until the screen is faded out
	bne setupice
	jsl.l forceblack				; black screen
	lda.w #$FF00					; text map tile offset $FF00, second offset 0
	sta.l charofs
	lda.w #$0000
	sta.l charofs2
	sep #$20						; 8 bit A
	lda.b #$03						; OBSEL = 3: sprite sizes and tile base
	sta.w OBSEL
	lda.b #$01						; BGMODE = 1
	sta.w BGMODE
	lda.b #$00						; BG1SC = 0: BG1 map
	sta.w BG1SC
	lda.b #$05						; BG2SC = 5: BG2 map
	sta.w BG2SC
	lda.b #$12						; BG12NBA = $12: tile bases of BG1 and BG2
	sta.w BG12NBA
	lda.b #$13						; TM = $13: BG1, BG2 and sprites on the main screen
	sta.w TM
	rep #$30						; 16 bit again
	ldx.w #$00FE					; X = last word of the rink palette
.loop:								; copy RinkPalette into palbuffer, twice ($100 bytes apart)
	lda.l RinkPalette,x
	sta.l palbuffer,x
	sta.l palbuffer+(8*$20),x
	dex
	dex
	bpl .loop
	jsl.l FadeOutSound				; fade the music out
.loop2:								; wait for the fade
	lda.w SoundFadeSpeed
	bne .loop2
	jsl.l SPCGameUpload				; load the game music driver
	lda.w #IceRinkTiles>>16			; p0 = IceRinkTiles
	sta.b p0+2
	lda.w #IceRinkTiles
	sta.b p0
	lda.w #unpackbuf>>16			; p1 = unpackbuf: unpack to WRAM
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack, X = size in bytes
	txa								; tile count = size / 32
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.l centericechars			; centericechars: the centre ice logo goes after the rink tiles
	lda.w #unpackbuf>>16			; p0 = the unpacked tiles
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$1000					; VRAM address $1000
	jsl.l DMAToVRAM					; send them to VRAM
	jsl.l LoadCenterIce				; unpack the home team's centre ice logo to VRAM
	lda.w #FaceOffTiles>>16			; p0 = FaceOffTiles
	sta.b p0+2
	lda.w #FaceOffTiles
	sta.b p0
	lda.w #unpackbuf>>16			; p1 = unpackbuf
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack
	txa								; tile count of the face off tiles
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l faceoffvrcset				; plus the first free tile after the logo
	sta.l EASNcset					; EASNcset: first tile of RinkLogoTiles
	lda.w #unpackbuf>>16			; p0 = unpacked tiles
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF					; Y negative: continue at the current VRAM address
	jsl.l DMAToVRAM					; send them to VRAM
	lda.w #RinkLogoTiles>>16		; p0 = RinkLogoTiles
	sta.b p0+2
	lda.w #RinkLogoTiles
	sta.b p0
	jsl.l Decompress				; unpack
	txa								; tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l EASNcset					; plus EASNcset
	sta.l refcharshor				; refcharshor: first tile of RefTilesHor
	lda.w #unpackbuf>>16			; send the logo tiles to VRAM
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #RefTilesHor>>16			; p0 = RefTilesHor
	sta.b p0+2
	lda.w #RefTilesHor
	sta.b p0
	jsl.l Decompress				; unpack
	txa								; tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l refcharshor				; plus refcharshor
	sta.l refchars					; refchars: first tile of RefTiles
	lda.w #unpackbuf>>16			; send the horizontal ref tiles to VRAM
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #RefTiles>>16				; p0 = RefTiles
	sta.b p0+2
	lda.w #RefTiles
	sta.b p0
	jsl.l Decompress				; unpack
	txa								; tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l refchars					; plus refchars
	sta.l blankchar					; blankchar: the tile after the ref tiles
	inc a
	sta.l smallfontchars			; smallfontchars: the tile after the blank one
	lda.w #unpackbuf>>16			; send the ref tiles to VRAM
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #$0000					; fill 32 bytes of VRAM with 0: the blank tile
	ldy.w #$FFFF
	ldx.w #$0020
	jsl.l FillVRAM					; fill VRAM with a word
	lda.w #SmallFontTiles>>16		; p0 = SmallFontTiles
	sta.b p0+2
	lda.w #SmallFontTiles
	sta.b p0
	jsl.l Decompress				; unpack
	txa								; tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0						; kept in d0
	adc.l smallfontchars			; plus smallfontchars
	sta.l framercset				; framercset: first tile of the Framer box
	adc.w #$0004					; 4 tiles for the Framer box
	sta.l BigFontchars				; BigFontchars: first tile of the big font
	lda.w #unpackbuf>>16			; a0 = unpacked small font tiles
	sta.b a0+2
	lda.w #unpackbuf
	sta.b a0
	lda.w #PixelRemap83>>16			; a1 = pixel remap table
	sta.b a1+2
	lda.w #PixelRemap83
	sta.b a1
	jsl.l RemapTiles				; remap the small font tiles into VRAM
	lda.w #FramerTiles>>16			; a0 = FramerTiles
	sta.b a0+2
	lda.w #FramerTiles
	sta.b a0
	lda.w #PixelRemap87>>16			; a1 = the other pixel remap table
	sta.b a1+2
	lda.w #PixelRemap87
	sta.b a1
	lda.w #$0004					; 4 tiles
	sta.b d0
	jsl.l RemapTiles				; remap them into VRAM
	lda.w #BigFontTiles>>16			; p0 = BigFontTiles
	sta.b p0+2
	lda.w #BigFontTiles
	sta.b p0
	jsl.l Decompress				; unpack
	txa								; tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0						; kept in d0
	adc.l BigFontchars				; plus BigFontchars
	sta.l scorechars				; scorechars: first tile of the score tiles
	lda.w #unpackbuf>>16			; send the big font tiles to VRAM
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #TeamBlocksTiles>>16		; p0 = TeamBlocksTiles
	sta.b p0+2
	lda.w #TeamBlocksTiles
	sta.b p0
	jsl.l Decompress				; unpack
	txa								; tile count
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	adc.l scorechars				; plus scorechars
	sta.l ExtraChars				; ExtraChars: the tile after the last set
	lda.w #unpackbuf>>16			; send the team block tiles to VRAM
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	ldy.w #$FFFF
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
;
; Takes nothing, returns nothing. Called from SaveRegsStartHL2 and StartPer, and falls through from
; setupice. Resets the rink view and the sort objects, turns the goals around for the second half, sets the
; colours and fades in.
setupice_reset:						; reset the rink state and fade in
	jsl.l forceblack				; black screen
	lda.w #$03E7					; last rink map row = $03E7
	sta.w Oldrow
	lda.w #$0001					; sflags $0001 (sfpz): clear pause mode
	trb.w sflags
	stz.w Hpos						; scroll position 0, 0
	stz.w Vpos
	lda.b Vcount+2					; vcountmark+2 = Vcount+2 - 2
	dec a
	dec a
	sta.w vcountmark+2
	jsl.l InitSortObjects			; set up the sort objects
	jsl.l nullrtl					; no-op hook
	lda.w gmode						; direction of play (gmdir) set?
	bit.w #gmdir
	beq .1
	ldx.w #$0016					; 12 players
.loop:								; flip the goal each player shoots at
	lda.w pfgoal,x
	eor.w #$0001
	sta.w pfgoal,x
	dex
	dex
	bpl .loop
.1:									; set the colours
	jsl.l setplayercolors			; set the team colours and send the whole palette to CGRAM
	stz.w fadestep					; fade in
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l ScreenOn					; show the screen
	rtl
