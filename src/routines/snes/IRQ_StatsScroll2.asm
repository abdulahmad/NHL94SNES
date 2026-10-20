; IRQ hook: the second BG1 scroll split, then the next hook
;
; Takes nothing; runs from IRQ_Fast through IRQHook. Installed by IRQ_StatsScroll1.
IRQ_StatsScroll2:					; IRQ hook: second scroll split
	sep #$20
	lda.w irqvscroll2				; BG1VOFS = irqvscroll2
	sta.w BG1VOFS
	lda.w irqvscroll2+1
	sta.w BG1VOFS
	rep #$20
	lda.w #IRQ_StatsScroll3			; next hook = IRQ_StatsScroll3 at line irqline3
	sta.w IRQHook
	lda.w irqline3
	sta.w VTIMEL
	rtl
