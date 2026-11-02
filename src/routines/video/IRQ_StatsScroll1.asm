; IRQ hook: the first BG1 scroll split of a stats screen, then the next hook
;
; Takes nothing; runs from IRQ_Fast through IRQHook. The three splits give BG1 the vertical scroll
; values irqvscroll1 to irqvscroll3 at the lines irqline1 to irqline3. Installed by SetupScrollIRQ and
; IRQ_StatsScroll3.
IRQ_StatsScroll1:					; IRQ hook: first scroll split
	sep #$20
	lda.w irqvscroll1				; BG1VOFS = irqvscroll1
	sta.w BG1VOFS
	lda.w irqvscroll1+1
	sta.w BG1VOFS
	rep #$20
	lda.w #IRQ_StatsScroll2			; next hook = IRQ_StatsScroll2 at line irqline2
	sta.w IRQHook
	lda.w irqline2
	sta.w VTIMEL
	lda.w #$FFFF					; flag that the scroll IRQs ran
	sta.w scrollirqdone
	rtl
