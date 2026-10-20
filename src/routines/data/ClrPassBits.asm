; Clear the password bits
;
; Clears the 8 words of passbits. Called from PWtoBits and WritePassBits.
ClrPassBits:						; clear the password bits
	lda.w #$0000					; zero
	sta.l passbits					; 8 words
	sta.l passbits+2
	sta.l passbits+4
	sta.l passbits+6
	sta.l passbits+8
	sta.l passbits+$A
	sta.l passbits+$C
	sta.l passbits+$E
	rtl
