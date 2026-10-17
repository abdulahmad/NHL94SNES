; Find the tile cache entry of the frame at [p0]; fall into LoadFrameTiles when it is not cached
FindCachedFrame:
	lda.b p0
	cmp.w FrameCacheAddr,x
	bne .1
	lda.b p0+2
	cmp.w FrameCacheBank,x
	beq DrawSpritePieces_exit
.1:
	inx
	inx
	dey
	bne FindCachedFrame
LoadFrameTiles:						;allocate VRAM for the frame at [p0], queue the DMA of its tiles and add a
									;tile cache entry
	ldy.w FrameCacheCount
	cpy.w #$0080
	beq .t3
	lda.w #$0001
	sta.b r1
	lda.b p0+2
	sta.b r1+3
	ldy.w #$0000
	lda.b [p0],y
	sta.b r0
	beq DrawSpritePieces_exit
	ldy.w #$000C
	lda.b [p0],y
	sta.w PieceX
	iny
	iny
	lda.b [p0],y
	sta.w PieceY
	iny
	iny
	lda.b [p0],y
	clc
	adc.b p0
	sta.b r1+1
	ldy.w #$0002
	ldx.b r0
	bmi .t2
	jmp.w .6

.t2:
	lda.b [p0],y
	clc
	adc.w #$0003
	and.w #$FFFC
	lsr a
	lsr a
	sta.b r3
	cmp.w #$0009
	bcc .t1
	jmp.w .t5

.t1:
	sep #$30
	lda.b #$00
.loop:
	tax
	lda.w BlockRuns,x
	beq .t3
	cmp.b #$10
	bcs .1
	cmp.b r3
	bcs .t4
.1:
	and.b #$3F
	sta.b r8+2
	txa
	clc
	adc.b r8+2
	bra .loop

.t3:
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl

.t4:
	rep #$30
	stx.b r2+2
	sep #$30
	lda.w BlockRuns,x
	sec
	sbc.b r3
	beq .1x
	sta.b r3+2
	txa
	clc
	adc.b r3
	tay
	lda.b r3+2
	sta.w BlockRuns,y
	txa
	sta.w BlockRunPrev,y
	phy
	tya
	adc.b r3+2
	tay
	pla
	sta.w BlockRunPrev,y
.1x:
	lda.b r3
	ora.b #$80
	sta.w BlockRuns,x
	rep #$30
	ldx.b DMAQueueTail
	lda.b r1
	sta.w DMAQueue,x
	lda.b r1+2
	sta.w DMAQueue+2,x
	lda.w PieceX
	sta.w DMAQueue+4,x
	clc
	adc.b r1+1
	sta.b r1+1
	ldy.w DrawFrameNum
	sep #$20
	lda.w FrameCacheCount
	sta.w FrameCacheOf+1,y
	rep #$20
	lda.w FrameCacheCount
	asl a
	tay
	lda.w DrawFrameNum
	sta.w FrameCacheNum,y
	lda.b p0
	sta.w FrameCacheAddr,y
	lda.b p0+2
	sta.w FrameCacheBank,y
	inc.w FrameCacheCount
	lda.b r2+2
	ora.w #$8000
	sta.w FrameCacheAlloc,y
	lda.b r2+2
	and.w #$FFF8
	asl a
	sta.b r3
	lda.b r2+2
	and.w #$0007
	clc
	adc.b r3
	asl a
	sta.w FrameCacheTile,y
	asl a
	asl a
	asl a
	asl a
	adc.w SpriteVRAM
	sta.b r2+2
	sta.w DMAQueue+6,x
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	lda.b r1
	sta.w DMAQueue,x
	lda.b r1+2
	sta.w DMAQueue+2,x
	lda.w PieceY
	sta.w DMAQueue+4,x
	bne .t1x
	stx.b DMAQueueTail
	plb
	ply
	plx
	lda.w FrameCacheCount
	dec a
	asl a
	rtl

.t1x:
	lda.b r2+2
	ora.w #$0100
	sta.w DMAQueue+6,x
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	sta.b DMAQueueTail
	plb
	ply
	plx
	lda.w FrameCacheCount
	dec a
	asl a
	rtl

.t5:
	sep #$30
	lda.b #$00
.2:
	tax
	lda.w BlockRuns,x
	beq .4
	cmp.b #$08
	bne .3
	stx.b r2+2
.loopx:
	sta.b r8+2
	txa
	clc
	adc.w BlockRuns,x
	tax
	lda.w BlockRuns,x
	beq .t1xx
	cmp.b #$10
	bcs .t1xx
	clc
	adc.b r8+2
	bra .loopx

.t1xx:
	lda.b r8+2
	cmp.b r3
	bcs .5
	lda.w BlockRuns,x
.3:
	and.b #$3F
	sta.b r8+2
	txa
	clc
	adc.b r8+2
	bra .2
