; Fade the screen out over the next frames
;
; Starts a fade out: fadestep = $FFFF makes the frame hook lower the brightness each frame. Callers
; follow it with WaitFadeOut. Takes nothing, returns nothing. Called by SetupScreen, StartGame, Pausemode,
; ReloadRink, PeriodOver and many other screen changes.
FadeOut:							; fade out: install BrightnessHook as the frame hook
	lda.w #$FFFF					; $FFFF = fade out
	sta.w fadestep					; store fadestep
	ldx.w #BrightnessHook>>16		; X:A = BrightnessHook address (bank in X)
	lda.w #BrightnessHook
	jsl.l SetFrameHook				; set it as the frame hook
	rtl
