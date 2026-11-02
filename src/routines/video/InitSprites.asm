; A: SpriteVRAM, X: SpritesReserved, Y: sizes the 16x16 block area of sprite VRAM;
InitSprites:						;A: SpriteVRAM, X: SpritesReserved, Y: sizes the 16x16 block area of
									;sprite VRAM;
									;empties the tile allocators, then ends an empty frame
	sta.w SpriteVRAM
	phb
	pea.w (Ram7E>>16)*$0101
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
.loop:								;loop: sprbigslot,x = A, sprbigslotprev,x = X - $08, if $08 - $00 >= 0
									;go...
	sta.w sprbigslot,x
	txa
	sec
	sbc.b #$08
	sta.w sprbigslotprev,x
	tax
	lda.b #$08
	cpx.b #$00
	bpl .loop
	lda.b #$FF
	sta.w sprbigslotprev
	rep #$30
	lda.w #$0002
	sta.w sprslotlife
	lda.w #$0200
	sec
	sbc.w SpriteBlockTiles
	sep #$30
	tax
	sta.w sprslot
	stz.w sprslot,x
	stz.w sprslotprev,x
	lda.b #$FF
	sta.w sprslotprev
	rep #$30
	lda.w #$0080
	sta.w SpritesLeft
	lda.w #$2100
	sta.w sprcount
	lda.w #$2300
	sta.w OAMHideEnd
	lda.w #$2520
	sta.w OAMLastEnd
	lda.w #$2320
	sta.w OAMShowBuf
	lda.w #$2100
	sta.w Satt
	jsr.w .t1
	plb
	jmp.w SpriteFrameEnd

.t1:								; subroutine: falls through
	ldx.w #$03D0
	lda.w #$FFFF
.loopx:								; loop: sprframetime,x = A, X - 1, X - 1, ...
	sta.w sprframetime,x
	dex
	dex
	bpl .loopx
	rts
