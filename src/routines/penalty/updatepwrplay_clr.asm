; Power play over: put the EASN logo back
updatepwrplay_clr:					; called from updatepwrplay
	lda.w #sf2pwrplay
	trb.w sflags
	beq .rtl
	jsl.l EASNLogo
.rtl:								; return
	rtl
