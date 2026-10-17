; join free blocks and move unlocked blocks down over them, fixing their handles
HeapCompactBank:					;join free blocks and move unlocked blocks down over them, fixing their
									;handles
	iny
	iny
	lda.b [p0],y
	beq .free
.next:
	iny
	iny
	lda.b [p0],y
	beq .done
	tay
	bra HeapCompactBank
.done:
	rts
.merge:
	tyx
	dey
	dey
	lda.b [p0],y
	sta.b r1
	txy
	iny
	iny
	lda.b [p0],y
	sta.b r2
	tay
	beq .size
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b r0
	sta.b [p0],y
.size:
	ldy.b r0
	lda.b r1
	clc
	adc.w #$0008
	adc.b r1+2
	sta.b [p0],y
	iny
	iny
	iny
	iny
	lda.b r2
	sta.b [p0],y
	dey
	dey
.free:
	dey
	dey
	sty.b r0
	lda.b [p0],y
	sta.b r1+2
	iny
	iny
	iny
	iny
	lda.b [p0],y
	beq .done
	tay
	iny
	iny
	lda.b [p0],y
	beq .merge
	and.w #$4000
	bne .next
	dey
	dey
	sty.b r2+2
	lda.b [p0],y
	sta.b r1
	iny
	iny
	iny
	iny
	lda.b [p0],y
	sta.b r2
	tay
	lda.b r0
	clc
	adc.w #$0008
	adc.b r1
	cpy.w #$0000
	beq .move
	iny
	iny
	iny
	iny
	iny
	iny
	sta.b [p0],y
.move:
	tax
	ldy.b r0
	lda.b r1
	sta.b [p0],y
	iny
	iny
	lda.w #$8000
	sta.b [p0],y
	iny
	iny
	txa
	sta.b [p0],y
	phx
	phy
	phb
	lda.b r2+2
	clc
	adc.w #$0008
	tax
	lda.b r0
	clc
	adc.w #$0008
	tay
	lda.b p0+2
	cmp.w #$007E
	beq .mvn7E
	lda.b r1
	dec a
	mvn $7F,$7F
	bra .moved
.mvn7E:
	lda.b r1
	dec a
	mvn $7E,$7E
.moved:
	plb
	ply
	plx
	txy
	lda.b r1+2
	sta.b [p0],y
	iny
	iny
	lda.w #$0000
	sta.b [p0],y
	iny
	iny
	lda.b r2
	sta.b [p0],y
	iny
	iny
	lda.b r0
	sta.b [p0],y
	lda.b r2+2
	clc
	adc.w #$0008
	txy
	ldx.w #$00FC
.scan:
	cmp.l HandleTable,x
	beq .fix
	dex
	dex
	dex
	dex
	bpl .scan
	bra .again
.fix:
	lda.b r0
	clc
	adc.w #$0008
	sta.l HandleTable,x
.again:
	iny
	iny
	jmp.w .free
	rts								; not reached
