; Copy X bytes from [p0] to [p1]
MemCopy:							; called from Pausemode, PlayoffScreen, ScrollDisplayUp, SetTeamColors...
	txa
	txy
	lsr a
	bcc .1
	dey
	sep #$20
	lda.b [p0],y
	sta.b [p1],y
	rep #$20
.1:									; Y - 1, Y - 1
	dey
	dey
.loop:								; loop: [p1],y = [p0],y, Y - 1, Y - 1, ...
	lda.b [p0],y
	sta.b [p1],y
	dey
	dey
	bne .loop
	lda.b [p0]
	sta.b [p1]
	rtl
