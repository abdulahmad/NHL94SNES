; set the locked bit of handle A's block
LockHandle:							; set the locked bit of handle A's block
	pha
	cmp.w #$2000
	bcc .exit
	cmp.w #$2100
	bcs .exit
	tax
	lda.l Ram7E+2,x
	tay
	lda.l Ram7E,x
	tyx
	ldy.w HeapStart7E
	cpx.w #Ram7E>>16
	beq .heap
	ldy.w HeapStart7F
	cpx.w #Ram7F>>16
	bne .exit
.heap:								; sbc #$0008, r3 = A, p0+2 = X, ...
	sec
	sbc.w #$0008
	sta.b r3
	stx.b p0+2
	stz.b p0
.find:								; loop: if zero go to .found, ...
	cpy.b r3
	beq .found
	iny
	iny
	iny
	iny
	lda.b [p0],y
	beq .exit
	tay
	bra .find
.found:								; Y + 1, Y + 1, if [p0],y = 0 go to .exit, ...
	iny
	iny
	lda.b [p0],y
	beq .exit
	ora.w #$4000
	sta.b [p0],y
.exit:								; return
	pla
	rtl
