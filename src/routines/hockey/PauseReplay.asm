; Pause menu Instant Replay
PauseReplay:						; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	bne .t1
	jmp.w PauseMenuPoll

.t1:								; d1 bit $8080 set: replaymusic = MusicOn, call FadeOut, call FadeOutSo...
	lda.w MusicOn
	sta.w replaymusic
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l FadeOutSound				; start the sound fade out
	jsl.l WaitFadeOut				; wait until the screen is black
	jsl.l forceblack				; turn the screen black: default interrupt handlers, forced blank
	lda.b d7
	pha
	lda.b vcount+2
	dec a
	dec a
	sta.w vcountmark+2
	jsl.l ReplayMode				; instant replay
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l ScreenOn
	pla
	sta.b d7
	sta.w timestep
PauseSubmenuDone:					; called from PauseCrowdLevel, PauseEditLines, PauseGameStats, PauseOth...
	stz.w textdirtylo
	lda.w #$03FF
	sta.w textdirtyhi
	lda.w #$0001
	rtl
