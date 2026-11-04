; A = a random number from 0 to A-1
randomd0A:							; called from StartHL2, assdumpin, check4check, chk4shot, doshot and 5...
	phx
	pha
	cmp.w #$0100
	bcc randoma8_go
	jsl.l RandomWord
	plx
	jsl.l Mul16U
	plx
	lda.b r2+2
	clc
	rtl
