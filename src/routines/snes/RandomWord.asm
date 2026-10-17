; A = a random word: the sum of two 16-bit shift-register generators ($0792 and $0794, seeded $A5A5 / $B4B4
; when 0)
RandomWord:
	lda.w seed
	beq .3
	asl a
	bcc .1
	eor.w #$1D87
.1:
	sta.w seed
	lda.w seed+2
	beq .4
	asl a
	bcc .2
	eor.w #$1D87
.2:
	sta.w seed+2
	clc
	adc.w seed
	rtl
.3:
	lda.w #$A5A5
	bra .1
.4:
	lda.w #$B4B4
	bra .2

.t1:
	rtl
