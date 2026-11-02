; DMA X bytes of colours from [p0] to CGRAM at colour Y
DMAToCGRAM:							; called from ClrHor, DrawHorTeams, IntroSequence, PlayoffScreen, Pulse...
	sep #$20
	lda.w IniDispShadow
	bpl .t1
	tya
	sta.w CGADD
	rep #$20
	txa
	sep #$10
	asl a
	beq .1
	sta.w DAS1L
	lda.w #DMA_CGRAM
	sta.w DMAP1
	lda.b p0
	sta.w A1T1L
	ldx.b p0+2
	stx.w A1B1
	ldx.b #$02
	stx.w MDMAEN
.1:									; return
	rep #$30
	rtl

.t1:								; IniDispShadow >= 0: CGDMAColour = Y, CGDMABank = p0+2, CGDMASrc = p0...
	sty.w CGDMAColour
	rep #$20
	lda.b p0+2
	sta.w CGDMABank
	lda.b p0
	sta.w CGDMASrc
	txa
	asl a
	sta.w CGDMALen
	rtl

.t3:								; if zero go to .t1x, ...
	cmp.w #$0000
	beq .t1x
	cmp.w #$0100
	bne .t2
	tya
	asl a
	tay
.loop:								; loop: [p1],y = [p0],y, Y + 1, Y + 1, ...
	lda.b [p0],y
	sta.b [p1],y
	iny
	iny
	dex
	bne .loop
	rtl

.t1x:								; falls through
	lda.w #$0000
	tya
	asl a
	tay
.loopx:								; loop: [p1],y = A, Y + 1, Y + 1, ...
	sta.b [p1],y
	iny
	iny
	dex
	bne .loopx
	rtl

.t2:								; and #$00FF, xba, r3 = A, ...
	and.w #$00FF
	xba
	sta.b r3
	tya
	asl a
	tay
.loopx2:							; loop: ora r3, WRMPYA = A, xba, ...
	lda.b [p0],y
	and.w #$001F
	ora.b r3
	sta.w WRMPYA
	nop
	rep #$20
	lda.w RDMPYL
	xba
	and.w #$001F
	sta.b [p1],y
	lda.b [p0],y
	asl a
	asl a
	asl a
	xba
	and.w #$001F
	ora.b r3
	sta.w WRMPYA
	nop
	rep #$20
	lda.w RDMPYL
	lsr a
	lsr a
	lsr a
	and.w #$03E0
	ora.b [p1],y
	sta.b [p1],y
	lda.b [p0],y
	xba
	lsr a
	lsr a
	and.w #$001F
	ora.b r3
	sta.w WRMPYA
	nop
	rep #$20
	lda.w RDMPYL
	asl a
	asl a
	and.w #$7C00
	ora.b [p1],y
	sta.b [p1],y
	iny
	iny
	dex
	bne .loopx2
	rtl
