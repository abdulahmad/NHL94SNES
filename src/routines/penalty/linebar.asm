; Draw the energy bar of line d0
linebar:							; called from SetLCmode2
	jsl.l getlinee
	lda.w printa
	pha
	phx
	lda.w #$3000
	sta.w printa
	lda.b d0
	cmp.w #$1000
	bcc .1
	lda.w #$1000
.1:									; d0 = A, call Mul16x8U, mesarea+2 = r2+2 + $001D, ...
	sta.b d0
	tax
	lda.w #$002F
	jsl.l Mul16x8U
	lda.b r2+2
	clc
	adc.w #$001D
	sta.w mesarea+2
	sta.w mesarea+3
	sta.w mesarea+4
	sta.w mesarea+5
	sta.w mesarea+6
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	ldx.b d0
	lda.w #$0054
	jsl.l Mul16x8U
	plx
	lda.b r2+2
	inc a
	inc a
	sta.b [a1]
	jsl.l print
	pla
	sta.w printa
org $9FE000
	rtl
