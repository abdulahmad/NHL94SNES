; Start the puck spinning
;
; Takes d0 (bit 0 = spin direction). Flips the puck facing, sets SPAcnt to -1 and starts the
; puck flip animation on the puck object.
;
; Called from assdumpin, puckbody and wallcoll.
puckflip:							; spin the puck, facing from d0 bit 0
	lda.b d0						; spin direction bit
	and.w #$0001					; facedir of the puck ^= d0 bit 0, & 3
	sta.b d0
	eor.w facedir+puckscnum			; flip the puck direction
	and.w #$0003
	sta.w facedir+puckscnum			; keep 2 bits
	lda.w #$FFFF					; SPAcnt = -1
	sta.w SPAcnt+puckscnum
	phx
	ldx.w #$001C
	lda.w #SPApflip
	jsl.l SetSPAFromA				; start sprite animation A on object X
	plx
	rtl
