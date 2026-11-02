; sound driver command $10: send the next block of the stream; returns the bytes still left
SPCStreamNext:						; called from UpdateStreamSfx
	lda.l SPCStreamPtr
	sta.b StreamSrc
	lda.l SPCStreamPtr+2
	sta.b StreamSrc+2
	lda.w STAT78
	bit.w #$0010
	beq .small
.big:								; if SPCStreamLeft < $008B go to .last, ...
	lda.l SPCStreamLeft
	cmp.w #$008B
	bcc .last
	sbc.w #$008A
	sta.l SPCStreamLeft
	ldx.w #$008A
	bra .send
.small:								; STAT78 bits $0010 clear: if SPCStreamLeft < $0074 go to .last, ...
	lda.l SPCStreamLeft
	cmp.w #$0074
	bcc .last
	sbc.w #$0073
	sta.l SPCStreamLeft
	ldx.w #$0073
	bra .send
.last:								; SPCStreamLeft = $0000
	tax
	lda.w #$0000
	sta.l SPCStreamLeft
.send:								; falls through
	ldy.w #$0000
	sep #$20
.wait:								; loop: if APUIO0 != 0 go to .wait, ...
	lda.w APUIO0
	bne .wait
	lda.b #$10
	sta.w APUIO0
	stz.w APUIO1
.ack:								; loop: if not zero go to .ack
	cmp.w APUIO0
	bne .ack
.loop:								; loop: APUIO2 = [StreamSrc],y, Y + 1
	lda.b [StreamSrc],y
	sta.w APUIO2
	iny
	tya
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
	lda.l SPCStreamLeft
	rtl
