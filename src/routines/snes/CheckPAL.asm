; Set the frame time step for a 50 Hz (PAL) console
CheckPAL:							; called from IntroSequence, Opening, Restart
	lda.w #$0000
	sta.l vcountstep
	lda.w STAT78
	bit.w #$0010
	beq .rtl
	lda.w #$3333
	sta.l vcountstep
.rtl:								; return
	rtl
