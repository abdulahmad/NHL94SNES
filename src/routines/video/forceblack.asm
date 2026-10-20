; Turn the screen black: default interrupt handlers, forced blank, PPU registers reset
forceblack:							; called from IntroSequence, LoadPlayerCardScreen, LoadScoutingScreen...
	lda.w brightness
	beq .1
	jsl.l FadeOut
	jsl.l WaitFadeOut
.1:									; call BlankScreen, go to ResetPPURegs
	jsl.l BlankScreen
	jmp.w ResetPPURegs
