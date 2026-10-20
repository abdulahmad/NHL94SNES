; NMI after the hook: the IRQ timers, INIDISP from IniDispShadow, the BG scroll registers and the rest of the
; frame registers
NMI_HookReturn:						; called from NMI_Fast
	rep #$30
	lda.w IRQVTime
	sta.w VTIMEL
	lda.w IRQHTime
	sta.w HTIMEL
	sep #$30
	lda.w IniDispShadow
	sta.w INIDISP
	ldx.b #$00
	txy
.loop:								; loop: BG1HOFS,y = BG1HScroll,x, BG1HOFS,y = BG1HScroll+1,x, Y + 1, ...
	txa
	lda.w BG1HScroll,x
	sta.w BG1HOFS,y
	lda.w BG1HScroll+1,x
	sta.w BG1HOFS,y
	iny
	inx
	inx
	cpx.b #$0C
	bne .loop
	rep #$20
	lda.w CGDMALen
	beq .1
	lda.w #DMA_CGRAM
	sta.w DMAP0
	lda.w CGDMASrc
	sta.w A1T0L
	ldx.w CGDMABank
	stx.w A1B0
	lda.w CGDMALen
	sta.w DAS0L
	ldx.w CGDMAColour
	stx.w CGADD
	ldx.b #$01
	stx.w MDMAEN
	lda.b DMABudget
	sec
	sbc.w CGDMALen
	sbc.w #$0048
	sta.b DMABudget
	stz.w CGDMALen
.1:									; falls through
	sep #$20
	rep #$10
	ldx.b DMAQueueHead
.2:									; loop: if zero go to .t1, ...
	cpx.b DMAQueueTail
	beq .t1
	lda.w DMAQueue,x
	bmi .4
	sta.w DMAP0
	lda.b #$18
	sta.w BBAD0
	lda.w DMAQueue+1,x
	sta.w A1T0L
	rep #$20
	lda.b DMABudget
	sec
	sbc.w #$0066
	bcc .5
	sbc.w DMAQueue+4,x
	bcc .5
	sta.b DMABudget
	lda.w DMAQueue+2,x
	sta.w A1T0H
	lda.w DMAQueue+4,x
	sta.w DAS0L
	lda.w DMAQueue+6,x
	sta.w VMADDL
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	sep #$20
	lda.b #$01
	sta.w MDMAEN
	bra .2

.t1:								; go to NMI_SendOAM
	jmp.w NMI_SendOAM
.3:									; go to .7
	jmp.w .7
.4:									; DMAQueue,x negative: if zero go to .6, ...
	cmp.b #$FD
	beq .6
	bmi .3
.1x:								; and #$00FF, if carry clear go to .5, ...
	rep #$20
	and.w #$00FF
	tay
	lda.b DMABudget
	sec
	sbc.w #$005C
	bcc .5
	sta.b DMABudget
	lda.w DMAQueue+2,x
	sta.w VMADDL
	lda.w DMAQueue+4,x
	sta.w VMDATAL
	iny
	beq .2x
	lda.w DMAQueue+6,x
	sta.w VMDATAL
.2x:								; go to .2
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	sep #$20
	jmp.w .2
.5:									; DMAQueueHead = X, go to NMI_Tick
	stx.b DMAQueueHead
	jmp.w NMI_Tick
.6:									; A1T0L = DMAQueue+1,x, DMAP0 = $1808, if carry clear go to .5, ...
	lda.w DMAQueue+1,x
	sta.w A1T0L
	rep #$20
	lda.w #$1808
	sta.w DMAP0
	lda.b DMABudget
	sec
	sbc.w #$0078
	bcc .5
	sbc.w DMAQueue+4,x
	bcc .5
	sta.b DMABudget
	lda.w DMAQueue+2,x
	sta.w A1T0H
	lda.w DMAQueue+4,x
	sta.w DAS0L
	lda.w DMAQueue+6,x
	sta.w VMADDL
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	sep #$20
	stz.w VMAIN
	lda.b #$01
	sta.w MDMAEN
	lda.b #$80
	sta.w VMAIN
	jmp.w .2
.7:									; if zero go to .t2, ...
	cmp.b #$FB
	beq .t2
	bmi .t1x
	lda.w DMAQueue+1,x
	sta.w A1T0L
	rep #$20
	lda.w #$1908
	sta.w DMAP0
	lda.b DMABudget
	sec
	sbc.w #$0079
	bcc .5
	sbc.w DMAQueue+4,x
	bcc .5
	sta.b DMABudget
	lda.w DMAQueue+2,x
	sta.w A1T0H
	lda.w DMAQueue+4,x
	sta.w DAS0L
	lda.w DMAQueue+6,x
	sta.w VMADDL
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	sep #$20
	lda.b #$01
	sta.w MDMAEN
	jmp.w .2

.t1x:								; go to .9
	jmp.w .9

.t2:								; A1T0L = DMAQueue+1,x, DMAP0 = $1800, if carry clear go to .8, ...
	lda.w DMAQueue+1,x
	sta.w A1T0L
	rep #$20
	lda.w #$1800
	sta.w DMAP0
	lda.b DMABudget
	sec
	sbc.w #$007D
	bcc .8
	sbc.w DMAQueue+4,x
	bcc .8
	sta.b DMABudget
	lda.w DMAQueue+2,x
	sta.w A1T0H
	lda.w DMAQueue+4,x
	sta.w DAS0L
	lda.w DMAQueue+6,x
	sta.w VMADDL
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	sep #$20
	stz.w VMAIN
	lda.b #$01
	sta.w MDMAEN
	lda.b #$80
	sta.w VMAIN
	jmp.w .2
.8:									; go to .5
	jmp.w .5
.9:									; A1T0L = DMAQueue+1,x, DMAP0 = $1900, if carry clear go to .8, ...
	lda.w DMAQueue+1,x
	sta.w A1T0L
	rep #$20
	lda.w #$1900
	sta.w DMAP0
	lda.b DMABudget
	sec
	sbc.w #$007D
	bcc .8
	sbc.w DMAQueue+4,x
	bcc .8
	sta.b DMABudget
	lda.w DMAQueue+2,x
	sta.w A1T0H
	lda.w DMAQueue+4,x
	sta.w DAS0L
	lda.w DMAQueue+6,x
	sta.w VMADDL
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	sep #$20
	lda.b #$01
	sta.w MDMAEN
	jmp.w .2
