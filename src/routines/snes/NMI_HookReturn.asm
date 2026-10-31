; NMI after the hook: the IRQ timers, INIDISP from IniDispShadow, the BG scroll registers and the rest of the
; frame registers
NMI_HookReturn:						; called from NMI_Fast
	rep #$30						;16-bit A and index
	lda.w IRQVTime					;IRQ vertical timer
	sta.w VTIMEL					;to VTIMEL
	lda.w IRQHTime					;IRQ horizontal timer
	sta.w HTIMEL					;to HTIMEL
	sep #$30						;8-bit A and index
	lda.w IniDispShadow				;screen brightness shadow
	sta.w INIDISP					;to INIDISP
	ldx.b #$00						;start at BG1 scroll entry 0
	txy								;Y = 0 (register index)
.loop:								; loop: BG1HOFS,y = BG1HScroll,x, BG1HOFS,y = BG1HScroll+1,x, Y + 1, ...
	txa								;A = X
	lda.w BG1HScroll,x				;scroll low byte
	sta.w BG1HOFS,y					;to the BG scroll register (write twice: low, then high)
	lda.w BG1HScroll+1,x			;scroll high byte
	sta.w BG1HOFS,y					;to the same register
	iny								;next register
	inx								;next scroll pair
	inx								;2 bytes per pair
	cpx.b #$0C						;all six scroll registers done?
	bne .loop						;more registers: loop
	rep #$20						;16-bit A
	lda.w CGDMALen					;CGRAM DMA length
	beq .1							;none: skip
	lda.w #DMA_CGRAM				;DMA mode: write to CGDATA
	sta.w DMAP0						;to the DMA 0 control and destination
	lda.w CGDMASrc					;source address
	sta.w A1T0L						;to DMA 0 source
	ldx.w CGDMABank					;source bank
	stx.w A1B0						;to DMA 0 bank
	lda.w CGDMALen					;length
	sta.w DAS0L						;to DMA 0 count
	ldx.w CGDMAColour				;first colour to write
	stx.w CGADD						;to CGADD
	ldx.b #$01						;channel 0
	stx.w MDMAEN					;start the DMA
	lda.b DMABudget					;DMA budget left this frame
	sec								;minus
	sbc.w CGDMALen					;the colours
	sbc.w #$0048					;and the DMA set-up cost
	sta.b DMABudget					;new budget
	stz.w CGDMALen					;CGRAM DMA done
.1:									; falls through
	sep #$20						;8-bit A
	rep #$10						;16-bit index
	ldx.b DMAQueueHead				;queue read position
.2:									; loop: if zero go to .t1, ...
	cpx.b DMAQueueTail				;reached the write position?
	beq .t1							;queue empty: finish
	lda.w DMAQueue,x				;entry type
	bmi .4							;negative: special entry
	sta.w DMAP0						;DMA control (mode)
	lda.b #$18						;destination register $2118 (VMDATAL)
	sta.w BBAD0						;to BBAD0
	lda.w DMAQueue+1,x				;source low byte
	sta.w A1T0L						;to DMA 0 source
	rep #$20						;16-bit A
	lda.b DMABudget					;DMA budget left this frame
	sec								;minus
	sbc.w #$0066					;minus the set-up cost of a DMA
	bcc .5							;not enough budget: stop
	sbc.w DMAQueue+4,x				;minus the length
	bcc .5							;not enough budget: stop
	sta.b DMABudget					;new budget
	lda.w DMAQueue+2,x				;source middle and bank bytes
	sta.w A1T0H						;to DMA 0 source
	lda.w DMAQueue+4,x				;length
	sta.w DAS0L						;to DMA 0 count
	lda.w DMAQueue+6,x				;VRAM address
	sta.w VMADDL					;to VMADDL
	txa								;A = queue position
	clc								;plus the entry size
	adc.w #$0008					;8 bytes per entry
	and.w #$03FF					;wrap the queue (1 KB)
	tax								;back to X
	sep #$20						;8-bit A
	lda.b #$01						;channel 0
	sta.w MDMAEN					;start the DMA
	bra .2							;next entry

