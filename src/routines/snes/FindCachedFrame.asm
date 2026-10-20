; Find the tile cache entry of the frame at [p0]; fall into LoadFrameTiles when it is not cached
;
; Takes: p0 = frame, X = 0 (offset into the cache tables), Y = FrameCacheCount, data bank $7E, with X, Y and
; the old data bank on the stack. Returns A = tile cache entry * 2, or $FFFF if there is no room, and restores
; the registers. Jumped to from DrawSpritePieces; LoadFrameTiles is its tail and also entered from
; GetFrameTiles.
FindCachedFrame:					; look for the frame in the tile cache
	lda.b p0						; compare the frame address and bank with entry X
	cmp.w FrameCacheAddr,x
	bne .1
	lda.b p0+2
	cmp.w FrameCacheBank,x
	beq DrawSpritePieces_exit		; found: return its entry
.1:									; next entry, until all entries are checked
	inx
	inx
	dey
	bne FindCachedFrame
LoadFrameTiles:						;allocate VRAM for the frame at [p0], queue the DMA of its tiles and add a
									;tile cache entry
	ldy.w FrameCacheCount			; not cached: fail if all 128 entries are in use
	cpy.w #$0080
	beq .t3
	lda.w #$0001					; DMA entry template in r1: type 1, source address word, source bank
	sta.b r1
	lda.b p0+2
	sta.b r1+3
	ldy.w #$0000					; r0 = piece count of the frame, 0 = nothing to load
	lda.b [p0],y
	sta.b r0
	beq DrawSpritePieces_exit
	ldy.w #$000C					; PieceX = bytes of the first DMA, PieceY = bytes of the second (0 = none)
	lda.b [p0],y
	sta.w PieceX
	iny
	iny
	lda.b [p0],y
	sta.w PieceY
	iny								; r1+1 = address of the tile data (p0 + word at +$10)
	iny
	lda.b [p0],y
	clc
	adc.b p0
	sta.b r1+1
	ldy.w #$0002					; negative piece count: 16x16 block frame, else 8x8 tile frame
	ldx.b r0
	bmi .t2
	jmp.w .6

.t2:								; block frame: r3 = block units needed (word at +2 rounded up, divided by
									; 4)
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

.t1:								; up to 8 units: search the block runs for a free run that is long enough
	sep #$30
	lda.b #$00
.loop:								; next run: a length of 0 ends the list
	tax
	lda.w BlockRuns,x
	beq .t3
	cmp.b #$10
	bcs .1
	cmp.b r3
	bcs .t4
.1:									; not usable: skip to the next run
	and.b #$3F
	sta.b r8+2
	txa
	clc
	adc.b r8+2
	bra .loop

.t3:								; no room: restore the registers and return $FFFF
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl

.t4:								; found run X: split off the part that is not needed
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
.1x:								; mark the run used
	lda.b r3
	ora.b #$80
	sta.w BlockRuns,x
	rep #$30
	ldx.b DMAQueueTail				; queue the DMA of the first part of the tiles to the VRAM address worked
									; out below
	lda.b r1
	sta.w DMAQueue,x
	lda.b r1+2
	sta.w DMAQueue+2,x
	lda.w PieceX
	sta.w DMAQueue+4,x
	clc
	adc.b r1+1
	sta.b r1+1
	ldy.w DrawFrameNum				; record the frame in the cache: entry number by frame, address, bank,
									; frame number
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
	inc.w FrameCacheCount			; count the entry; keep the allocation (run | $8000 for blocks)
	lda.b r2+2
	ora.w #$8000
	sta.w FrameCacheAlloc,y
	lda.b r2+2						; first VRAM tile of the run, and the VRAM address (tile * 16 +
									; SpriteVRAM) for the DMA
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
	txa								; next ring entry
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	lda.b r1						; second DMA (the next tile row) only if the frame has one
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

.t1x:								; queue the second DMA, VRAM address + $100 words
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

.t5:								; more than 8 units: needs several free runs of 8 in a row
	sep #$30
	lda.b #$00
.2:									; look for a free run of exactly 8 units
	tax
	lda.w BlockRuns,x
	beq .4
	cmp.b #$08
	bne .3
	stx.b r2+2
.loopx:								; follow the following free runs, adding up their length
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

.t1xx:								; enough room in the chain?
	lda.b r8+2
	cmp.b r3
	bcs .5
	lda.w BlockRuns,x
.3:									; not enough: continue after this run
	and.b #$3F
	sta.b r8+2
	txa
	clc
	adc.b r8+2
	bra .2
.4:									; no room: restore the registers and return $FFFF
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl
.5:									; enough: mark the whole chain used, starting at the first run
	ldx.b r2+2
	stz.b r2+3
	lda.b r3
	sta.b r3+2
.loopxx:							; mark runs of 8 used until the rest fits in one run
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

.t1xxx:								; the last run is only partly used: split it
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
.1xx:								; mark the last run used
	lda.b r3+2
	ora.b #$80
	sta.w BlockRuns,x
	rep #$30						; queue the DMA of the first part
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
	txa								; next ring entry
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

.t1xxxx:							; queue the second DMA of the frame
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
.6:									; 8x8 tile frame: r3 = number of tiles (word at +2)
	lda.b [p0],y
	sta.b r3
	sep #$30
	lda.b #$00
.loopxxx:							; search the tile runs
	tax
	lda.w TileRuns,x
	beq .t1xxxxx
	bmi .1xxx
	cmp.b r3
	bcs .t2x
.1xxx:								; used or too short: skip to the next run
	txa
	clc
	adc.w TileRuns,x
	and.b #$7F
	bra .loopxxx

.t1xxxxx:							; no room: restore the registers and return $FFFF
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl

.t2x:								; found run X: split off the part that is not needed
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
.1xxxx:								; mark the run used
	lda.b r3
	ora.b #$80
	sta.w TileRuns,x
	rep #$30
	ldx.b DMAQueueTail				; queue the DMA of the tiles, record the frame in the cache
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
	sta.w DMAQueue+6,x				; VRAM address = (tile run + SpriteBlockTiles) * 16 + SpriteVRAM
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
