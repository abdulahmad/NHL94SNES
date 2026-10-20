; Read the pads with key repeat. A held button repeats after a delay
ProcessInputWithRepeat:				; called from EditLinesMenu, EditLinesScreen, PasswordRedraw, PenaltySu...
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
.rtl:								; return
	rtl

.t1:								; d2 != 0: repeatdelay = $0014, return
	lda.w #$0014
	sta.w repeatdelay
	rtl
