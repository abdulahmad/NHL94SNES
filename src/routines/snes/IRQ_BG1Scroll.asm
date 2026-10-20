; IRQ hook: BG1 vertical scroll from $07E0, then the next hook
;
; Takes nothing; runs from IRQ_Fast through IRQHook. Not installed by any routine in the ROM. Writes the
; BG3VScroll word to BG1VOFS, then the .t1 hook runs at line $30.
IRQ_BG1Scroll:						; IRQ hook: BG1 vertical scroll from BG3VScroll
	sep #$20						; 8-bit A
	lda.w BG3VScroll				; BG1VOFS takes the low byte, then the high byte
	sta.w BG1VOFS
	lda.w BG3VScroll+1
	sta.w BG1VOFS
	rep #$20						; 16-bit A
	lda.w #.t1						; next hook = .t1
	sta.w IRQHook
	lda.w #$0030					; next IRQ at line $30
	sta.w VTIMEL
	rtl

.t1:								; IRQ hook: BG1 vertical scroll $FFFF, then IRQ_BG1Scroll is the next hook
	sep #$20						; 8-bit A
	lda.b #$FF						; BG1VOFS = $FFFF
	sta.w BG1VOFS
	lda.b #$FF
	sta.w BG1VOFS
	rep #$20						; next hook = IRQ_BG1Scroll again
	lda.w #IRQ_BG1Scroll
	sta.w IRQHook
	rtl
