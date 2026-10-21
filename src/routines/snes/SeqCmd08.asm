; Sequencer: sound driver command $08 with the values $07F8, $07E7-$07E9
SeqCmd08:							; called from StepTrack
	php
	sep #$30
.loop:								; loop: if APUIO0 != 0 go to .loop, ...
	lda.w APUIO0
	bne .loop
	ldy.b #$00
	lda.w SoundVolume+1
	sta.w APUIO1
	iny
	lda.w SoundVolume+1
	sta.w APUIO2
	iny
	lda.l PitchModVoices
	sta.w APUIO3
	iny
	lda.b #$08
	sta.w APUIO0
.loop2:								; loop: if not zero go to .loop2, ...
	cmp.w APUIO0
	bne .loop2
	lda.l NoiseVoices
	sta.w APUIO1
	iny
	lda.l EchoVoices
	sta.w APUIO2
	ldx.b #$82
	stx.w APUIO0
.loop3:								; loop: if not zero go to .loop3, ...
	cpx.w APUIO0
	bne .loop3
	stz.w APUIO0
	lda.w EchoVoices
	beq .1
.loop4:								; loop: if APUIO0 != 0 go to .loop4, ...
	lda.w APUIO0
	bne .loop4
	ldy.b #$00
	lda.l EchoVolume
	sta.w APUIO1
	iny
	lda.l EchoVolume
	sta.w APUIO2
	iny
	lda.l EchoFeedback
	sta.w APUIO3
	iny
	lda.b #$09
	sta.w APUIO0
.loop5:								; loop: if not zero go to .loop5, ...
	cmp.w APUIO0
	bne .loop5
	lda.b #$E0
	sta.w APUIO1
	iny
	lda.l EchoDelay
	sta.w APUIO2
	ldx.b #$83
	stx.w APUIO0
.loop6:								; loop: if not zero go to .loop6, ...
	cpx.w APUIO0
	bne .loop6
	stz.w APUIO0
.1:									; return
	rep #$30
	plp
	rts
