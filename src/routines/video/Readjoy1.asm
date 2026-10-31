; Read pad 1: d0 = direction, d1 = new presses, d2 = changed buttons, d3 = buttons held
ReadJoy1:							; called from BadPasswordPrompt, PasswordRedraw, demoread, setoptions
	lda.w PadRaw1
	sta.b d3
	lda.w padchange
	sta.b d2
	lda.w padnew
	sta.b d1
	lda.w paddir
	sta.b d0
	rtl

.t1:								; d3 = PadRaw2, d2 = padchange+2, d1 = padnew+2, ...
	lda.w PadRaw2
	sta.b d3
	lda.w padchange+2
	sta.b d2
	lda.w padnew+2
	sta.b d1
	lda.w paddir+2
	sta.b d0
	rtl
