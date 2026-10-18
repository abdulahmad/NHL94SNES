; Lock the view at its current position
freezewindow:
	lda.w Vpos
	sta.w yc1
	lda.w Hpos
	sta.w xc1
	lda.w #sfslock
	tsb.w sflags
	rtl
