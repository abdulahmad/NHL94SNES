; Play sound A at once on the sound effect voices (the QueueSound set up without the replay record or the
; already-playing test)
; Takes A = sound number. Sets up the sound effect track (track $10) for that sound entry and starts it on
; a voice with StartSoundVoice at the volume of the instrument and the velocity SfxVelocity.
;
; Called from TitleScreen, IntroSequence and others.
PlaySound:							; play sound A at once
	phx
	phy
	phb
	php
	sep #$30
	pha
	dec.w SoundLock
	lda.b SoundBank
	pha
	plb
	pla
	ldx.b #$10
	stx.b CurTrack
	ldx.b #$20
	stx.w CurTrackOfs
	asl a
	tay
	rep #$20
	lda.b [SoundTable],y
	clc
	adc.b SoundTable
	sta.b InstPtr
	sta.w TrackInst,x
PlaySoundEntry:						; shared start of QueueSound and PlaySound: InstPtr and track $10 are set
	ldy.b #$06
	lda.b (InstPtr),y
	sta.b EventData2
	sep #$20
	ldy.b #$05
	lda.b (InstPtr),y
	sta.b EventCode
	ldy.b #$2F
	lda.b (InstPtr),y
	sta.w TrackBendRange,x
	stz.w TrackBend,x
	lda.w SoundMono
	bne .t1
	ldy.b #$12
	lda.b (InstPtr),y
	sta.w TrackVolL+$10
	iny
	lda.b (InstPtr),y
	bra .1

.t1:								; mono sound: other volume byte of the instrument
	ldy.b #$17
	lda.b (InstPtr),y
	sta.w TrackVolL+$10
.1:									; right volume of the effect track
	sta.w TrackVolR+$10
	lda.b SfxVelocity+1
	sta.b EventData1
	ldy.b #$10
	jsr.w StartSoundVoice
	and.b #$FF
	sep #$20
	inc.w SoundLock
	plp
	plb
	ply
	plx
	rtl

.stop:								; unused: release the voices playing sound A
	phx
	phy
	phb
	php
	sep #$30
	dec.w SoundLock
	pha
	lda.b SoundBank
	pha
	plb
	pla
	asl a
	tay
	rep #$20
	lda.b [SoundTable],y
	clc
	adc.b SoundTable
	sta.b InstPtr
	ldx.b #$00
	txy
.2:									; each voice
	lda.w VoiceInst,x
	cmp.b InstPtr
	bne .t1xx
	jsr.w ReleaseVoice
	bra .3

.t1xx:								; next voice
	inx
	inx
	iny
	cpy.b #$08
	bne .2
.3:									; done
	sep #$20
	inc.w SoundLock
	plp
	plb
	ply
	plx
	rtl
