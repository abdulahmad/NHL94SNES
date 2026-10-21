; End the player's current assignment and go back to the one under it
assexit:							; called from assbench, assbreakaway, assdumpin, asseben, assepen and 8...
	lda.w assnum,x					; current assignment number
	inc a							; next assignment
	and.w #$0007					; wrap around the 8 slots
	sta.w assnum,x
	phx
	phy
	txa
	asl a
	asl a
	adc.w assnum,x
	tay
	lda.w asslist,y
	and.w #$00FF
	ply
	plx
	sta.w asscur,x
	lda.w pflags,x
	ora.w #pfna						; pfna
	sta.w pflags,x					; store the flags
	rtl
