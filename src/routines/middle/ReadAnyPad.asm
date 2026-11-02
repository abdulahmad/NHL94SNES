; d1 = the buttons that changed on any pad
ReadAnyPad:							; called from Opening, PasswordScreen, StartHL2, setoptions
	lda.w padchangeany
	sta.b d1
	rtl
