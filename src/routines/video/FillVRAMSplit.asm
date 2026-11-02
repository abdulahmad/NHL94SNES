; Fill X bytes of video memory at Y with the word A, the low bytes then the high bytes
;
; Takes: A = fill word, X = byte count (per half), Y = VRAM word address. Returns Y = VRAM word address after
; the fill. Fills the low bytes of X VRAM words, then the high bytes. Immediate with the screen blanked,
; otherwise queued in pieces of $1000. Called by TitleScreen and ReplayMode.
FillVRAMSplit:						; fill VRAM with the low bytes, then the high bytes
	sta.b r3+2						; the fill word is the DMA source ($0016)
	lda.w IniDispShadow-1			; high byte of the INIDISP shadow: bit 7 set = screen blanked
	bpl .t1							; screen on: queue the DMAs instead
	txa								; first pass: the low byte of the word, VMAIN = 0 (step after the low
									; byte)
	pha
	sta.w DAS1L
	sty.w VMADDL
	sty.b r3
	ldy.w #$0016
	sty.w A1T1L
	lda.w #$1808					; channel 1: mode 0, fixed source, to VMDATAL ($2118)
	sta.w DMAP1
	sep #$20
	stz.w VMAIN
	stz.w A1B1
	lda.b #$02
	sta.w MDMAEN
	rep #$20
	pla								; second pass: the high byte (source $0017), VMAIN = $80 (step after the
									; high byte)
	sta.w DAS1L
	clc
	adc.b r3
	pha
	ldy.b r3
	sty.w VMADDL
	ldy.w #$0017
	sty.w A1T1L
	lda.w #$1908					; channel 1: mode 0, fixed source, to VMDATAH ($2119)
	sta.w DMAP1
	sep #$20
	lda.b #$80
	sta.w VMAIN
	stz.w A1B1
	lda.b #$02
	sta.w MDMAEN
	rep #$20						; Y = Y + X: VRAM address after the fill
	ply
	rtl

.t1:								; screen on: queue the fill in pieces of at most $1000 bytes
	txa
	ldx.b DMAQueueTail
.loop:								; next piece
	pha
	cmp.w #$1001
	bcc .1
	lda.w #$1000
.1:									; piece size = min(remaining, $1000)
	pha
	sta.w DMAQueue+4,x
	tya
	sta.w DMAQueue+6,x
	lda.w #$0016
	sta.w DMAQueue+1,x
	sep #$20
	stz.w DMAQueue+3,x
	lda.b #$FD						; entry type $FD: low byte fill
	sta.w DMAQueue,x
	rep #$20
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	pla
	sta.w DMAQueue+4,x
	pha
	tya
	sta.w DMAQueue+6,x
	pla
	clc
	adc.w DMAQueue+6,x
	tay
	lda.w #$0017
	sta.w DMAQueue+1,x
	sep #$20
	stz.w DMAQueue+3,x
	lda.b #$FC						; entry type $FC: high byte fill from $0017
	sta.w DMAQueue,x
	rep #$20
	txa
	clc
	adc.w #$0008
	and.w #$03FF
	tax
	pla
	sec
	sbc.w #$1000
	beq .2
	bcs .loop
.2:									; save the new queue tail
	stx.b DMAQueueTail
	rtl
