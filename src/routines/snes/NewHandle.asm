; a block of X bytes; A bit 14 = locked; Y = $7E or $7F for that bank only, else either. Returns the handle, 0
; if no room
NewHandle:
	stx.b r3
	and.w #$4000
	sta.b r3+2
	ldx.w #$2000
.find:
	lda.l Ram7E,x
	ora.l Ram7E+2,x
	beq .slot
	inx
	inx
	inx
	inx
	cpx.w #$2100
	bne .find
	lda.w #$0000
	bra .exit
.slot:
	stx.w NewHandleSlot
	tya
	eor.w #$0001
	sta.w NewHandleSkipBank
	lda.w #$007E
	sta.b p0+2
	cmp.w NewHandleSkipBank
	beq .try7F
	ldy.w HeapStart7E
	jsr.w HeapAllocBlock
	cmp.w #$FFFF
	bne .found
.try7F:
	lda.w #$007F
	sta.b p0+2
	cmp.w NewHandleSkipBank
	beq .compact
	ldy.w HeapStart7F
	jsr.w HeapAllocBlock
	cmp.w #$FFFF
	bne .found
.compact:
	jsl.l HeapCompact
	lda.w #$007E
	sta.b p0+2
	cmp.w NewHandleSkipBank
	beq .retry7F
	ldy.w HeapStart7E
	jsr.w HeapAllocBlock
	cmp.w #$FFFF
	bne .found
.retry7F:
	lda.w #$007F
	sta.b p0+2
	cmp.w NewHandleSkipBank
	beq .fail
	ldy.w HeapStart7F
	jsr.w HeapAllocBlock
	cmp.w #$FFFF
	bne .found
.fail:
	lda.w #$0000
	bra .exit
.found:
	ldx.w NewHandleSlot
	sta.l Ram7E,x
	lda.b p0+2
	sta.l Ram7E+2,x
	txa
.exit:
	rtl
