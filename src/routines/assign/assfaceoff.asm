; Assignment: players wait until the face off is over
assfaceoff:
	lda.w pfalock,x
	bne .t4
	lda.w sflags
	bit.w #$0100
	bne .t4
	jml.l assexit
.t4:
	rtl
