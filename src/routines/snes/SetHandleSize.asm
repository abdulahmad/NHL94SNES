; resize handle A's block to X bytes: in place when it can, else in a new block
SetHandleSize:						;resize handle A's block to X bytes: in place when it can, else in a new
									;block
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
	cmp.w #Ram7E>>16
	beq .heap
	cmp.w #Ram7F>>16
	bne .bad
.heap:								; r2 = X, p0+2 = A, p0 = 0, ...
	stx.b r2
	sta.b p0+2
	stz.b p0
	lda.l Ram7E,x
	sec
	sbc.w #$0006
	tay
	lda.b [p0],y
	beq .bad
	dey
	dey
	tyx
	lda.b [p0],y
	sta.b r3+2
	iny
	iny
	iny
	iny
	sec
	sbc.b r3
	bcc .togrow
	cmp.w #$0009
	bcs .shrink
	jmp.w .exit
.togrow:							; go to .grow
	jmp.w .grow
.bad:								; go to .exit
	jmp.w .exit
.shrink:							; r0+2 = [p0],y, if zero go to .split, ...
	lda.b [p0],y
	sta.b r0+2
	beq .split
	tay
	iny
	iny
	lda.b [p0],y
	beq .mergenext
.split:								; txy, r0 = r3+2 - $0008 - r3, [p0],y = r3, ...
	txy
	lda.b r3+2
	sec
	sbc.w #$0008
	sbc.b r3
	sta.b r0
	lda.b r3
	sta.b [p0],y
	tya
	clc
	adc.b r3
	adc.w #$0008
	iny
	iny
	iny
	iny
	sta.b [p0],y
	sta.b r1
	tay
	lda.b r0
	sta.b [p0],y
	jmp.w .newfree
.mergenext:							; [p0],y = 0: Y - 1, Y - 1, r1+2 = [p0],y, ...
	dey
	dey
	lda.b [p0],y
	sta.b r1+2
	ldy.b r0+2
	iny
	iny
	iny
	iny
	lda.b [p0],y
	sta.b r0+2
	txy
	lda.b r3+2
	sec
	sbc.b r3
	sta.b r0
	lda.b r3
	sta.b [p0],y
	tya
	clc
	adc.b r3
	adc.w #$0008
	iny
	iny
	iny
	iny
	sta.b [p0],y
	sta.b r1
	tay
	lda.b r0
	clc
	adc.b r1+2
	sta.b [p0],y
.newfree:							; Y + 1, Y + 1, [p0],y = $0000, ...
	iny
	iny
	lda.w #$0000
	sta.b [p0],y
	iny
	iny
	lda.b r0+2
	sta.b [p0],y
	iny
	iny
	txa
	sta.b [p0],y
	ldy.b r0+2
	beq .done
.linkprev:							; Y + 1, Y + 1, Y + 1, ...
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b r1
	sta.b [p0],y
.done:								; go to .exit
	jmp.w .exit
.grow:								; r0+2 = [p0],y, if zero go to .move, ...
	lda.b [p0],y
	sta.b r0+2
	beq .move
	tay
	iny
	iny
	lda.b [p0],y
	bne .move
	dey
	dey
	lda.b [p0],y
	clc
	adc.w #$0008
	adc.b r3+2
	cmp.b r3
	beq .wholenext
	bcc .move
	lda.b r3
	sec
	sbc.b r3+2
	sta.b r0
	lda.b [p0],y
	sec
	sbc.b r0
	sta.b r0
	iny
	iny
	iny
	iny
	lda.b [p0],y
	sta.b r0+2
	txy
	lda.b r3
	sta.b [p0],y
	iny
	iny
	iny
	iny
	tya
	clc
	adc.b r3
	adc.w #$0004
	sta.b [p0],y
	sta.b r1
	tay
	lda.b r0
	sta.b [p0],y
	jmp.w .newfree
.wholenext:							; Y + 1, Y + 1, Y + 1, ...
	ldy.b r0+2
	iny
	iny
	iny
	iny
	lda.b [p0],y
	sta.b r0+2
	txy
	sty.b r1
	lda.b r3
	sta.b [p0],y
	iny
	iny
	iny
	iny
	lda.b r0+2
	sta.b [p0],y
	tay
	bne .tolinkprev
	jmp.w .exit
.tolinkprev:						; go to .linkprev
	jmp.w .linkprev
.move:								; txy, Y + 1, Y + 1, ...
	txy
	iny
	iny
	lda.b [p0],y
	and.w #$4000
	lda.b r3+2
	pha
	lda.b r2
	pha
	lda.w #$0000
	ldx.b r3
	phx
	ldy.w #$0000
	jsl.l NewHandle
	plx
	stx.b r3
	plx
	stx.b r2
	plx
	stx.b r3+2
	tax
	sta.b r2+2
	lda.l Ram7E,x
	tay
	sep #$20
	lda.b #$54
	sta.b p1
	lda.l Ram7E+2,x
	sta.b p1+1
	ldx.b r2
	lda.l Ram7E+2,x
	sta.b p1+2
	lda.b #$6B
	sta.b p1+3
	rep #$20
	lda.l Ram7E,x
	tax
	lda.b r3+2
	phb
	jsl.l p1						; mvn written to $10-$13 above, then rtl
	plb
	lda.b r2
	jsl.l DisposeHandle				; free handle A and its block, joined with free neighbours
	ldx.b r2+2
	lda.l Ram7E,x
	tay
	lda.l Ram7E+2,x
	ldx.b r2
	sta.l Ram7E+2,x
	tya
	sta.l Ram7E,x
	ldx.b r2+2
	lda.w #$0000
	sta.l Ram7E,x
	sta.l Ram7E+2,x
.exit:								; return
	rtl
