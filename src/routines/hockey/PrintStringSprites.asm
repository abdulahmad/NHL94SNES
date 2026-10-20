; Draw string a1 as letter sprites at X / Y (the PrintTeamSprites letter loop)
PrintStringSprites:					; called from PrintCopyright, RollCredits
	phb
	phk								; data bank = program bank
	plb
	stx.w letterx
	sty.w lettery
	stz.b r3
	lda.w #$0001
	sta.b r3+2
	lda.b a1
	sta.b d1
	lda.w #$FFFF
	sta.b a2
	sta.b a2+2
	pha
	sep #$30
	lda.b a1+2
	pha
	plb
	rep #$30
	ldy.w #$0000
	bra PrintTeamSprites_go
