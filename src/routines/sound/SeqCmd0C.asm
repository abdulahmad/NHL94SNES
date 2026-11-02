; Sequencer: sound driver command $0C (A = $5B, Y)
SeqCmd0C:							; called from FindFreeVoice, ReleaseVoice, StopVoice
	lda.w APUIO0
	bne SeqCmd0C
	lda.b DSPGain
	sta.w APUIO2
	sty.w APUIO1
	lda.b #$0C
	sta.w APUIO0
.loop:								; loop: if not zero go to .loop, ...
	cmp.w APUIO0
	bne .loop
	stz.w APUIO0
	rts
