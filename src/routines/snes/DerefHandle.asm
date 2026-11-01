; address of handle A in A, bank in X; 0 and 0 for a bad handle
DerefHandle:						; entry point, no direct callers found
	cmp.w #HandleTable
	bcc .bad
	cmp.w #HandleTable+$100
	bcs .bad
	stx.b r3
	tax
	lda.l Ram7E,x
	ora.l Ram7E+2,x
	beq .bad
	lda.l Ram7E+2,x
	pha
	lda.l Ram7E,x
	plx
	bra .exit
.bad:								; falls through
	lda.w #$0000
	tax
.exit:								; return
	rtl
