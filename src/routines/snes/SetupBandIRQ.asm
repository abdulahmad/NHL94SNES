; Set up an IRQ pair that shifts the BG1 scroll for a band of lines
; A = first IRQ line, X = second IRQ line (stored in irqline1/irqline2). Sets IRQHTime to $C4 and starts
; IRQ_BandStart at line A with SetIRQ.
;
; Called from setoptions, ScoutingReport, EditLinesScreen and ShootoutShooters.
SetupBandIRQ:						; set up the band IRQ pair
	sta.w irqline1					; line of the first IRQ
	stx.w irqline2					; line of the second IRQ
	lda.w #$00C4					; H-counter position of both IRQs
	sta.w IRQHTime					; set IRQHTime
	lda.w #IRQ_BandStart			; hook = IRQ_BandStart, low 16 bits
	ldx.w #IRQ_BandStart>>16		; and its bank
	ldy.w irqline1					; V line of the first IRQ
	jsl.l SetIRQ					; start the IRQ
	rtl
