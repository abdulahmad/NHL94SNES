; Find the tile cache entry of the frame at [p0]; fall into LoadFrameTiles when it is not cached
;
; Takes: p0 = frame, X = 0 (offset into the cache tables), Y = FrameCacheCount, data bank $7E, with X, Y and
; the old data bank on the stack. Returns A = tile cache entry * 2, or $FFFF if there is no room, and restores
; the registers. Jumped to from DrawSpritePieces; LoadFrameTiles is its tail and also entered from
; GetFrameTiles.
FindCachedFrame:					; look for the frame in the tile cache
	lda.b p0						; compare the frame address and bank with entry X
	cmp.w FrameCacheAddr,x			;same address?
	bne .1
	lda.b p0+2						;bank
	cmp.w FrameCacheBank,x			;same bank?
	beq DrawSpritePieces_exit		; found: return its entry
.1:									; next entry, until all entries are checked
	inx
	inx
	dey
	bne FindCachedFrame
LoadFrameTiles:						;allocate VRAM for the frame at [p0], queue the DMA of its tiles and add a
									;tile cache entry
	ldy.w FrameCacheCount			; not cached: fail if all 128 entries are in use
	cpy.w #$0080					;full?
	beq .t3							;yes: fail
	lda.w #$0001					; DMA entry template in r1: type 1, source address word, source bank
	sta.b r1						;type 1
	lda.b p0+2
	sta.b r1+3						;source bank
	ldy.w #$0000					; r0 = piece count of the frame, 0 = nothing to load
	lda.b [p0],y					;piece count
	sta.b r0						;r0
	beq DrawSpritePieces_exit		;empty frame: done
	ldy.w #$000C					; PieceX = bytes of the first DMA, PieceY = bytes of the second (0 = none)
	lda.b [p0],y					;first DMA size
	sta.w PieceX
	iny
	iny
	lda.b [p0],y					;second DMA size
	sta.w PieceY
	iny								; r1+1 = address of the tile data (p0 + word at +$10)
	iny
	lda.b [p0],y					;tile data offset
	clc
	adc.b p0						;plus the frame
	sta.b r1+1						;tile source
	ldy.w #$0002					; negative piece count: 16x16 block frame, else 8x8 tile frame
	ldx.b r0						;piece count
	bmi .t2							;block frame
	jmp.w .6						;tile frame

.t2:								; block frame: r3 = block units needed (word at +2 rounded up, divided by
									; 4)
	lda.b [p0],y
	clc
	adc.w #$0003					;round up
	and.w #$FFFC
	lsr a							;/4
	lsr a
	sta.b r3						;r3 = units needed
	cmp.w #$0009					;more than 8?
	bcc .t1							;no: one run
	jmp.w .t5						;yes: a chain

.t1:								; up to 8 units: search the block runs for a free run that is long enough
	sep #$30
	lda.b #$00						;first run
.loop:								; next run: a length of 0 ends the list
	tax								;run
	lda.w BlockRuns,x				;its length
	beq .t3							;end of the list: fail
	cmp.b #$10						;used?
	bcs .1							;yes: skip
	cmp.b r3						;long enough?
	bcs .t4							;yes: take it
.1:									; not usable: skip to the next run
	and.b #$3F						;run length
	sta.b r8+2
	txa								;r8+2
	clc
	adc.b r8+2						;plus the length
	bra .loop						;next run

.t3:								; no room: restore the registers and return $FFFF
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl

.t4:								; found run X: split off the part that is not needed
	rep #$30
	stx.b r2+2						;run start
	sep #$30
	lda.w BlockRuns,x				;its length
	sec
	sbc.b r3						;minus the units needed
	beq .1x							;exact fit
	sta.b r3+2						;leftover
	txa
	clc
	adc.b r3						;leftover run start
	tay
	lda.b r3+2						;leftover length
	sta.w BlockRuns,y
	txa								;its previous run
	sta.w BlockRunPrev,y			;BlockRunPrev
	phy
	tya
	adc.b r3+2						;plus the leftover
	tay								;the run after
	pla
	sta.w BlockRunPrev,y			;points back to the leftover
