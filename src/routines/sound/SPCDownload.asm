; sound driver command $11 (read sound RAM back): X bytes from sound RAM address Y to [p0]
SPCDownload:						; entry point, no direct callers found
	sep #$20
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	sty.w APUIO2
	lda.b #$11
	sta.w APUIO0
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	stx.w APUIO2
	lda.b #$86
	sta.w APUIO0
.ack2:								; loop: if not zero go to .ack2, ...
	cmp.w APUIO0
	bne .ack2
	lda.b #$87
	sta.w APUIO0
	lda.b #$00
	sta.w APUIO1
	ldy.w #$0000
.loop:								; loop: falls through
	tya
.waitbyte:							; loop: if zero go to .waitbyte, ...
	cmp.w APUIO1
	beq .waitbyte
	lda.w APUIO2
	sta.b [p0],y
	iny
	tya
	sta.w APUIO1
	dex
	bne .loop
	stz.w APUIO0
	rep #$20
	rtl
