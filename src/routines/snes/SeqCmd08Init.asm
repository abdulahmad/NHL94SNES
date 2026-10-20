; Sequencer: clear the command $08 values, then send command $08
SeqCmd08Init:						; called from SoundInit
	jsl.l SPCCmd0D
	sep #$30
	lda.b #$00
	sta.w PitchModVoices
	sta.w NoiseVoices
	sta.w EchoVoices
	sta.w EchoDelay
	sta.w EchoVolume
	sta.w EchoFeedback
SeqCmd08Init_send:					; called from SoundUpdate, StepTrack
	lda.w APUIO0
	bne SeqCmd08Init_send
	lda.w SoundVolume+1
	sta.w APUIO1
	sta.w APUIO2
	lda.l $0007E9
	sta.w APUIO3
	lda.b #$08
	sta.w APUIO0
.loop:								; loop: if not zero go to .loop, ...
	cmp.w APUIO0
	bne .loop
	lda.l $0007E8
	sta.w APUIO1
	lda.l $0007E7
	sta.w APUIO2
	ldx.b #$82
	stx.w APUIO0
.loop2:								; loop: if not zero go to .loop2, ...
	cpx.w APUIO0
	bne .loop2
	stz.w APUIO0
	rts
