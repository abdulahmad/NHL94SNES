; IRQ hook: BG1 vertical scroll from $07E0, then the next hook
IRQ_BG1Scroll:
	sep #$20
	lda.w BG3VScroll
	sta.w BG1VOFS
	lda.w BG3VScroll+1
	sta.w BG1VOFS
	rep #$20
	lda.w #.t1
	sta.w IRQHook
	lda.w #$0030
	sta.w VTIMEL
	rtl

.t1:								; IRQ hook: BG1 vertical scroll $FFFF, then IRQ_BG1Scroll is the next hook
	sep #$20
	lda.b #$FF
	sta.w BG1VOFS
	lda.b #$FF
	sta.w BG1VOFS
	rep #$20
	lda.w #IRQ_BG1Scroll
	sta.w IRQHook
	rtl
