; Start fading the sound out: SoundFadeSpeed = $200 (SoundUpdate lowers SoundVolume by it each frame and
; resets the sound at 0)
; Takes nothing. Called from SaveRegsStartHL2, Pausemode, PauseReplay, ReplayMode and PlayoffScreen.
FadeOutSound:						; start the sound fade out
	lda.w #$0200
	jsl.l SetSoundFade
	rtl
