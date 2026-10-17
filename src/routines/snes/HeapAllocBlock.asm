; first free block of size $14 or more (flags $16) from header Y in the bank in $0E; splits it when 16 or more
; bytes are left.
HeapAllocBlock:
		;   returns the data address, $FFFF for none
	stz.b p0
.walk:
	lda.b [p0],y
	iny
	iny
	cmp.b r3
	bcs .fit
.next:
	iny
	iny
	lda.b [p0],y
	beq .none
	tay
	bra .walk
.none:
	lda.w #$FFFF
	rts
.fit:
	lda.b [p0],y
	bne .next
	dey
	dey
	lda.b [p0],y
	sty.b r0+2
	sec
	sbc.b r3
	beq .whole
	cmp.w #$0010
	bcc .whole
	sta.b r0
	lda.b r3
	sta.b [p0],y
	iny
	iny
	lda.b r3+2
	ora.w #$8000
	sta.b [p0],y
	iny
	iny
	lda.b [p0],y
	sta.b r1
	lda.b r0+2
	clc
	adc.b r3
	adc.w #$0008
	sta.b [p0],y
	tay
	lda.b r0
	sec
	sbc.w #$0008
	sta.b [p0],y
	iny
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
.ret:
	lda.b r0+2
	clc
	adc.w #$0008
	rts
.whole:
	iny
	iny
	lda.b r3+2
	ora.w #$8000
	sta.b [p0],y
	bra .ret
