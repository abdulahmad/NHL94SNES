; Send the puck off in a random direction after a deflection
deflect:							; called from puckstick
	lda.w #$FFFF					; puck loose
	sta.w puckc
	jsl.l RandomWord
	and.w #$1FFF
	sec
	sbc.w #$1000
	sta.w puckvy
	jsl.l RandomWord
	and.w #$1FFF
	sec
	sbc.w #$1000
	sta.w puckvx
	jsl.l RandomWord
	and.w #$0FFF
	sta.w puckvz
	jmp.w puckflip
