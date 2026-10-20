; NMI hook: write the fade brightness to INIDISP unless the screen is blanked
BrightnessHook:						; called from FadeIn, FadeOut, ReplayMode
	sep #$20
	lda.w IniDispShadow
	bmi .1x
	lda.w brightness
	sta.w INIDISP
.1x:								; return
	rep #$30
	rtl
