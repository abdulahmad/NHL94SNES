; Wait until the active controller's buttons are up.
;
; Takes: pausepad = the pad to watch. Returns when its JoyPad word is 0; registers kept.
; Called from EditLinesMenu and AskExitGame.
WaitButtonRelease:					; wait until the pause pad has no button down
	phx								; save X and A
	pha
	ldx.w pausepad					; X = pad index (word offset)
.loop:								; poll loop
	lda.w JoyPad,x					; buttons held on that pad
	bne .loop						; any button still down: keep waiting
	pla								; restore A and X
	plx
	rtl
