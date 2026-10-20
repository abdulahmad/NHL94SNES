; Fill X bytes of video memory at Y with the word A
;
; Takes: A = fill word, X = byte count, Y = VRAM word address (negative = continue at the current address,
; immediate mode only). Returns Y = VRAM word address after the fill. With the screen blanked the DMA runs at
; once, otherwise it is queued in 4KB pieces for the NMI. Called by Reset_Fast, setupice, InitSetupChars
; and LoadScoutingScreen.
FillVRAM:							; fill VRAM with a word
	sta.b r3+2						; the fill word is the DMA source ($0016)
	lda.w IniDispShadow-1			; high byte of the INIDISP shadow: bit 7 set = screen blanked
	bpl .t1							; screen on: queue the DMA instead
	stx.w DAS1L						; DMA size
	cpy.w #$0000					; VRAM address: keep the current one if Y is negative
	bmi .1
	sty.w VMADDL
	sty.b r3
.1:									; set up and start the DMA
	ldy.w #$0016					; DMA source address $0016 (r3+2, the fill word)
	sty.w A1T1L
	sep #$20						; channel 1: mode 9 = fixed source, write the register pair, to VMDATAL
									; ($2118)
	lda.b #$09
	sta.w DMAP1
	lda.b #$18
	sta.w BBAD1
	stz.w A1B1
	lda.b #$02
	sta.w MDMAEN					; start channel 1
	rep #$20
	txa								; Y = Y + X/2: the VRAM word address after the fill
	lsr a
	adc.b r3
	tay
	rtl

.t1:								; screen on: queue the fill in pieces of at most $1000 bytes
	txa
	ldx.b DMAQueueTail
.loop:								; next piece
	pha
	cmp.w #$1001					; piece size = min(remaining, $1000)
	bcc .1x
	lda.w #$1000
.1x:								; piece size into the entry, then its VRAM address
	sta.w DMAQueue+4,x
	lsr a
	pha
	tya
	sta.w DMAQueue+6,x
	pla
	clc
	adc.w DMAQueue+6,x
	tay
	lda.w #$0016					; entry source address $0016, bank 0, type 9
	sta.w DMAQueue+1,x
	sep #$20
	stz.w DMAQueue+3,x
	lda.b #$09
	sta.w DMAQueue,x
	rep #$20
	txa								; next ring entry (8 bytes), wrap at $400
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	pla								; loop while bytes remain
	sec
	sbc.w #$1000
	beq .2
	bcs .loop
.2:									; save the new queue tail
	stx.b DMAQueueTail
	rtl
