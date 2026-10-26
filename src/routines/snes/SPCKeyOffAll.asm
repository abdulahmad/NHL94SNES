; sound driver command $0D (key off every voice)
SPCKeyOffAll:							; called from SeqCmd08Init
	sep #$20
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	lda.b #$0D
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	stz.w APUIO0
	rep #$20
	rtl
