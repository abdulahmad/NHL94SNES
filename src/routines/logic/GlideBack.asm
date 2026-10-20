; Start SPAglideback on player X unless his animation is locked (pfalock)
GlideBack:							; called from assbreakaway, assnearest, asspuckc
	lda.w pfalock,x
	bne .rtl
	lda.w #SPAglideback
	jsl.l SetSPAFromA
.rtl:								; return
	rtl
