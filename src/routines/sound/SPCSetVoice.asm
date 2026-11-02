; sound driver command $07 (voice X: volume left / right, sample, ADSR1, ADSR2), X and 5 bytes from [p0]
SPCSetVoice:						; entry point, no direct callers found
	sep #$30
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	stx.w APUIO1
	ldy.b #$00
	lda.b [p0],y
	sta.w APUIO2
	iny
	lda.b [p0],y
	sta.w APUIO3
	iny
	lda.b #$07
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	lda.b [p0],y
	sta.w APUIO1
	iny
	lda.b [p0],y
	sta.w APUIO2
	iny
	lda.b [p0],y
	sta.w APUIO3
	ldx.b #$81
	stx.w APUIO0
.ack2:								; loop: if not zero go to .ack2, ...
	cpx.w APUIO0
	bne .ack2
	stz.w APUIO0
	rep #$30
	rtl
