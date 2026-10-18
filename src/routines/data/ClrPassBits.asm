; Clear the password bits
ClrPassBits:
	lda.w #$0000
	sta.l passbits
	sta.l passbits+2
	sta.l passbits+4
	sta.l passbits+6
	sta.l passbits+8
	sta.l passbits+$A
	sta.l passbits+$C
	sta.l passbits+$E
	rtl
