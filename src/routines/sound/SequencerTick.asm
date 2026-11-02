; Advance the tempo: update the voices and step every track
SequencerTick:						; called from SoundUpdate
	lda.w TempoAcc
	clc
	adc.b #$40
.loop:								; loop: TempoAcc = A, if carry clear go to .t1, ...
	sta.w TempoAcc
	cmp.w TempoTick
	bcc .t1
	jsr.w UpdateVoices				; update the music voices
	lda.w MusicPause
	bne .1
	ldx.w TrackCount
	beq .t1
	dex
.loop2:								; loop: call StepTrack, if MusicOn = 0 go to .t1, ...
	jsr.w StepTrack					; step one sequencer track
	lda.w MusicOn
	beq .t1
	dex
	bpl .loop2
.1:									; go to .loop
	lda.w TempoAcc
	sec
	sbc.w TempoTick
	bra .loop

.t1:								; return
	rts