.1x:								; mark the run used
	lda.b r3						;units
	ora.b #$80						;used flag
	sta.w BlockRuns,x				;run used
	rep #$30
	ldx.b DMAQueueTail				; queue the DMA of the first part of the tiles to the VRAM address worked
									; out below
	lda.b r1
	sta.w DMAQueue,x				;type and source
	lda.b r1+2
	sta.w DMAQueue+2,x				;source and bank
	lda.w PieceX					;size
	sta.w DMAQueue+4,x
	clc
	adc.b r1+1						;advance the source
	sta.b r1+1						;for the second DMA
	ldy.w DrawFrameNum				; record the frame in the cache: entry number by frame, address, bank,
									; frame number
	sep #$20
	lda.w FrameCacheCount			;entry number
	sta.w FrameCacheOf+1,y			;the frame's cache entry
	rep #$20
	lda.w FrameCacheCount
	asl a							;word index
	tay
	lda.w DrawFrameNum
	sta.w FrameCacheNum,y			;frame number
	lda.b p0
	sta.w FrameCacheAddr,y			;address
	lda.b p0+2
	sta.w FrameCacheBank,y			;bank
	inc.w FrameCacheCount			; count the entry; keep the allocation (run | $8000 for blocks)
	lda.b r2+2
	ora.w #$8000
	sta.w FrameCacheAlloc,y			;allocation (block)
	lda.b r2+2						; first VRAM tile of the run, and the VRAM address (tile * 16 +
									; SpriteVRAM) for the DMA
	and.w #$FFF8					;run in groups of 8
	asl a							;x2: 16x16 rows
	sta.b r3
	lda.b r2+2						;plus the
	and.w #$0007					;column in the group
	clc
	adc.b r3
	asl a							;x2
	sta.w FrameCacheTile,y			;first sprite tile
	asl a							;x16 bytes
	asl a
	asl a
	asl a
	adc.w SpriteVRAM				;plus the sprite VRAM base
	sta.b r2+2
	sta.w DMAQueue+6,x				;DMA destination
	txa								; next ring entry
	clc
	adc.w #$0008
	and.w #$03FF					;1K ring
	tax
	lda.b r1						; second DMA (the next tile row) only if the frame has one
	sta.w DMAQueue,x				;type and source
	lda.b r1+2
	sta.w DMAQueue+2,x				;source and bank
	lda.w PieceY
	sta.w DMAQueue+4,x				;size
	bne .t1x						;second part?
	stx.b DMAQueueTail				;no: close the queue
	plb
	ply
	plx
	lda.w FrameCacheCount			;entry
	dec a							;minus 1
	asl a							;x2
	rtl

.t1x:								; queue the second DMA, VRAM address + $100 words
	lda.b r2+2
	ora.w #$0100					;next tile row
	sta.w DMAQueue+6,x				;destination
	txa
	clc
	adc.w #$0008
	and.w #$03FF					;1K ring
	sta.b DMAQueueTail				;close the queue
	plb
	ply
	plx
	lda.w FrameCacheCount
	dec a							;minus 1
	asl a							;x2
	rtl

.t5:								; more than 8 units: needs several free runs of 8 in a row
	sep #$30
	lda.b #$00						;first run
.2:									; look for a free run of exactly 8 units
	tax								;run
	lda.w BlockRuns,x				;its length
	beq .4							;end of the list: fail
	cmp.b #$08						;a free run of 8?
	bne .3							;no: skip
	stx.b r2+2						;chain start
.loopx:								; follow the following free runs, adding up their length
	sta.b r8+2						;r8+2 = chain length
	txa
	clc
	adc.w BlockRuns,x
	tax								;next run
	lda.w BlockRuns,x				;its length
	beq .t1xx						;end: check
	cmp.b #$10						;used?
	bcs .t1xx						;yes: check
	clc
	adc.b r8+2						;add it
	bra .loopx						;keep chaining

