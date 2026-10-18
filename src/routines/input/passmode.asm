; Pass mode: a pad direction sets the pass direction and passes; releasing the button passes too
passmode:
	lda.b d2
	bit.w #$8000
	bne dopass
	lda.b d0
	bit.w #$0008
	bne .t1
	and.w #$0007
	sta.w passdir
	ora.w #$0008
	sta.b d0
	bra dopass

.t1:
	rtl
