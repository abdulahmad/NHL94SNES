; sound driver command $05 (key off voice X), X in APUIO1
SPCKeyOff:							; entry point, no direct callers found
	sep #$30
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	stx.w APUIO1
	lda.b #$05
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	stz.w APUIO0
	rep #$30
	rtl
