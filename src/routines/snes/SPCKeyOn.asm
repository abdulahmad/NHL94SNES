; sound driver command $06 (key on voice X at pitch Y), Y in APUIO2-APUIO3, X in APUIO1
SPCKeyOn:							; entry point, no direct callers found
	sty.w APUIO2
	sep #$30
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	stx.w APUIO1
	lda.b #$06
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	stz.w APUIO0
	rep #$30
	rtl
