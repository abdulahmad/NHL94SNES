; Turn the password bits into the password characters
BitstoPW:							; called from EncodePW
	ldx.w #$000F					; 16 characters
.char:								; loop: d0 = PWrange, call SuperDiv, PassWord,x = d0, ...
	lda.w #PWrange					; PassWord[x] = passbits mod PWrange
	sta.b d0
	jsl.l SuperDiv					; divide the bits by it
	sep #$20						; 8-bit A
	lda.b d0						; remainder
	sta.l PassWord,x
	rep #$30						; 16-bit registers
	dex								; next character
	bpl .char
	rtl
