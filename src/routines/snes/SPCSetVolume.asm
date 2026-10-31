; sound driver command $0E (volume of voice X), X in APUIO1, A in APUIO2, Y in APUIO3
SPCSetVolume:						; entry point, no direct callers found
	sep #$30
	pha
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	pla
	sty.w APUIO3
	sta.w APUIO2
	stx.w APUIO1
	lda.b #$0E
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	stz.w APUIO0
	rep #$30
	rtl
