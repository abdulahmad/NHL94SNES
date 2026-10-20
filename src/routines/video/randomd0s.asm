; A = a random number from -A to A-1
randomd0s:							; called from asscentero, assdumpin, asswingo, dopass_count, doshot
	sta.b r3
	asl a
	jsl.l randoma
	sec
	sbc.b r3
	clc
	rtl
