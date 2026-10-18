; Start the puck spinning
puckflip:
	lda.b d0
	and.w #$0001
	sta.b d0
	eor.w facedir+puckobj
	and.w #$0003
	sta.w facedir+puckobj
	lda.w #$FFFF
	sta.w SPAcnt+puckobj
	phx
	ldx.w #$001C
	lda.w #SPApflip
	jsl.l SetSPAFromA
	plx
	rtl
