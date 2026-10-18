; Read the pads with key repeat. A held button repeats after a delay
ProcessInputWithRepeat:
	lda.b d3
	beq .rtl
	lda.b d2
	bne .t1
	dec.w repeatdelay
	bpl .rtl
	lda.w #$0006
	sta.w repeatdelay
	lda.b d3
	sta.b d1
.rtl:
	rtl

.t1:
	lda.w #$0014
	sta.w repeatdelay
	rtl
