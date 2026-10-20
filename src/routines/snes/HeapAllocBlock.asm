; first free block of size $14 or more (flags $16) from header Y in the bank in $0E; splits it when 16 or more
; bytes are left.
;
; Takes: Y = first block header, p0+2 = bank, r3 = bytes wanted, r3+2 = flags to store (the used bit $8000
; is added). A free block that is too big is split. Returns A = the data address ($FFFF if no block fits).
; Called by NewHandle.
HeapAllocBlock:						; find a free block of at least r3 bytes
		;   returns the data address, $FFFF for none
	stz.b p0						; p0 = bank base
.walk:								; walk the block chain: the size is the first word of a header
	lda.b [p0],y
	iny
	iny
	cmp.b r3
	bcs .fit
.next:								; too small or used: go to the next block
	iny
	iny
	lda.b [p0],y
	beq .none
	tay
	bra .walk
.none:								; end of the chain: nothing fits
	lda.w #$FFFF
	rts
.fit:								; big enough: free blocks have flags 0
	lda.b [p0],y
	bne .next
	dey								; free: back to the size, r0+2 = this header
	dey
	lda.b [p0],y
	sty.b r0+2
	sec
	sbc.b r3
	beq .whole						; an exact fit, or less than 16 bytes would be left: use the whole block
	cmp.w #$0010
	bcc .whole
	sta.b r0						; split: the block gets r3 bytes and the flags
	lda.b r3
	sta.b [p0],y
	iny								; flags word, the old next pointer is saved in r1
	iny
	lda.b r3+2
	ora.w #$8000
	sta.b [p0],y
	iny
	iny
	lda.b [p0],y
	sta.b r1
	lda.b r0+2						; new header after the data (this header + 8 + r3), with the remaining
									; size minus 8
	clc
	adc.b r3
	adc.w #$0008
	sta.b [p0],y
	tay
	lda.b r0
	sec
	sbc.w #$0008
	sta.b [p0],y
	iny								; new header: flags 0 (free), next = the old next, previous = this block
	iny
	lda.w #$0000
	sta.b [p0],y
	iny
	iny
	lda.b r1
	sta.b [p0],y
	iny
	iny
	lda.b r0+2
	sta.b [p0],y
.ret:								; data address = header + 8
	lda.b r0+2
	clc
	adc.w #$0008
	rts
.whole:								; use the whole block: store the flags
	iny
	iny
	lda.b r3+2
	ora.w #$8000
	sta.b [p0],y
	bra .ret
