; per frame: fade, envelopes, and the song ticks that are due; nothing while SoundLock is set
; Called every frame from NMI_FrameHookReturn. Switches to the sound bank, then does nothing when SoundLock
; is set. SoundFadeSpeed is subtracted from SoundVolume (the sound is reset on underflow), the volume is
; muted while the music is paused, then the effect voices and the sequencer are run.
SoundUpdate:						;per frame: fade, envelopes, and the song ticks that are due; nothing
									;while SoundLock is set
	sep #$30						; 8-bit registers
	lda.b SoundBank					; bank of the sound data
	pha								; becomes the data bank
	plb
	lda.w SoundLock					; locked?
	bne .6							; yes, skip everything
	rep #$20						; 16-bit A
	lda.w SoundFadeSpeed			; fading?
	beq .5							; no fade
	lda.w SoundVolume				; volume
	sec								; fade it down
	sbc.w SoundFadeSpeed
	sta.w SoundVolume				; store the new volume
	bcs .t1							; still above 0
	jsl.l SoundInit					; underflow: reset the sound
	bra .5							; done fading

.t1:								; volume changed
	sep #$20						; 8-bit A
	jsr.w SeqCmd08Init_send			; send the new volume to the SPC
.5:									; after the fade step
	sep #$20						; 8-bit A
	lda.w MusicPause				; music paused?
	beq .2							; not paused: skip the mute
.1:									; paused: save the volume high byte
	lda.w SoundVolume+1				; volume high byte
	pha								; keep it on the stack
	stz.w SoundVolume+1				; and set it to 0
.2:									; second pause test
	lda.w MusicPause				; paused?
	beq .4							; no: nothing was pushed
.3:									; get the volume back
	pla								; restore the volume
	sta.w SoundVolume+1				; high byte
.4:									; run the effect voices
	jsr.w UpdateSfxVoices			; update the sound effect voices
	lda.w MusicOn					; music playing?
	beq .6							; no music: done
	jsr.w SequencerTick				; step the sequencer
.6:									; leave the sound code
	rts