.t1xx:								; enough room in the chain?
	lda.b r8+2						;chain length
	cmp.b r3						;enough?
	bcs .5							;yes: take it
	lda.w BlockRuns,x				;this run
.3:									; not enough: continue after this run
	and.b #$3F						;run length
	sta.b r8+2
	txa								;plus the length
	clc
	adc.b r8+2
	bra .2							;next run
.4:									; no room: restore the registers and return $FFFF
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl
.5:									; enough: mark the whole chain used, starting at the first run
	ldx.b r2+2						;chain start
	stz.b r2+3						;high byte 0
	lda.b r3
	sta.b r3+2						;units left
.loopxx:							; mark runs of 8 used until the rest fits in one run
	lda.b r3+2
	sec
	sbc.w BlockRuns,x				;exact: last run
	beq .1xx						;ends inside it
	bmi .t1xxx						;units left
	sta.b r3+2						;used flag + 8
	lda.b #$C8
	sta.w BlockRuns,x				;run used
	txa
	clc
	adc.b #$08						;next run of 8
	tax
	bra .loopxx						;continue

.t1xxx:								; the last run is only partly used: split it
	eor.b #$FF						;negate:
	inc a							;leftover
	sta.b r8+2						;r8+2
	txa
	clc
	adc.b r3+2						;leftover run start
	tay
	lda.b r8+2						;leftover length
	sta.w BlockRuns,y
	txa								;its previous run
	sta.w BlockRunPrev,y
	phy
	tya
	adc.b r8+2						;plus the leftover
	tay								;the run after
	pla
	sta.w BlockRunPrev,y			;points back to the leftover
.1xx:								; mark the last run used
	lda.b r3+2						;units in the last run
	ora.b #$80						;used flag
	sta.w BlockRuns,x				;run used
	rep #$30						; queue the DMA of the first part
	ldx.b DMAQueueTail
	lda.b r1						;type and source
	sta.w DMAQueue,x
	lda.b r1+2						;source and bank
	sta.w DMAQueue+2,x
	lda.w PieceX					;size
	sta.w DMAQueue+4,x
	clc
	adc.b r1+1						;advance the source
	sta.b r1+1						;for the second DMA
	ldy.w DrawFrameNum
	sep #$20
	lda.w FrameCacheCount			;entry number
	sta.w FrameCacheOf+1,y			;the frame's cache entry
	rep #$20
	lda.w FrameCacheCount			;word index
	asl a
	tay
	lda.w DrawFrameNum				;frame number
	sta.w FrameCacheNum,y
	lda.b p0						;address
	sta.w FrameCacheAddr,y
	lda.b p0+2						;bank
	sta.w FrameCacheBank,y
	inc.w FrameCacheCount			;count the entry
	lda.b r2+2
	ora.w #$8000					;block allocation
	sta.w FrameCacheAlloc,y
	lda.b r2+2
	and.w #$FFF8					;run in groups of 8
	asl a							;x2: 16x16 rows
	sta.b r3
	lda.b r2+2						;plus the
	and.w #$0007					;column in the group
	clc
	adc.b r3
	asl a							;x2
	sta.w FrameCacheTile,y			;first sprite tile
	asl a							;x16 bytes
	asl a
	asl a
	asl a
	adc.w SpriteVRAM				;plus the sprite VRAM base
	sta.b r2+2
	sta.w DMAQueue+6,x				;DMA destination
	txa								; next ring entry
	clc
	adc.w #$0008					;plus 8
	and.w #$03FF					;1K ring
	ldy.w PieceY					;second part?
	bne .t1xxxx						;yes
	sta.b DMAQueueTail				;close the queue
	plb
	ply
	plx
	lda.w FrameCacheCount			;entry
	dec a							;minus 1
	asl a							;x2
	rtl

