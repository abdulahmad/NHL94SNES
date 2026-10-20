; Copy byte map [p0] (width, height) into the mode 7 map at column X, row Y
Mode7MapToVRAM:						; called from LoadTitleLogo, TitleScreen
	stx.b r5
	sty.b r5+2
	ldy.w #$0000
	lda.b [p0],y
	sta.b r4
	iny
	iny
	lda.b [p0],y
	sta.b r4+2
	lda.b p0
	clc
	adc.w #$0006
	tax
	lda.b r5+2
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w MapVRAM
	ora.b r5
	tay
	lda.w IniDispShadow-1
	bmi .1
	jmp.w .3
.1:									; IniDispShadow-1 negative: A1B1 = p0+2, DMAP1 = 0, VMAIN = 0, ...
	sep #$20
	lda.b p0+2
	sta.w A1B1
	stz.w DMAP1
	stz.w VMAIN
	lda.b #$18
	sta.w BBAD1
	rep #$20
.loop:								; loop: DAS1L = r4, A1T1L = X, VMADDL = Y, ...
	lda.b r4
	sta.w DAS1L
	stx.w A1T1L
	sty.w VMADDL
	sep #$20
	lda.b #$02
	sta.w MDMAEN
	rep #$20
	txa
	clc
	adc.b r4
	tax
	tya
	clc
	adc.w #$0080
	tay
	dec.b r4+2
	bne .loop
	sep #$20
	lda.b #$80
	sta.w VMAIN
	rep #$20
	rtl
.3:									; p0 = X
	stx.b p0
	ldx.b DMAQueueTail
.loopx:								; loop: DMAQueue+1,x = p0, p0 = p0 + r4, DMAQueue+4,x = r4, ...
	lda.b p0
	sta.w DMAQueue+1,x
	clc
	adc.b r4
	sta.b p0
	lda.b r4
	sta.w DMAQueue+4,x
	tya
	sta.w DMAQueue+6,x
	clc
	adc.w #$0080
	tay
	sep #$20
	lda.b p0+2
	sta.w DMAQueue+3,x
	lda.b #$FB
	sta.w DMAQueue,x
	rep #$20
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	dec.b r4+2
	bne .loopx
	stx.b DMAQueueTail
	rtl

.t1:								; r7+2 = A, r5 = X, call Mul16U, ...
	sta.b r7+2
	stx.b r5
	tya
	asl a
	ldx.b r7
	jsl.l Mul16U
	lda.b r5
	asl a
	clc
	adc.b r2
	adc.b p1
	sta.b p1
	ldx.b r6+2
	ldy.w #$0000
.loopxx:							; loop: if [p0] & $00FF = 0 go to .2, ...
	lda.b [p0]
	and.w #$00FF
	beq .2
	clc
	adc.b r7+2
	sta.b [p1],y
	iny
	iny
	inc.b p0
	dex
	bne .loopxx
.1x:								; return
	rtl
.2:									; loop: X - 1, if X counted below 0 go to .1x, ...
	dex
	bmi .1x
	lda.w #$0020
	clc
	adc.b r7+2
	sta.b [p1],y
	iny
	iny
	inc.b p0
	bra .2
