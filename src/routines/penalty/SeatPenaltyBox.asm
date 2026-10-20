; Put every player in the penalty box (negative position) at his box spot: Y = PenBoxSpot, X = $88 (the
;
; Skipped during a penalty shot, its set-up and shootouts. Clears PBnum, then walks the 12 players;
; PenBoxSpot counts the ones in the box as it goes. Called from puckfaceoff2 and chkprogress.
; sideline), then assdopen
SeatPenaltyBox:						; puts the box players at their box spots
	lda.w penshot					; penalty shot under way
	ora.w PenShotActive				; penalty shot being set up
	ora.w shootoutmode				; shootout
	bne .rtl						; any of them: leave
	phx								; keep x
	stz.w PBnum						; nobody counted in the boxes yet
	ldx.w #$0000					; x = object 0
.loop:								; loop over the 12 players
	lda.w position,x				; position of the object
	bpl .1							; not negative: not in the box
	jsl.l PenBoxSpot				; spot in the box for him
	lda.b r2						; r2 = the spot
	sta.w Ypos,x					; his y
	lda.w #sideline					; x on the sideline
	sta.w Xpos,x
	jsl.l assdopen					; give him his box assignment
.1:									; next player
	inx								; next object offset
	inx
	cpx.w #$0018					; until all 12 are done
	bcc .loop
	plx								; restore x
.rtl:								; return
	rtl								; return
