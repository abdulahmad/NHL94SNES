; sound driver command $04 (drop the last uploaded sample)
SPCCmd04:							; called from SPCTitleToMenu, UpdateStreamSfx
	sep #$20
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	lda.b #$04
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	stz.w APUIO0
	rep #$20
	rtl
