; Takes A = SoundFadeSpeed, the amount subtracted from SoundVolume each frame by SoundUpdate.
;
; Called from FadeOutSound.
; SoundFadeSpeed = A
SetSoundFade:						; SoundFadeSpeed = A
	sta.l SoundFadeSpeed
	rtl
