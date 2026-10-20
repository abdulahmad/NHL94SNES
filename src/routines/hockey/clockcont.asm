; When the clock runs out, freeze the view and end the period
;
; Takes nothing. Does nothing while either clock word is nonzero. Called from periodicevents.
clockcont:							; end of period check, once per game loop
	lda.w gmclock					; gmclock = nonzero while the clock is stopped
	ora.w gameclock					; or the game clock seconds
	bne .t1							; clock still running (or stopped): done
	jsl.l freezewindow				; freeze the view
	jmp.w clockcont_0				; end the period; clockcont_0 returns for us

.t1:								; clock not at zero: nothing to do
	rtl
