; Read pad A: d0 = direction, d1 = new presses, d2 = changed buttons, d3 = buttons held
ReadjoyA:							; called from getpzjoy, SelectPauseController, demoread, waitxsr
	phx
	asl a
	tax
	lda.w PadRaw1,x
	sta.b d3
	lda.w padchange,x
	sta.b d2
	lda.w padnew1,x
	sta.b d1
	lda.w paddir,x
	sta.b d0
	plx
	rtl
