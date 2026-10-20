; Full brightness, no forced blank
ScreenOn:							; called from EditLinesScreen, IntroSequence, PauseReplay, Pausemode, P...
	pha
	lda.w brightness
	cmp.w #$000F
	beq .1
	jsl.l FadeIn
.1:									; IniDispShadow = $0F, return
	sep #$20
	lda.b #$0F
	sta.w IniDispShadow
	rep #$20
	pla
	rtl
