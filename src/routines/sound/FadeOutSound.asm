; Start fading the sound out: SoundFadeSpeed = $200 (SoundUpdate lowers SoundVolume by it each frame and
; resets the sound at 0)
FadeOutSound:
	lda.w #$0200
	jsl.l SetSoundFade
	rtl
