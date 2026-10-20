; A: SpriteVRAM, X: SpritesReserved, Y: sizes the 16x16 block area of sprite VRAM;
InitSprites:						;A: SpriteVRAM, X: SpritesReserved, Y: sizes the 16x16 block area of
									;sprite VRAM;
		;   empties the tile allocators, then ends an empty frame
	sta.w SpriteVRAM
	phb
	pea.w $7E7E
	plb
	plb
	stx.w SpritesReserved
	tya
	cmp.w #$01C0
	bcs .1
	lda.w #$01A0
.1:									; adc #$001F, and #$FFE0, SpriteBlockTiles = A, ...
	clc
	adc.w #$001F
	and.w #$FFE0
	sta.w SpriteBlockTiles
	stz.w FrameCacheCount
	lsr a
	lsr a
	sep #$30
	tax
	lda.b #$00
.loop:								; loop: BlockRuns,x = A, BlockRunPrev,x = X - $08, if $08 - $00 >= 0 go...
	sta.w BlockRuns,x
	txa
	sec
	sbc.b #$08
	sta.w BlockRunPrev,x
	tax
	lda.b #$08
	cpx.b #$00
	bpl .loop
	lda.b #$FF
	sta.w BlockRunPrev
	rep #$30
	lda.w #$0002
	sta.w CacheUseMark
	lda.w #$0200
	sec
	sbc.w SpriteBlockTiles
	sep #$30
	tax
	sta.w TileRuns
	stz.w TileRuns,x
	stz.w TileRunPrev,x
	lda.b #$FF
	sta.w TileRunPrev
	rep #$30
	lda.w #$0080
	sta.w SpritesLeft
	lda.w #$2100
	sta.w OAMNext
	lda.w #$2300
	sta.w OAMHideEnd
	lda.w #$2520
	sta.w OAMLastEnd
	lda.w #$2320
	sta.w OAMShowBuf
	lda.w #$2100
	sta.w OAMDrawBuf
	jsr.w .t1
	plb
	jmp.w SpriteFrameEnd

.t1:								; subroutine: falls through
	ldx.w #$03D0
	lda.w #$FFFF
.loopx:								; loop: FrameCacheOf,x = A, X - 1, X - 1, ...
	sta.w FrameCacheOf,x
	dex
	dex
	bpl .loopx
	rts