.4:
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl
.5:
	ldx.b r2+2
	stz.b r2+3
	lda.b r3
	sta.b r3+2
.loopxx:
	lda.b r3+2
	sec
	sbc.w BlockRuns,x
	beq .1xx
	bmi .t1xxx
	sta.b r3+2
	lda.b #$C8
	sta.w BlockRuns,x
	txa
	clc
	adc.b #$08
	tax
	bra .loopxx

.t1xxx:
	eor.b #$FF
	inc a
	sta.b r8+2
	txa
	clc
	adc.b r3+2
	tay
	lda.b r8+2
	sta.w BlockRuns,y
	txa
	sta.w BlockRunPrev,y
	phy
	tya
	adc.b r8+2
	tay
	pla
	sta.w BlockRunPrev,y
.1xx:
	lda.b r3+2
	ora.b #$80
	sta.w BlockRuns,x
	rep #$30
	ldx.b DMAQueueTail
	lda.b r1
	sta.w DMAQueue,x
	lda.b r1+2
	sta.w DMAQueue+2,x
	lda.w PieceX
	sta.w DMAQueue+4,x
	clc
	adc.b r1+1
	sta.b r1+1
	ldy.w DrawFrameNum
	sep #$20
	lda.w FrameCacheCount
	sta.w FrameCacheOf+1,y
	rep #$20
	lda.w FrameCacheCount
	asl a
	tay
	lda.w DrawFrameNum
	sta.w FrameCacheNum,y
	lda.b p0
	sta.w FrameCacheAddr,y
	lda.b p0+2
	sta.w FrameCacheBank,y
	inc.w FrameCacheCount
	lda.b r2+2
	ora.w #$8000
	sta.w FrameCacheAlloc,y
	lda.b r2+2
	and.w #$FFF8
	asl a
	sta.b r3
	lda.b r2+2
	and.w #$0007
	clc
	adc.b r3
	asl a
	sta.w FrameCacheTile,y
	asl a
	asl a
	asl a
	asl a
	adc.w SpriteVRAM
	sta.b r2+2
	sta.w DMAQueue+6,x
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	ldy.w PieceY
	bne .t1xxxx
	sta.b DMAQueueTail
	plb
	ply
	plx
	lda.w FrameCacheCount
	dec a
	asl a
	rtl

.t1xxxx:
	tax
	lda.b r1
	sta.w DMAQueue,x
	lda.b r1+2
	sta.w DMAQueue+2,x
	tya
	sta.w DMAQueue+4,x
	lda.w PieceX
	lsr a
	and.w #$FF00
	ora.w #$0100
	clc
	adc.b r2+2
	sta.w DMAQueue+6,x
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	sta.b DMAQueueTail
	plb
	ply
	plx
	lda.w FrameCacheCount
	dec a
	asl a
	rtl
.6:
	lda.b [p0],y
	sta.b r3
	sep #$30
	lda.b #$00
.loopxxx:
	tax
	lda.w TileRuns,x
	beq .t1xxxxx
	bmi .1xxx
	cmp.b r3
	bcs .t2x
.1xxx:
	txa
	clc
	adc.w TileRuns,x
	and.b #$7F
	bra .loopxxx

.t1xxxxx:
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl

.t2x:
	rep #$30
	stx.b r2+2
	sep #$30
	lda.w TileRuns,x
	sec
	sbc.b r3
	beq .1xxxx
	sta.b r3+2
	txa
	clc
	adc.b r3
	tay
	lda.b r3+2
	sta.w TileRuns,y
	txa
	sta.w TileRunPrev,y
	phy
	tya
	adc.b r3+2
	tay
	pla
	sta.w TileRunPrev,y
.1xxxx:
	lda.b r3
	ora.b #$80
	sta.w TileRuns,x
	rep #$30
	ldx.b DMAQueueTail
	lda.b r1
	sta.w DMAQueue,x
	lda.b r1+2
	sta.w DMAQueue+2,x
	lda.w PieceX
	sta.w DMAQueue+4,x
	ldy.w DrawFrameNum
	sep #$20
	lda.w FrameCacheCount
	sta.w FrameCacheOf+1,y
	rep #$20
	lda.w FrameCacheCount
	asl a
	tay
	lda.w DrawFrameNum
	sta.w FrameCacheNum,y
	lda.b p0
	sta.w FrameCacheAddr,y
	lda.b p0+2
	sta.w FrameCacheBank,y
	inc.w FrameCacheCount
	lda.b r2+2
	sta.w FrameCacheAlloc,y
	lda.b r2+2
	clc
	adc.w SpriteBlockTiles
	sta.w FrameCacheTile,y
	asl a
	asl a
	asl a
	asl a
	adc.w SpriteVRAM
	sta.w DMAQueue+6,x
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	sta.b DMAQueueTail
	plb
	ply
	plx
	lda.w FrameCacheCount
	dec a
	asl a
	rtl
