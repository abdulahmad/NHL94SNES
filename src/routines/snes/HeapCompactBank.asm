; join free blocks and move unlocked blocks down over them, fixing their handles
;
; Takes: p0+2 = bank, Y = first block header. Free blocks are joined, and a used unlocked block after a
; free block is moved down into it, with the free space moving up and the handle fixed. A block header is
; size, flags, next, previous (bit 15 flags used, bit 14 locked). Called by HeapCompact (jsr).
HeapCompactBank:					;join free blocks and move unlocked blocks down over them, fixing their
									;handles
	iny								; look at the flags of the block
	iny
	lda.b [p0],y
	beq .free
.next:								; used or locked: next block
	iny
	iny
	lda.b [p0],y
	beq .done
	tay
	bra HeapCompactBank
.done:								; end of the chain
	rts
.merge:								; the next block is free as well: join the two
	tyx
	dey
	dey
	lda.b [p0],y
	sta.b r1
	txy
	iny
	iny
	lda.b [p0],y
	sta.b r2
	tay
	beq .size
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b r0
	sta.b [p0],y
.size:								; store the joined size (both sizes + 8 for the header) and its next link
	ldy.b r0
	lda.b r1
	clc
	adc.w #$0008
	adc.b r1+2
	sta.b [p0],y
	iny
	iny
	iny
	iny
	lda.b r2
	sta.b [p0],y
	dey
	dey
.free:								; free block: r0 = its header, r1+2 = its size
	dey
	dey
	sty.b r0
	lda.b [p0],y
	sta.b r1+2
	iny
	iny
	iny
	iny
	lda.b [p0],y
	beq .done						; last block: done
	tay
	iny
	iny
	lda.b [p0],y
	beq .merge						; next block is free: merge it
	and.w #$4000
	bne .next						; locked: skip it
	dey
	dey
	sty.b r2+2
	lda.b [p0],y
	sta.b r1
	iny
	iny
	iny
	iny
	lda.b [p0],y
	sta.b r2
	tay
	lda.b r0
	clc
	adc.w #$0008
	adc.b r1
	cpy.w #$0000
	beq .move
	iny
	iny
	iny
	iny
	iny
	iny
	sta.b [p0],y
.move:								; move the used block down: write its header at the free place
	tax
	ldy.b r0
	lda.b r1
	sta.b [p0],y
	iny
	iny
	lda.w #$8000
	sta.b [p0],y
	iny
	iny
	txa
	sta.b [p0],y
	phx
	phy
	phb								; move the data with mvn (r1 bytes) in its bank
	lda.b r2+2
	clc
	adc.w #$0008
	tax
	lda.b r0
	clc
	adc.w #$0008
	tay
	lda.b p0+2
	cmp.w #Ram7E>>16
	beq .mvn7E
	lda.b r1
	dec a
	mvn Ram7F>>16,Ram7F>>16
	bra .moved
.mvn7E:								; bank $7E: block move inside the bank
	lda.b r1
	dec a
	mvn Ram7E>>16,Ram7E>>16
.moved:								; the free block now follows the moved one: write its header
	plb
	ply
	plx
	txy
	lda.b r1+2
	sta.b [p0],y
	iny
	iny
	lda.w #$0000
	sta.b [p0],y
	iny
	iny
	lda.b r2
	sta.b [p0],y
	iny
	iny
	lda.b r0
	sta.b [p0],y
	lda.b r2+2
	clc
	adc.w #$0008
	txy
	ldx.w #$00FC
.scan:								; search the handle table for the old data address
	cmp.l HandleTable,x
	beq .fix
	dex
	dex
	dex
	dex
	bpl .scan
	bra .again
.fix:								; point the handle at the new address
	lda.b r0
	clc
	adc.w #$0008
	sta.l HandleTable,x
.again:								; look at the block now following
	iny
	iny
	jmp.w .free
	rts								; not reached
