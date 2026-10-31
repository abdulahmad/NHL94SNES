; Turn the screen black: default interrupt handlers, forced blank, PPU registers reset
forceblack:							; called from IntroSequence, LoadPlayerCardScreen, LoadScoutingScreen...
	lda.w brightness
	beq .1
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
.1:									; call BlankScreen, go to ResetPPURegs
	jsl.l BlankScreen				; wait for a frame, set the default hooks, turn the IRQ off
	jmp.w ResetPPURegs				; reset the scroll, window and colour math registers and their copies
