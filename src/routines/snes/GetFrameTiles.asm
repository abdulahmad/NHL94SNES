; A = the first VRAM tile of the frame at [p0], loaded now if needed; negative if there is no room
;
; Takes: p0 = frame, DrawFrameNum, data bank $7E. The use mark of the entry is refreshed.
; Called by DrawSprite.
GetFrameTiles:						; look the frame up in the tile cache, load it if it is not there
	ldy.w FrameCacheCount
	beq .2							; cache empty: load it
	ldx.w FrameByNumber
	beq .5							; not by frame number: search the entries by address
	ldx.w DrawFrameNum
	lda.w FrameCacheOf,x
	bpl .3							; frame number known: entry from FrameCacheOf, load if none
.2:									; load the frame: keep r3 and the registers, return into .t2
	lda.b r3
	pha
	sep #$20
	lda.b #$80
	pha
	rep #$20
	lda.w #.t2-1
	pha
	phx
	phy
	phb
	jmp.w LoadFrameTiles

.t2:								; back from LoadFrameTiles
	cmp.w #$0000
	bpl .t1
.1:									; no room: restore r3, flag the failure
	pla
	sta.b r3
	lda.w #$FFFF
	sta.w FrameTilesFail
	rts

.t1:								; loaded: A = entry * 2
	tax
	pla
	sta.b r3
	bra .4
.3:									; cached: entry number from the high byte
	xba
	and.w #$00FF
	asl a
	tax
.4:									; mark the entry as used this frame and return its first tile
	lda.w CacheUseMark
	sta.w FrameCacheUse,x
	lda.w FrameCacheTile,x
	rts
.5:									; search the cache for the frame address and bank
	lda.b p0
	cmp.w FrameCacheAddr,x
	bne .1x
	lda.b p0+2
	cmp.w FrameCacheBank,x
	beq .4
.1x:								; next entry
	inx
	inx
	dey
	bne .5
	bra .2

.drawat:							; unused entry (no caller in the ROM): DrawSprite with the frame at [p0]
	sta.b r3
	stx.b r5
	sty.b r5+2
	phb
	pea.w $7E7E
	plb
	plb
	jmp.w DrawSprite_draw
