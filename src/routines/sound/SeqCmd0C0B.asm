; Sequencer: sound driver command $0C, then $0B
SeqCmd0C0B:							; called from UpdateSfxVoices
	lda.w APUIO0
	bne SeqCmd0C0B
	lda.b DSPGain
	sta.w APUIO2
	sty.w APUIO1
	lda.b #$0C
	sta.w APUIO0
.loop:								; loop: if not zero go to .loop, ...
	cmp.w APUIO0
	bne .loop
	stz.w APUIO0
SeqCmd0B:							; called from UpdateSfxVoices
	lda.w APUIO0
	bne SeqCmd0B
	rep #$20
	lda.b SendPitch
	sta.w APUIO2
	sep #$20
	sty.w APUIO1
	lda.b #$0B
	sta.w APUIO0
.loop:								; loop: if not zero go to .loop, ...
	cmp.w APUIO0
	bne .loop
	stz.w APUIO0
	rts
