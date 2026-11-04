; Blank the password
ResetPassWord:						; no input; PassWord is filled
	sep #$30						; 8-bit registers
	lda.b #$00
	sta.l PassWord					; first byte 0
	ldx.b #$0F						; bytes 1 to 15
	lda.b #$1E						; the blank character
.loop:								; store the blank
	sta.l PassWord,x
	dex								; down to byte 1
	bne .loop						; loop
	rep #$30						; 16-bit registers
	rtl
