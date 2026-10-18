; End the player's current assignment and go back to the one under it
assexit:
	lda.w assnum,x
	inc a
	and.w #$0007
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
	ora.w #pfna
	sta.w pflags,x
	rtl
