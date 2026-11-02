; Add a DMA of X bytes from [p0] to video memory at Y to the NMI transfer list
QueueVRAMDMA:						; called from DMAToVRAM, MapPartToVRAM, MapToVRAM
	txa
	ldx.b DMAQueueTail
.loop:								; loop: r3 = A, if carry clear go to .1, ...
	sta.b r3
	cmp.w #$1000
	bcc .1
	lda.w #$1000
.1:									; DMAQueue+4,x = A, lsr a, r3+2 = A, ...
	sta.w DMAQueue+4,x
	lsr a
	sta.b r3+2
	tya
	sta.w DMAQueue+6,x
	clc
	adc.b r3+2
	tay
	lda.b p0
	sta.w DMAQueue+1,x
	clc
	adc.b r3+2
	adc.b r3+2
	sta.b p0
	sep #$20
	lda.b p0+2
	sta.w DMAQueue+3,x
	lda.b #$01
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
