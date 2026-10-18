; Store which player a pad marker belongs to
setpads:
	txa
	lsr a
	ldy.b d4
	sta.w PadControlObj,y
	rtl
