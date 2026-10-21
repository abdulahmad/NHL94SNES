; Free the VRAM tiles of the frame at [p0]
;
; Takes: p0 = frame (or DrawFrameNum with FrameByNumber set). Gives back the VRAM tiles of the frame and
; drops its tile cache entry; nothing happens if the frame is not cached. Called by PrintShooterNames.
FreeFrameTiles:						; free the tiles of the frame at [p0]: save registers, data bank $7E
	phx
	phy
	phb
	pea.w (Ram7E>>16)*$0101
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
	pea.w (Ram7E>>16)*$0101
	plb
	plb
.1:									; find the cache entry of the frame
	ldy.w FrameCacheCount
	beq .2
	ldx.w FrameByNumber
	beq .3
	ldy.w DrawFrameNum
	lda.w FrameCacheOf,y
	bpl FreeCacheEntryA
.2:									; not cached: restore the registers and return
	plb
	ply
	plx
	rtl
.3:									; search the entries for the frame address and bank
	lda.b p0
	cmp.w FrameCacheAddr,x
	bne .1x
	lda.b p0+2
	cmp.w FrameCacheBank,x
	beq FreeCacheEntry_go
.1x:								; next entry
	inx
	inx
	dey
	bne .3
	bra .2
; FreeCacheEntry for the entry number in the high byte of A
;
; Takes: A = entry number in the high byte (as in FrameCacheOf).
FreeCacheEntryA:					; entry number to entry offset
	xba
	and.w #$00FF
	asl a
	tax
; Free tile cache entry X and its VRAM
;
; Takes: X = entry offset, Y = DrawFrameNum.
FreeCacheEntry:						; free the entry X; mark the frame as not cached
	sep #$20
	lda.b #$FF
	sta.w FrameCacheOf+1,y
	rep #$20
; FreeCacheEntry after the slot byte is cleared; FreeFrameTiles enters here
;
; Takes: X = entry offset.
FreeCacheEntry_go:					; r0 = the allocation of the entry; one entry less
	lda.w FrameCacheAlloc,x
	sta.b r0
	dec.w FrameCacheCount
	beq .1							; the entry was the last one: nothing to move
	stx.b r0+2
	lda.w FrameCacheCount
	asl a
	cmp.b r0+2
	beq .1
	tay								; move the last entry into the freed slot, field by field
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
	ldy.w FrameCacheNum,x			; point the moved frame at its new entry number
	txa
	lsr a
	sep #$20
	sta.w FrameCacheOf+1,y
	rep #$20
.1:									; give back the tiles: negative allocation = 16x16 block run
	ldx.b r0
	bmi .t2
	jmp.w .3

.t2:								; block run: a run with the $40 bit is a chain of 8-unit runs
	sep #$30
	lda.w BlockRuns,x
	and.b #$40
	bne .2
	lda.w BlockRuns,x				; single run: its length
	and.b #$3F
	sta.b r3+2
	clc
	adc.b r0
	tay
	and.b #$07
	beq .1x							; join with the run after it if that is free and in the same row of 8
	lda.w BlockRuns,y
	bmi .1x
	clc
	adc.b r3+2
	sta.b r3+2
.1x:								; join with the run before it if that is free and in the same row of 8
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

.t1:								; no run before to join: this run is free with the length found
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
.2:									; chain of runs: free each 8-unit run of the chain
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

.t1x:								; last run of the chain: free it, joining the run after it if free
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
.1xx:								; store the length of the freed run
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
.3:									; tile run: its length
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
.1xxx:								; join with the previous run if it is free
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

.t1xx:								; no free previous run: this run is free with its length
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
	pea.w (Ram7E>>16)*$0101
	plb
	plb
	stz.b r3
	lda.w SpriteBlockTiles
.loop:								; walk the block runs
	tax
	lda.w BlockRuns,x
	and.w #$00FF
	beq .t1xxx
	cmp.w #$0010
	bcs .1xxxx
	clc
	adc.b r3
	sta.b r3
.1xxxx:								; used runs are not counted; step to the next run
	and.w #$003F
	sta.b r8+2
	txa
	clc
	adc.b r8+2
	bra .loop

.t1xxx:								; end of the list: return the sum
	plb
	lda.b r3
	rtl
