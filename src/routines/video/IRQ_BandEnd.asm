; IRQ hook: put the BG1 scroll back, then IRQ_BandStart
;
; Takes nothing; runs from IRQ_Fast through IRQHook. Second IRQ of the band: BG1 scroll back to 0 / -1.
; Installed by IRQ_BandStart.
IRQ_BandEnd:						; IRQ hook: end of the band
	sep #$20
	stz.w BG1HOFS					; BG1HOFS = 0
	stz.w BG1HOFS
	lda.b #$FF						; BG1VOFS = $FFFF
	sta.w BG1VOFS
	sta.w BG1VOFS
	rep #$20
	lda.w #IRQ_BandStart			; next hook = IRQ_BandStart at line irqline1
	sta.w IRQHook
	lda.w irqline1
	sta.w VTIMEL
	rtl
