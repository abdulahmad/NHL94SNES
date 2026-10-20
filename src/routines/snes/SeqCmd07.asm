; Sequencer: sound driver command $07 with the instrument data that follows
SeqCmd07:							; called from StartSoundVoice
	lda.w APUIO0
	bne SeqCmd07
	lda.b CurVoice
	sta.w APUIO1
	lda.w VoiceVolL
	sta.w APUIO2
	lda.w VoiceVolR
	sta.w APUIO3
	lda.b #$07
	sta.w APUIO0
.loop:								; loop: if not zero go to .loop, ...
	cmp.w APUIO0
	bne .loop
	ldy.b #$14
	lda.b (InstPtr),y
	sta.w APUIO1
	iny
	lda.b (InstPtr),y
	sta.w APUIO2
	pha
	iny
	lda.b (InstPtr),y
	sta.w APUIO3
	ldx.b #$81
	stx.w APUIO0
.loop2:								; loop: if not zero go to .loop2, ...
	cpx.w APUIO0
	bne .loop2
	stz.w APUIO0
.loop3:								; loop: if APUIO0 != 0 go to .loop3, ...
	lda.w APUIO0
	bne .loop3
	lda.b CurVoice
	sta.w APUIO1
	rep #$20
	lda.b NotePitch
	sta.w APUIO2
	sep #$20
	lda.b #$06
	sta.w APUIO0
.loop4:								; loop: if not zero go to .loop4, ...
	cmp.w APUIO0
	bne .loop4
	stz.w APUIO0
	pla
	bmi .1
.loop5:								; loop: if APUIO0 != 0 go to .loop5, ...
	lda.w APUIO0
	bne .loop5
	lda.b StartGain+1
	sta.w APUIO2
	lda.b #$0C
	sta.w APUIO0
.loop6:								; loop: if not zero go to .loop6, ...
	cmp.w APUIO0
	bne .loop6
	stz.w APUIO0
.1:									; return
	ldy.b CurVoice
	rts
