; Center the string in a1 and print it.
PrintCentered:
	jsl.l .t1
	jsl.l print
	rtl

.t1:
	lda.b [a1]
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx
	rtl