.t1:								; go to NMI_SendOAM
	jmp.w NMI_SendOAM				; NMI: send the sprite table to OAM when it is ready and there is time
.3:									; go to .7
	jmp.w .7						;to the next kind of entry
.4:									; DMAQueue,x negative: if zero go to .6, ...
	cmp.b #$FD						;type $FD: fill
	beq .6							;to the fill-to-VRAM entry
	bmi .3							;below $FD: more kinds
.1x:								; and #$00FF, if carry clear go to .5, ...
	rep #$20						;16-bit A
	and.w #$00FF					;the word count
	tay								;in Y
	lda.b DMABudget					;DMA budget left this frame
	sec								;minus
	sbc.w #$005C					;the cost of a word write
	bcc .5							;not enough budget: stop
	sta.b DMABudget					;new budget
	lda.w DMAQueue+2,x				;VRAM address
	sta.w VMADDL					;to VMADDL
	lda.w DMAQueue+4,x				;first word
	sta.w VMDATAL					;to VMDATAL
	iny								;count + 1
	beq .2x							;zero: done
	lda.w DMAQueue+6,x				;second word
	sta.w VMDATAL					;to VMDATAL
.2x:								; go to .2
	txa								;A = queue position
	clc								;plus the entry size
	adc.w #$0008					;8 bytes per entry
	and.w #$03FF					;wrap the queue (1 KB)
	tax								;back to X
	sep #$20						;8-bit A
	jmp.w .2						;next entry
.5:									; DMAQueueHead = X, go to NMI_Tick
	stx.b DMAQueueHead				;remember the read position
	jmp.w NMI_Tick					;on to the frame tick
.6:									; A1T0L = DMAQueue+1,x, DMAP0 = $1808, if carry clear go to .5, ...
	lda.w DMAQueue+1,x				;source low byte
	sta.w A1T0L						;to DMA 0 source
	rep #$20						;16-bit A
	lda.w #$1808					;mode $08 (fixed source), destination VMDATAL
	sta.w DMAP0						;to DMA 0
	lda.b DMABudget					;DMA budget left this frame
	sec								;minus
	sbc.w #$0078					;minus the set-up cost of a fill
	bcc .5							;not enough budget: stop
	sbc.w DMAQueue+4,x				;minus the length
	bcc .5							;not enough budget: stop
	sta.b DMABudget					;new budget
	lda.w DMAQueue+2,x				;source middle and bank bytes
	sta.w A1T0H						;to DMA 0 source
	lda.w DMAQueue+4,x				;length
	sta.w DAS0L						;to DMA 0 count
	lda.w DMAQueue+6,x				;VRAM address
	sta.w VMADDL					;to VMADDL
	txa								;A = queue position
	clc								;plus the entry size
	adc.w #$0008					;8 bytes per entry
	and.w #$03FF					;wrap the queue (1 KB)
	tax								;back to X
	sep #$20						;8-bit A
	stz.w VMAIN						;VRAM increment after the low byte
	lda.b #$01						;channel 0
	sta.w MDMAEN					;start the DMA
	lda.b #$80						;VRAM increment after the high byte
	sta.w VMAIN						;back to the normal setting
	jmp.w .2						;next entry
