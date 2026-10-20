; Turn the password bits into the password characters
BitstoPW:							; called from EncodePW
	ldx.w #$000F
.char:								; loop: d0 = PWrange, call SuperDiv, PassWord,x = d0, ...
	lda.w #PWrange
	sta.b d0
	jsl.l SuperDiv
	sep #$20
	lda.b d0
	sta.l PassWord,x
	rep #$30
	dex
	bpl .char
	rtl
