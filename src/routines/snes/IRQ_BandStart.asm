; IRQ hook: shift the BG1 scroll for the band, then IRQ_BandEnd
;
; Takes nothing; runs from IRQ_Fast through IRQHook. First IRQ of the band: shifts BG1 for the lines up to
; the second IRQ. Installed by SetupBandIRQ and IRQ_BandEnd.
IRQ_BandStart:						; IRQ hook: start of the band
	sep #$20
	lda.b #$FC						; BG1HOFS = $FFFC (-4)
	sta.w BG1HOFS
	lda.b #$FF
	sta.w BG1HOFS
	lda.b #$FB						; BG1VOFS = $FFFB (-5)
	sta.w BG1VOFS
	lda.b #$FF
	sta.w BG1VOFS
	rep #$20
	lda.w #IRQ_BandEnd				; next hook = IRQ_BandEnd at line irqline2
	sta.w IRQHook
	lda.w irqline2
	sta.w VTIMEL
	rtl
