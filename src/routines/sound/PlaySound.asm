; Play sound A at once on the sound effect voices (the QueueSound set up without the replay record or the
; already-playing test)
PlaySound:
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
PlaySoundEntry:
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

.t1:
	ldy.b #$17
	lda.b (InstPtr),y
	sta.w TrackVolL+$10
.1:
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
.2:
	lda.w VoiceInst,x
	cmp.b InstPtr
	bne .t1xx
	jsr.w ReleaseVoice
	bra .3

.t1xx:
	inx
	inx
	iny
	cpy.b #$08
	bne .2
.3:
	sep #$20
	inc.w SoundLock
	plp
	plb
	ply
	plx
	rtl
