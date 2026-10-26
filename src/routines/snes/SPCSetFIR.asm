; sound driver command $0A (the eight echo filter coefficients), 8 bytes from [p0]
SPCSetFIR:							; entry point, no direct callers found
	sep #$30
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	ldy.b #$00
	lda.b [p0],y
	sta.w APUIO1
	iny
	lda.b [p0],y
	sta.w APUIO2
	iny
	lda.b [p0],y
	sta.w APUIO3
	iny
	lda.b #$0A
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
	ldx.b #$84
	stx.w APUIO0
.ack2:								; loop: if not zero go to .ack2, ...
	cpx.w APUIO0
	bne .ack2
	lda.b [p0],y
	sta.w APUIO1
	iny
	lda.b [p0],y
	sta.w APUIO2
	inx
	stx.w APUIO0
.ack3:								; loop: if not zero go to .ack3, ...
	cpx.w APUIO0
	bne .ack3
	stz.w APUIO0
	rep #$30
	rtl
