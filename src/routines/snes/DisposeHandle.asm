; free handle A and its block, joined with free neighbours
DisposeHandle:						; free handle A and its block, joined with free neighbours
	cmp.w #$2000
	bcc .exit
	cmp.w #$2100
	bcs .exit
	tax
	lda.l Ram7E+2,x
	tay
	lda.l Ram7E,x
	pha
	lda.w #$0000
	sta.l Ram7E,x
	sta.l Ram7E+2,x
	pla
	tyx
	ldy.w HeapStart7E
	cpx.w #$007E
	beq .heap
	ldy.w HeapStart7F
	cpx.w #$007F
	beq .heap
.exit:
	rtl
.heap:
	sec
	sbc.w #$0008
	sta.b r3
	stx.b p0+2
	stz.b p0
.find:
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
.found:
	iny
	iny
	iny
	iny
	lda.b [p0],y
	beq .prev
	tay
	tax
	iny
	iny
	lda.b [p0],y
	bne .prev
	txy
	lda.b [p0],y
	sta.b r0
	iny
	iny
	iny
	iny
	lda.b [p0],y
	sta.b r1
	tay
	lda.b r3
	cpy.w #$0000
	beq .size
	iny
	iny
	iny
	iny
	iny
	iny
	sta.b [p0],y
.size:
	tay
	lda.b [p0],y
	clc
	adc.b r0
	adc.w #$0008
	sta.b [p0],y
	iny
	iny
	iny
	iny
	lda.b r1
	sta.b [p0],y
.prev:
	ldy.b r3
	iny
	iny
	lda.w #$0000
	sta.b [p0],y
	iny
	iny
	iny
	iny
	lda.b [p0],y
	cmp.w #$FFFF
	beq .done
	tay
	tax
	iny
	iny
	lda.b [p0],y
	bne .done
	ldy.b r3
	lda.b [p0],y
	sta.b r0
	iny
	iny
	iny
	iny
	lda.b [p0],y
	sta.b r1
	tay
	txa
	cpy.w #$0000
	beq .size2
	iny
	iny
	iny
	iny
	iny
	iny
	sta.b [p0],y
.size2:
	tay
	lda.b [p0],y
	clc
	adc.b r0
	adc.w #$0008
	sta.b [p0],y
	iny
	iny
	iny
	iny
	lda.b r1
	sta.b [p0],y
.done:
	rtl
