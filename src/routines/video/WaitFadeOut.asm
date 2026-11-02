; Wait until the fade has reached black
; Waits frame by frame until brightness reads 0.
;
; Called from SetupScreen, puckfaceoff2, SaveRegsStartHL2, ReloadRink and PasswordScreen.
WaitFadeOut:						; wait until the screen is black
	jsl.l WaitFrame
	lda.w brightness
	bne WaitFadeOut
	rtl
