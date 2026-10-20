; Set up the split scroll of a stats screen: the IRQ lines A, X, Y and the first hook
; A, X and Y = the three split lines (stored in irqline1..irqline3). The scroll values of the three splits
; are set to $FFFF and IRQ_StatsScroll1 is started at line A with SetIRQ.
;
; Called from ShowGameStats, ShowOtherScores, ShowScoringSummary, ShowPlayerStats and ShowPenaltySummary.
SetupScrollIRQ:						; set up the three-way scroll IRQ
	sta.w irqline1					; line of the first split
	stx.w irqline2					; line of the second split
	sty.w irqline3					; line of the third split
	lda.w #$FFFF					; scroll value $FFFF for all three splits
	sta.w irqvscroll1				; first split
	sta.w irqvscroll2				; second split
	sta.w irqvscroll3				; third split
	lda.w #$00C4					; H-counter position of the IRQs
	sta.w IRQHTime					; set IRQHTime
	lda.w #IRQ_StatsScroll1			; hook = IRQ_StatsScroll1, low 16 bits
	ldx.w #IRQ_StatsScroll1>>16		; and its bank
	ldy.w irqline1					; V line of the first split
	jsl.l SetIRQ					; start the IRQ
	rtl
