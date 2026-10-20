; free handle A unless it is a heap block
DisposePtrHandle:					; free handle A unless it is a heap block
	cmp.w #$2000
	bcc .exit
	cmp.w #$2100
	bcs .exit
	tax
	lda.l Ram7E+2,x
	cmp.w #$007E
	beq .exit
	cmp.w #$007F
	beq .exit
	lda.w #$0000
	sta.l Ram7E,x
	sta.l Ram7E+2,x
.exit:								; return
	rtl
