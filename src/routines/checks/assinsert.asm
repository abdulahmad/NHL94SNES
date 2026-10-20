; Give player X assignment d0 on top of the current one.
assinsert:							; X = player, d0 = assignment: add it as the newest of the 8 slots
	lda.w assnum,x					; assnum - 1
	dec a							; one slot back
	and.w #$0007					; wrap around the 8 slots
	sta.w assnum,x
assreplace:							; X = player, d0 = assignment: overwrite the current slot, set pfna
	lda.w pflags,x
	ora.w #pfna
	sta.w pflags,x
	txa
	asl a
	asl a
	adc.w assnum,x
	tay
	sep #$20
	lda.b d0
	sta.w asslist,y
	rep #$30
	sta.w asscur,x
	rtl
