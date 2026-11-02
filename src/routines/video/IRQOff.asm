; Turn the IRQ off, the NMI and pad reading on
;
; Takes nothing, keeps A and the flags. Puts the NMI and automatic pad reading back on, and the IRQ hook to
; IRQHook_Off. Called by BlankScreen.
IRQOff:								; stop the IRQs
	sei								; interrupts off while the hook is replaced
	php
	pha
	sep #$20
	lda.b #$81						; NMITIMEN = $81: NMI on, auto joypad read, no H/V IRQ
	sta.w NMITIMEN
	stz.w IRQHook+2					; hook bank 0
	rep #$20
	lda.w #IRQHook_Off				; hook = IRQHook_Off
	sta.w IRQHook
	pla								; restore A and the flags, interrupts on
	plp
	cli
	rtl
