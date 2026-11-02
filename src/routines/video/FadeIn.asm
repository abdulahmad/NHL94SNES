; Fade the screen in after a short delay
;
; Starts a fade in: fadestep = 5 is the delay in frames before the brightness starts to rise, and
; BrightnessHook is installed as the frame hook. Takes nothing, returns nothing. Called by TeamRosterScreen,
; TitleScreen, Pausemode, ReloadRink and the other screen set ups after they draw (ScreenOn also uses it).
FadeIn:								; fade in: install BrightnessHook as the frame hook
	lda.w #$0005					; delay of 5 frames before the fade in starts
	sta.w fadestep					; store fadestep
	ldx.w #BrightnessHook>>16		; X:A = BrightnessHook address (bank in X)
	lda.w #BrightnessHook
	jsl.l SetFrameHook				; set it as the frame hook
	rtl
