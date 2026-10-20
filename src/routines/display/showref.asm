; Referee graphics: only clears the referee flag here
showref:							; called from setvideo
	lda.w #sf2refref
	trb.w sflags
	rtl
