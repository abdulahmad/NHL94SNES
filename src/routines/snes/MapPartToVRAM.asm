; Copy part of map [p0] into the screen map in video memory at column X, row Y
MapPartToVRAM:						; called from PlayoffScreen, SendBigText, StatsReport
	cpx.w #$0020
	bcc .1
	txa
	and.w #$001F
	tax
	lda.w MapVRAM
	clc
	adc.w #$0400
	sta.w MapVRAM
.1:									; r5 = X, r5+2 = Y, call Mul16U, ...
	stx.b r5
	sty.b r5+2
	ldy.w #$0000
	lda.b [p0],y
	asl a
	pha
	ldx.b r7+2
	jsl.l Mul16U
	asl.b r7
	lda.w IniDispShadow-1
	bmi .t1
	jmp.w .5

.t1:								; IniDispShadow-1 negative: r7 = pulled value, ora r5, A1B1 = p0+2, ...
	lda.b p0
	clc
	adc.w #$0006
	adc.b r7
	adc.b r2
	tax
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
	tay
	sep #$20
	lda.b p0+2
	sta.w A1B1
	lda.b #$01
	sta.w DMAP1
	lda.b #$18
	sta.w BBAD1
	rep #$20
.2:									; loop: if carry set go to .4, ...
	lda.b r4
	clc
	adc.b r5
	cmp.w #$0021
	bcs .4
	lda.b r4
	asl a
	sta.w DAS1L
	stx.w A1T1L
	sty.w VMADDL
.3:									; MDMAEN = $02, increment r5+2, if r5+2 != $0020 go to .1x, ...
	sep #$20
	lda.b #$02
	sta.w MDMAEN
	rep #$20
	txa
	clc
	adc.b r7
	tax
	tya
	clc
	adc.w #$0020
	tay
	inc.b r5+2
	lda.b r5+2
	cmp.w #$0020
	bne .1x
	tya
	clc
	adc.w MapScreenStep
	tay
.1x:								; decrement r4+2, if r4+2 not yet 0 go to .2, ...
	dec.b r4+2
	bne .2
	rtl
.4:									; r6 = $0020 - r5 * 2, DAS1L = $0020 - r5 * 2, A1T1L = X, ...
	lda.w #$0020
	sbc.b r5
	asl a
	sta.b r6
	sta.w DAS1L
	stx.w A1T1L
	sty.w VMADDL
	sep #$20
	lda.b #$02
	sta.w MDMAEN
	rep #$20
	lda.b r4
	asl a
	sec
	sbc.b r6
	sta.w DAS1L
	txa
	clc
	adc.b r6
	sta.w A1T1L
	tya
	adc.w #$0400
	and.w #$FFE0
	sta.w VMADDL
	jmp.w .3
.5:									; p0 = p0 + $0006 + r7 + r2, r7 = pulled value, ora r5, ...
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
	tay
.1xx:								; loop: if carry set go to .3x, ...
	lda.b r4
	clc
	adc.b r5
	cmp.w #$0021
	bcs .3x
	lda.b r4
	asl a
	tax
	phy
	lda.b p0
	pha
	jsl.l QueueVRAMDMA
	pla
	sta.b p0
	ply
.2x:								; p0 = p0 + r7, increment r5+2, if r5+2 != $0020 go to .1xxx, ...
	lda.b p0
	clc
	adc.b r7
	sta.b p0
	tya
	clc
	adc.w #$0020
	tay
	inc.b r5+2
	lda.b r5+2
	cmp.w #$0020
	bne .1xxx
	tya
	clc
	adc.w MapScreenStep
	tay
.1xxx:								; decrement r4+2, if r4+2 not yet 0 go to .1xx, ...
	dec.b r4+2
	bne .1xx
	rtl
.3x:								; r6 = $0020 - r5 * 2, call QueueVRAMDMA, call QueueVRAMDMA, ...
	lda.w #$0020
	sbc.b r5
	asl a
	sta.b r6
	tax
	lda.b p0
	pha
	phy
	jsl.l QueueVRAMDMA
	ply
	lda.b r4
	asl a
	sec
	sbc.b r6
	tax
	phy
	tya
	adc.w #$0400
	and.w #$FFE0
	tay
	jsl.l QueueVRAMDMA
	ply
	pla
	sta.b p0
	jmp.w .2x