.t1xxxx:							; queue the second DMA of the frame
	tax
	lda.b r1						;type and source
	sta.w DMAQueue,x
	lda.b r1+2						;source and bank
	sta.w DMAQueue+2,x
	tya
	sta.w DMAQueue+4,x				;size
	lda.w PieceX					;first part size
	lsr a							;/2 words
	and.w #$FF00					;whole rows
	ora.w #$0100					;plus the next row
	clc
	adc.b r2+2						;plus the start
	sta.w DMAQueue+6,x				;destination
	txa
	clc
	adc.w #$0008					;plus 8
	and.w #$03FF					;1K ring
	sta.b DMAQueueTail				;close the queue
	plb
	ply
	plx
	lda.w FrameCacheCount
	dec a							;minus 1
	asl a							;x2
	rtl
.6:									; 8x8 tile frame: r3 = number of tiles (word at +2)
	lda.b [p0],y
	sta.b r3						;r3 = tiles needed
	sep #$30
	lda.b #$00						;first run
.loopxxx:							; search the tile runs
	tax								;run
	lda.w TileRuns,x				;its length
	beq .t1xxxxx					;end of the list: fail
	bmi .1xxx						;used: skip
	cmp.b r3						;long enough?
	bcs .t2x						;yes: take it
.1xxx:								; used or too short: skip to the next run
	txa								;this run
	clc
	adc.w TileRuns,x				;plus the length
	and.b #$7F						;without the used bit
	bra .loopxxx					;next run

.t1xxxxx:							; no room: restore the registers and return $FFFF
	rep #$30
	plb
	ply
	plx
	lda.w #$FFFF
	rtl

.t2x:								; found run X: split off the part that is not needed
	rep #$30
	stx.b r2+2						;run start
	sep #$30
	lda.w TileRuns,x				;its length
	sec
	sbc.b r3						;minus the tiles needed
	beq .1xxxx						;exact fit
	sta.b r3+2						;leftover
	txa
	clc
	adc.b r3						;leftover run start
	tay
	lda.b r3+2						;leftover length
	sta.w TileRuns,y
	txa								;its previous run
	sta.w TileRunPrev,y				;TileRunPrev
	phy
	tya
	adc.b r3+2						;plus the leftover
	tay								;the run after
	pla
	sta.w TileRunPrev,y				;points back to the leftover
.1xxxx:								; mark the run used
	lda.b r3						;tiles
	ora.b #$80						;used flag
	sta.w TileRuns,x				;run used
	rep #$30
	ldx.b DMAQueueTail				; queue the DMA of the tiles, record the frame in the cache
	lda.b r1
	sta.w DMAQueue,x				;type and source
	lda.b r1+2
	sta.w DMAQueue+2,x				;source and bank
	lda.w PieceX
	sta.w DMAQueue+4,x				;size
	ldy.w DrawFrameNum
	sep #$20
	lda.w FrameCacheCount			;entry number
	sta.w FrameCacheOf+1,y			;the frame's cache entry
	rep #$20
	lda.w FrameCacheCount
	asl a							;word index
	tay
	lda.w DrawFrameNum
	sta.w FrameCacheNum,y			;frame number
	lda.b p0
	sta.w FrameCacheAddr,y			;address
	lda.b p0+2
	sta.w FrameCacheBank,y			;bank
	inc.w FrameCacheCount			;count the entry
	lda.b r2+2
	sta.w FrameCacheAlloc,y			;allocation (tile run)
	lda.b r2+2
	clc
	adc.w SpriteBlockTiles			;plus the tiles after the blocks
	sta.w FrameCacheTile,y			;first sprite tile
	asl a							;x16 bytes
	asl a
	asl a
	asl a
	adc.w SpriteVRAM
	sta.w DMAQueue+6,x				; VRAM address = (tile run + SpriteBlockTiles) * 16 + SpriteVRAM
	txa
	clc
	adc.w #$0008					;plus 8
	and.w #$03FF					;1K ring
	sta.b DMAQueueTail				;close the queue
	plb
	ply
	plx
	lda.w FrameCacheCount			;entry
	dec a							;minus 1
	asl a							;x2
	rtl
