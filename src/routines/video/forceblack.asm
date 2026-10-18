; Turn the screen black: default interrupt handlers, forced blank, PPU registers reset
forceblack:
	lda.w brightness
	beq .1
	jsl.l FadeOut
	jsl.l WaitFadeOut
.1:
	jsl.l BlankScreen
	jmp.w ResetPPURegs
