; randomd0s with the range in d0
randomd0sd0:						; called from doshot
	lda.b d0
	asl a							; times 2
	jsl.l randoma					; A = a random number from 0 to A-1
	sec
	sbc.b d0						; minus A: -A to A-1
	sta.b d0
	clc
	rtl
