; Power play over: put the EASN logo back
updatepwrplay_clr:					; called from updatepwrplay
	lda.w #sf2pwrplay
	trb.w sflags					; clear the power play flag
	beq .rtl						; it was not set: nothing to do
	jsl.l EASNLogo					; draw the logo
.rtl:								; return
	rtl
