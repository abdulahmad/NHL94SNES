; Copy part of map [p0] into the screen map at column X, row Y, adding A to each entry
MapPartToVRAMOffset:				; called from ReplayMode
	sta.b r3+2
	lda.w IniDispShadow-1
	bmi .t1
.1:									; go to MapPartToVRAMOffset
	jmp.w MapPartToVRAMOffset

.t1:								; IniDispShadow-1 negative: if carry clear go to .2
	cpx.w #$0020
	bcc .2
.1x:								; MapVRAM = MapVRAM + $0400
	txa
	and.w #$001F
	tax
	lda.w MapVRAM
	clc
	adc.w #$0400
	sta.w MapVRAM
.2:									; r5 = X, r5+2 = Y, call Mul16U, ...
	stx.b r5
	sty.b r5+2
	ldy.w #$0000
	lda.b [p0],y
	asl a
	pha
	ldx.b r7+2
	jsl.l Mul16U
	asl.b r7
	lda.b p0
	clc
	adc.w #$0006
	adc.b r7
	adc.b r2
	sta.b p0
	pla
	sta.b r7
	lda.b r5+2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w MapVRAM
	ora.b r5
	tax
.3:									; loop: VMADDL = X, if carry set go to .5, ...
	stx.w VMADDL
	phx								; 1,s = x, the VRAM address of the row
	lda.b r4
	clc
	adc.b r5
	cmp.w #$0021
	bcs .5
	ldx.b r4
	ldy.w #$0000
.loop:								; loop: ora r3, VMDATAL = A, Y + 1, ...
	lda.b [p0],y
	clc
	adc.b r3+2
	ora.b r3
	sta.w VMDATAL
	iny
	iny
	dex
	bne .loop
.4:									; p0 = p0 + r7, increment r5+2, if r5+2 != $0020 go to .2x
	lda.b p0
	clc
	adc.b r7
	sta.b p0
	pla
	clc
	adc.w #$0020
	tax
	inc.b r5+2
	lda.b r5+2
	cmp.w #$0020
	bne .2x
.1xx:								; falls through
	txa
	clc
	adc.w MapScreenStep
	tax
.2x:								; decrement r4+2, if r4+2 not yet 0 go to .3, ...
	dec.b r4+2
	bne .3
	rtl
.5:									; r6 = $0020 - r5
	lda.w #$0020
	sbc.b r5
	sta.b r6
	tax
	ldy.w #$0000
.loopx:								; loop: ora r3, VMDATAL = A, Y + 1, ...
	lda.b [p0],y
	clc
	adc.b r3+2
	ora.b r3
	sta.w VMDATAL
	iny
	iny
	dex
	bne .loopx
	lda.b 1,s
	clc
	adc.w #$0400
	and.w #$FFE0
	sta.w VMADDL
	lda.b r4
	sec
	sbc.b r6
	tax
.loop2:								; loop: ora r3, VMDATAL = A, Y + 1, ...
	lda.b [p0],y
	clc
	adc.b r3+2
	ora.b r3
	sta.w VMDATAL
	iny
	iny
	dex
	bne .loop2
	jmp.w .4
