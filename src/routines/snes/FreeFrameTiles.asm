; Free the VRAM tiles of the frame at [p0]
FreeFrameTiles:
	phx
	phy
	phb
	pea.w $7E7E
	plb
	plb
	jmp.w .1

.freeframe:							;unused entry (no caller in the ROM): free the tiles of frame A of the
									;sprite set at [p1]
	phx
	phy
	sta.w DrawFrameNum
	asl a
	asl a
	tay
	lda.b [p1],y
	clc
	adc.b p1
	sta.b p0
	iny
	iny
	lda.b [p1],y
	adc.b p1+2
	sta.b p0+2
	phb
	pea.w $7E7E
	plb
	plb
.1:
	ldy.w FrameCacheCount
	beq .2
	ldx.w FrameByNumber
	beq .3
	ldy.w DrawFrameNum
	lda.w FrameCacheOf,y
	bpl FreeCacheEntryA
.2:
	plb
	ply
	plx
	rtl
.3:
	lda.b p0
	cmp.w FrameCacheAddr,x
	bne .1x
	lda.b p0+2
	cmp.w FrameCacheBank,x
	beq FreeCacheEntry_go
.1x:
	inx
	inx
	dey
	bne .3
	bra .2
; FreeCacheEntry for the entry number in the high byte of A
FreeCacheEntryA:
	xba
	and.w #$00FF
	asl a
	tax
; Free tile cache entry X and its VRAM
FreeCacheEntry:
	sep #$20
	lda.b #$FF
	sta.w FrameCacheOf+1,y
	rep #$20
; FreeCacheEntry after the slot byte is cleared; FreeFrameTiles enters here
FreeCacheEntry_go:
	lda.w FrameCacheAlloc,x
	sta.b r0
	dec.w FrameCacheCount
	beq .1
	stx.b r0+2
	lda.w FrameCacheCount
	asl a
	cmp.b r0+2
	beq .1
	tay
	lda.w FrameCacheAddr,y
	sta.w FrameCacheAddr,x
	lda.w FrameCacheBank,y
	sta.w FrameCacheBank,x
	lda.w FrameCacheNum,y
	sta.w FrameCacheNum,x
	lda.w FrameCacheAlloc,y
	sta.w FrameCacheAlloc,x
	lda.w FrameCacheTile,y
	sta.w FrameCacheTile,x
	lda.w FrameCacheUse,y
	sta.w FrameCacheUse,x
	ldy.w FrameCacheNum,x
	txa
	lsr a
	sep #$20
	sta.w FrameCacheOf+1,y
	rep #$20
.1:
	ldx.b r0
	bmi .t2
	jmp.w .3

.t2:
	sep #$30
	lda.w BlockRuns,x
	and.b #$40
	bne .2
	lda.w BlockRuns,x
	and.b #$3F
	sta.b r3+2
	clc
	adc.b r0
	tay
	and.b #$07
	beq .1x
	lda.w BlockRuns,y
	bmi .1x
	clc
	adc.b r3+2
	sta.b r3+2
.1x:
	txa
	and.b #$07
	beq .t1
	lda.w BlockRunPrev,x
	bmi .t1
	tay
	lda.w BlockRuns,y
	bmi .t1
	clc
	adc.b r3+2
	sta.w BlockRuns,y
	tya
	adc.w BlockRuns,y
	tax
	tya
	sta.w BlockRunPrev,x
	rep #$30
	plb
	ply
	plx
	rtl

.t1:
	lda.b r3+2
	sta.w BlockRuns,x
	txa
	clc
	adc.b r3+2
	tay
	txa
	sta.w BlockRunPrev,y
	rep #$30
	plb
	ply
	plx
	rtl
.2:
	lda.w BlockRuns,x
	and.b #$40
	beq .t1x
	lda.b #$08
	sta.w BlockRuns,x
	txa
	clc
	adc.b #$08
	tax
	bra .2

.t1x:
	lda.w BlockRuns,x
	and.b #$3F
	sta.b r3+2
	txa
	clc
	adc.b r3+2
	tay
	and.b #$07
	beq .1xx
	lda.w BlockRuns,y
	bmi .1xx
	clc
	adc.b r3+2
	sta.b r3+2
.1xx:
	lda.b r3+2
	sta.w BlockRuns,x
	txa
	clc
	adc.b r3+2
	tay
	txa
	sta.w BlockRunPrev,y
	rep #$30
	plb
	ply
	plx
	rtl
.3:
	sep #$30
	lda.w TileRuns,x
	and.b #$7F
	sta.b r3+2
	clc
	adc.b r0
	tay
	lda.w TileRuns,y
	bmi .1xxx
	clc
	adc.b r3+2
	sta.b r3+2
.1xxx:
	lda.w TileRunPrev,x
	bmi .t1xx
	tay
	lda.w TileRuns,y
	bmi .t1xx
	clc
	adc.b r3+2
	sta.w TileRuns,y
	tya
	adc.w TileRuns,y
	tax
	tya
	sta.w TileRunPrev,x
	rep #$30
	plb
	ply
	plx
	rtl

.t1xx:
	lda.b r3+2
	sta.w TileRuns,x
	txa
	clc
	adc.b r3+2
	tay
	txa
	sta.w TileRunPrev,y
	rep #$30
	plb
	ply
	plx
	rtl

.countfree:							;unused entry (no caller in the ROM): A = the sum of the free run lengths
									;in BlockRuns, walking the runs from index SpriteBlockTiles
	phb
	pea.w $7E7E
	plb
	plb
	stz.b r3
	lda.w SpriteBlockTiles
.loop:
	tax
	lda.w BlockRuns,x
	and.w #$00FF
	beq .t1xxx
	cmp.w #$0010
	bcs .1xxxx
	clc
	adc.b r3
	sta.b r3
.1xxxx:
	and.w #$003F
	sta.b r8+2
	txa
	clc
	adc.b r8+2
	bra .loop

.t1xxx:
	plb
	lda.b r3
	rtl
