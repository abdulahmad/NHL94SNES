; a block of X bytes; A bit 14 = locked; Y = $7E or $7F for that bank only, else either. Returns the handle, 0
; if no room
NewHandle:							; called from SetHandleSize
	stx.b r3
	and.w #$4000
	sta.b r3+2
	ldx.w #$2000
.find:								; loop: ora Ram7E+2,x, if zero go to .slot, ...
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
.slot:								; NewHandleSlot = X, eor #$0001, NewHandleSkipBank = A, ...
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
.try7F:								; p0+2 = $007F, if zero go to .compact, ...
	lda.w #$007F
	sta.b p0+2
	cmp.w NewHandleSkipBank
	beq .compact
	ldy.w HeapStart7F
	jsr.w HeapAllocBlock
	cmp.w #$FFFF
	bne .found
.compact:							; call HeapCompact, p0+2 = $007E, if zero go to .retry7F, ...
	jsl.l HeapCompact
	lda.w #$007E
	sta.b p0+2
	cmp.w NewHandleSkipBank
	beq .retry7F
	ldy.w HeapStart7E
	jsr.w HeapAllocBlock
	cmp.w #$FFFF
	bne .found
.retry7F:							; p0+2 = $007F, if zero go to .fail, ...
	lda.w #$007F
	sta.b p0+2
	cmp.w NewHandleSkipBank
	beq .fail
	ldy.w HeapStart7F
	jsr.w HeapAllocBlock
	cmp.w #$FFFF
	bne .found
.fail:								; go to .exit
	lda.w #$0000
	bra .exit
.found:								; Ram7E,x = A, Ram7E+2,x = p0+2
	ldx.w NewHandleSlot
	sta.l Ram7E,x
	lda.b p0+2
	sta.l Ram7E+2,x
	txa
.exit:								; return
	rtl
