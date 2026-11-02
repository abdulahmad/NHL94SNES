; Add the sizes of the free blocks of the heap chain at [p0], from block Y, to $14-$17
;
; Takes: p0+2 = bank, Y = first block header. Called by HeapFree (jsr).
HeapFreeBank:						; add the sizes of the free blocks of the chain
	iny								; free block (flags 0)?
	iny
	lda.b [p0],y
	bne .next
	dey
	dey
	lda.b [p0],y
	clc
	adc.b r3
	sta.b r3
	lda.w #$0000
	adc.b r3+2
	sta.b r3+2
	iny
	iny
.next:								; used block: go to the next one
	iny
	iny
	lda.b [p0],y
	beq .done
	tay
	bra HeapFreeBank
.done:								; end of the chain
	rts
