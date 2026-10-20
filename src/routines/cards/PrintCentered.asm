; Center the string in a1 and print it.
; Takes: a1 = the string (first word is its length). Sets printx so that the string is centred on
; column 16, then prints it. Called from PrintMP5Line2 and PrintMP5Line4 (by branch).
PrintCentered:						; print a string centred on column 16
	jsl.l .t1						; compute printx
	jsl.l print						; print it
	rtl

.t1:								; printx = 16 - (length - 2) / 2
	lda.b [a1]						; string length - 2, halved
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx					; store it
	rtl
