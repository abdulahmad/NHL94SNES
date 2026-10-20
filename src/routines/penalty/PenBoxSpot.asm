; $08 = the penalty box y spot for player X: +-11 by team times (his team's players in the box (PBnum nibble,
; at most 2) + 3)
;
; x = player object; returns the spot in A. PBnum has the home count in its high nibble and the
; visitors' in its low nibble; the count is limited to 2 and 3 is added.
; Called from asspenalty and SeatPenaltyBox.
PenBoxSpot:							; y spot in the penalty box -> A
	lda.w #$000B					; d0 = 11 (visitors)
	sta.b d0
	lda.w PBnum						; players in the boxes
	sta.b d1
	lda.w pfteam,x					; team of the player
	bne .1							; visitors: keep
	lda.b d1						; home: count is in the high nibble
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1						; d1 = home count
	lda.w #$FFF5					; d0 = -11
	sta.b d0
.1:									; count of his team
	lda.b d1
	and.w #$000F					; low nibble only
	sta.b d1
	cmp.w #$0003					; more than 2?
	bcc .2							; no: keep
	lda.w #$0002					; at most 2
	sta.b d1
.2:									; spot index = count + 3
	inc.b d1
	inc.b d1
	inc.b d1
	phx								; keep x
	lda.b d0						; d0 = +-11
	ldx.b d1						; x = count + 3
	jsl.l Mul16S					; signed multiply
	plx								; restore x
	rtl								; return
