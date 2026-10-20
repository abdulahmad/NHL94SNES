; sound driver command $0C (GAIN Y of voice X (gain mode)), Y in APUIO2, X in APUIO1
SPCCmd0C:							; entry point, no direct callers found
	sep #$30
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	sty.w APUIO2
	stx.w APUIO1
	lda.b #$0C
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	stz.w APUIO0
	rep #$30
	rtl
