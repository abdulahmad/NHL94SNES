; A * X, 8 by 8 bits, X signed, into A
Mul8XS:								; called from FillPlayerStatsPage, burst, dopass, doplayeracc, doshot a...
	phy
Mul8XS_x:							; called from Mul8S
	cpx.w #$0000
	bpl Mul8U_mul
Mul8XS_neg:							; called from Mul8S_swap
	sep #$30
	sta.w WRMPYA
	txa
	eor.b #$FF
	inc a
	sta.w WRMPYB
	rep #$30
	lda.w #$0000
	sec
	sbc.w RDMPYL
	ply
	rtl
; Mul8S with A positive and X negative: X = A, into Mul8XS_neg
Mul8S_swap:							; called from Mul8S
	tyx
	bra Mul8XS_neg
