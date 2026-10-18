; The next line of the scouting report; scroll the text box up when it is full
ScrollDisplayUp:
	stz.w DispAttribCtr
	inc.w VertLineScrolling
	lda.w VertLineScrolling
	sec
	sbc.w #$0008
	bmi .2
	bvc .3
.1:
	jmp.w UpdateScoutingDisplay_rtl
.2:
	bvc .1
.3:
	dec.w VertLineScrolling
	lda.w #$0007
	sta.b r3
	lda.w #$007E
	sta.b p1+2
	lda.w #$3B78
	sta.b p1
	lda.b p1+2
	sta.b p0+2
.loop:
	ldx.w #$0028
	lda.b p1
	clc
	adc.w #$0040
	sta.b p0
	jsl.l MemCopy
	lda.b p0
	sta.b p1
	dec.b r3
	bpl .loop
	rtl
