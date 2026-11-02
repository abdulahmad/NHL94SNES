; sound driver command $0F: start streaming a sample of X bytes from [$3E], loop point Y; sends the first
; block
SPCStreamStart:						; called from UpdateStreamSfx
	lda.w STAT78
	bit.w #$007E
	beq .small
	txa
	sec
	sbc.w #$008A
	sta.l SPCStreamLeft
	ldx.w #$008A
	bra .send
.small:								; STAT78 bits $007E clear: SPCStreamLeft = X - $0073
	txa
	sec
	sbc.w #$0073
	sta.l SPCStreamLeft
	ldx.w #$0073
.send:								; falls through
	sep #$20
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	sty.w APUIO2
	lda.b #$0F
	sta.w APUIO0
	stz.w APUIO1
.ack:								; loop: if not zero go to .ack, ...
	cmp.w APUIO0
	bne .ack
	ldy.w #$0000
.loop:								; loop: APUIO2 = [StreamSrc],y, Y + 1, APUIO1 = Y
	lda.b [StreamSrc],y
	sta.w APUIO2
	iny
	tya
	sta.w APUIO1
.ackbyte:							; loop: if not zero go to .ackbyte, ...
	cmp.w APUIO1
	bne .ackbyte
	nop
	nop
	nop
	dex
	bne .loop
	stz.w APUIO0
	rep #$20
	tya
	clc
	adc.b StreamSrc
	sta.l SPCStreamPtr
	lda.b StreamSrc+2
	sta.l SPCStreamPtr+2
	rtl
