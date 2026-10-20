; A = the y scroll of title path step A
TitlePathY:							; A = step, returns A = y scroll; called from BuildTitlePath
	phx								; keep x and y
	phy
	tax								; x = step
	lda.w #$0050					; times $50
	jsl.l Mul16x8XS
	lda.b r2+1						; product / 256
	sta.b r2
	lda.w #$0005					; divided by 5
	sta.b r1
	jsl.l Div16S
	lda.w #$01B0					; y = $01B0 minus the quotient
	sec
	sbc.b r0
	ply								; restore y and x
	plx
	rts
