; Put every player in the penalty box (negative position) at his box spot: Y = PenBoxSpot, X = $88 (the
; sideline), then assdopen
SeatPenaltyBox:
	lda.w penshot
	ora.w PenShotActive
	ora.w shootoutmode
	bne .rtl
	phx
	stz.w PBnum
	ldx.w #$0000
.loop:
	lda.w position,x
	bpl .1
	jsl.l PenBoxSpot
	lda.b r2
	sta.w Ypos,x
	lda.w #sideline
	sta.w Xpos,x
	jsl.l assdopen
.1:
	inx
	inx
	cpx.w #$0018
	bcc .loop
	plx
.rtl:
	rtl
