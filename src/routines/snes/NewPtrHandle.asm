; a handle for fixed memory at A in bank X; returns the handle, 0 if none is free
NewPtrHandle:						; entry point, no direct callers found
	stx.b r3+2
	sta.b r3
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
.slot:								; Ram7E,x = r3, Ram7E+2,x = r3+2
	lda.b r3
	sta.l Ram7E,x
	lda.b r3+2
	sta.l Ram7E+2,x
	txa
.exit:								; return
	rtl
