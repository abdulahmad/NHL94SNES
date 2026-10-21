; free handle A unless it is a heap block
DisposePtrHandle:					; free handle A unless it is a heap block
	cmp.w #$2000
	bcc .exit
	cmp.w #$2100
	bcs .exit
	tax
	lda.l Ram7E+2,x
	cmp.w #Ram7E>>16
	beq .exit
	cmp.w #Ram7F>>16
	beq .exit
	lda.w #$0000
	sta.l Ram7E,x
	sta.l Ram7E+2,x
.exit:								; return
	rtl
