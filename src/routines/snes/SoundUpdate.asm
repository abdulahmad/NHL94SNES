; per frame: fade, envelopes, and the song ticks that are due; nothing while SoundLock is set
SoundUpdate:						;per frame: fade, envelopes, and the song ticks that are due; nothing
									;while SoundLock is set
	sep #$30
	lda.b SoundBank
	pha
	plb
	lda.w SoundLock
	bne .6
	rep #$20
	lda.w SoundFadeSpeed
	beq .5
	lda.w SoundVolume
	sec
	sbc.w SoundFadeSpeed
	sta.w SoundVolume
	bcs .t1
	jsl.l SoundInit
	bra .5

.t1:
	sep #$20
	jsr.w SeqCmd08Init_send
.5:
	sep #$20
	lda.w MusicPause
	beq .2
.1:
	lda.w SoundVolume+1
	pha
	stz.w SoundVolume+1
.2:
	lda.w MusicPause
	beq .4
.3:
	pla
	sta.w SoundVolume+1
.4:
	jsr.w UpdateSfxVoices
	lda.w MusicOn
	beq .6
	jsr.w SequencerTick
.6:
	rts
