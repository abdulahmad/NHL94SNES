; Start the puck spinning
puckflip:
	lda.b d0						; spin direction bit
	and.w #$0001					; facedir of the puck ^= d0 bit 0, & 3
	sta.b d0
	eor.w facedir+puckobj			; flip the puck direction
	and.w #$0003
	sta.w facedir+puckobj			; keep 2 bits
	lda.w #$FFFF					; SPAcnt = -1
	sta.w SPAcnt+puckobj
	phx
	ldx.w #$001C
	lda.w #SPApflip
	jsl.l SetSPAFromA
	plx
	rtl