.7:									; if zero go to .t2, ...
	cmp.b #$FB						;type $FB: second kind of fill
	beq .t2							;to .t2
	bmi .t1x						;below: .9
	lda.w DMAQueue+1,x				;source low byte
	sta.w A1T0L						;to DMA 0 source
	rep #$20						;16-bit A
	lda.w #$1908					;mode $08 (fixed source), destination VMDATAH
	sta.w DMAP0						;to DMA 0
	lda.b DMABudget					;DMA budget left this frame
	sec								;minus
	sbc.w #$0079					;minus the set-up cost of a fill
	bcc .5							;not enough budget: stop
	sbc.w DMAQueue+4,x				;minus the length
	bcc .5							;not enough budget: stop
	sta.b DMABudget					;new budget
	lda.w DMAQueue+2,x				;source middle and bank bytes
	sta.w A1T0H						;to DMA 0 source
	lda.w DMAQueue+4,x				;length
	sta.w DAS0L						;to DMA 0 count
	lda.w DMAQueue+6,x				;VRAM address
	sta.w VMADDL					;to VMADDL
	txa								;A = queue position
	clc								;plus the entry size
	adc.w #$0008					;8 bytes per entry
	and.w #$03FF					;wrap the queue (1 KB)
	tax								;back to X
	sep #$20						;8-bit A
	lda.b #$01						;channel 0
	sta.w MDMAEN					;start the DMA
	jmp.w .2						;next entry

.t1x:								; go to .9
	jmp.w .9

.t2:								; A1T0L = DMAQueue+1,x, DMAP0 = $1800, if carry clear go to .8, ...
	lda.w DMAQueue+1,x				;source low byte
	sta.w A1T0L						;to DMA 0 source
	rep #$20						;16-bit A
	lda.w #$1800					;mode $00, destination VMDATAL (copy)
	sta.w DMAP0						;to DMA 0
	lda.b DMABudget					;DMA budget left this frame
	sec								;minus
	sbc.w #$007D					;minus the set-up cost of a copy
	bcc .8							;not enough budget: stop
	sbc.w DMAQueue+4,x				;minus the length
	bcc .8							;not enough budget: stop
	sta.b DMABudget					;new budget
	lda.w DMAQueue+2,x				;source middle and bank bytes
	sta.w A1T0H						;to DMA 0 source
	lda.w DMAQueue+4,x				;length
	sta.w DAS0L						;to DMA 0 count
	lda.w DMAQueue+6,x				;VRAM address
	sta.w VMADDL					;to VMADDL
	txa								;A = queue position
	clc								;plus the entry size
	adc.w #$0008					;8 bytes per entry
	and.w #$03FF					;wrap the queue (1 KB)
	tax								;back to X
	sep #$20						;8-bit A
	stz.w VMAIN						;VRAM increment after the low byte
	lda.b #$01						;channel 0
	sta.w MDMAEN					;start the DMA
	lda.b #$80						;VRAM increment after the high byte
	sta.w VMAIN						;back to the normal setting
	jmp.w .2						;next entry
.8:									; go to .5
	jmp.w .5
.9:									; A1T0L = DMAQueue+1,x, DMAP0 = $1900, if carry clear go to .8, ...
	lda.w DMAQueue+1,x				;source low byte
	sta.w A1T0L						;to DMA 0 source
	rep #$20						;16-bit A
	lda.w #$1900					;mode $00, destination VMDATAH (copy)
	sta.w DMAP0						;to DMA 0
	lda.b DMABudget					;DMA budget left this frame
	sec								;minus
	sbc.w #$007D					;minus the set-up cost of a copy
	bcc .8							;not enough budget: stop
	sbc.w DMAQueue+4,x				;minus the length
	bcc .8							;not enough budget: stop
	sta.b DMABudget					;new budget
	lda.w DMAQueue+2,x				;source middle and bank bytes
	sta.w A1T0H						;to DMA 0 source
	lda.w DMAQueue+4,x				;length
	sta.w DAS0L						;to DMA 0 count
	lda.w DMAQueue+6,x				;VRAM address
	sta.w VMADDL					;to VMADDL
	txa								;A = queue position
	clc								;plus the entry size
	adc.w #$0008					;8 bytes per entry
	and.w #$03FF					;wrap the queue (1 KB)
	tax								;back to X
	sep #$20						;8-bit A
	lda.b #$01						;channel 0
	sta.w MDMAEN					;start the DMA
	jmp.w .2						;next entry
