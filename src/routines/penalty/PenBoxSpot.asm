; $08 = the penalty box y spot for player X: +-11 by team times (his team's players in the box (PBnum nibble,
; at most 2) + 3)
PenBoxSpot:
	lda.w #$000B
	sta.b d0
	lda.w PBnum
	sta.b d1
	lda.w pfteam,x
	bne .1
	lda.b d1
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1
	lda.w #$FFF5
	sta.b d0
.1:
	lda.b d1
	and.w #$000F
	sta.b d1
	cmp.w #$0003
	bcc .2
	lda.w #$0002
	sta.b d1
.2:
	inc.b d1
	inc.b d1
	inc.b d1
	phx
	lda.b d0
	ldx.b d1
	jsl.l Mul16S
	plx
	rtl
