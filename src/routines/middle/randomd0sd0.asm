; randomd0s with the range in d0
randomd0sd0:						; called from doshot
	lda.b d0
	asl a
	jsl.l randoma
	sec
	sbc.b d0
	sta.b d0
	clc
	rtl
