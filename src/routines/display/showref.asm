; Referee graphics: only clears the referee flag here
showref:
	lda.w #sf2refref
	trb.w sflags
	rtl
