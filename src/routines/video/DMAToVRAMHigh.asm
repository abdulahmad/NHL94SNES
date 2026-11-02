; DMA X bytes from [p0] to the high bytes of video memory at Y
DMAToVRAMHigh:						; called from LoadTitleLogo, TitleScreen
	lda.w IniDispShadow-1
	bpl .t1
	stx.w DAS1L
	lda.b p0
	sta.w A1T1L
	lda.w #$1900
	sta.w DMAP1
	sty.w VMADDL
	sty.b r3
	sep #$20
	lda.b p0+2
	sta.w A1B1
	lda.b #$02
	sta.w MDMAEN
	rep #$20
	txa
	lsr a
	adc.b r3
	tay
	rtl

.t1:								; IniDispShadow-1 >= 0: falls through
	txa
	ldx.b DMAQueueTail
.loop:								; loop: r3 = A, if carry clear go to .1, ...
	sta.b r3
	cmp.w #$1001
	bcc .1
	lda.w #$1000
.1:									; DMAQueue+4,x = A, DMAQueue+6,x = Y, DMAQueue+1,x = p0, ...
	sta.w DMAQueue+4,x
	pha
	tya
	sta.w DMAQueue+6,x
	pla
	clc
	adc.w DMAQueue+6,x
	tay
	lda.b p0
	sta.w DMAQueue+1,x
	clc
	adc.w #$1000
	sta.b p0
	sep #$20
	lda.b p0+2
	sta.w DMAQueue+3,x
	lda.b #$FA
	sta.w DMAQueue,x
	rep #$20
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	lda.b r3
	sec
	sbc.w #$1000
	beq .2
	bcs .loop
.2:									; DMAQueueTail = X, return
	stx.b DMAQueueTail
	rtl
