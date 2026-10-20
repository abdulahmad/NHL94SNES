; Penalty box list of team a2: timed players first
;
; a2 = team (0 = team 1 list, else team 2): prints each player in its penalty box, via pplpen.
; Two passes over the box list: first the players with a running penalty clock, then the others.
; Called from printscores1 and updatepwrplay.
DispPen:							; box list display, a2 = team
	lda.b a2
	beq .1							; team 0: list offset 0
	lda.w #$001A					; team 1 list starts at offset $1A
.1:									; list offset chosen
	sta.b a0						; a0 = index into tmboxlist
.loop:								; pass 1: walk the box list
	ldy.b a0
	lda.w tmboxlist,y				; next list entry
	inc.b a0						; a0 advances
	and.w #$00FF					; entry in the low byte
	sta.b d0						; d0 = player
	bit.w #$0080					; bit 7 set = end of list
	bne .t1							; end of list: go to pass 2
	lda.b a2
	beq .2
	lda.w #$0034					; team 1 state table is $34 bytes on
.2:									; state table offset chosen
	clc
	adc.b d0						; add the player: index into tmpdst
	tay
	lda.w tmpdst,y					; player state
	bit.w #$4000					; bit 14: no running penalty clock
	bne .loop						; untimed: skip in this pass
	jsl.l pplpen					; print this player's penalty line
	bra .loop						; next list entry

.t1:								; pass 2: the players with no running clock
	lda.b a2
	beq .1x							; team 0: list offset 0
	lda.w #$001A					; team 1 list starts at offset $1A
.1x:								; list offset chosen
	sta.b a0						; a0 = index into tmboxlist
.loopx:								; walk the box list again
	ldy.b a0
	lda.w tmboxlist,y				; next list entry
	inc.b a0
	and.w #$00FF					; entry in the low byte
	sta.b d0						; d0 = player
	bit.w #$0080					; bit 7 set = end of list
	bne USBoard_rtl					; both passes done: return (rtl of USBoard)
	lda.b a2
	beq .2x
	lda.w #$0034					; team 1 state table is $34 bytes on
.2x:								; state table offset chosen
	clc
	adc.b d0						; add the player: index into tmpdst
	tay
	lda.w tmpdst,y					; player state
	bit.w #$4000					; bit 14: no running penalty clock
	beq .loopx						; timed: already printed in pass 1
	jsl.l pplpen					; untimed: print this player's penalty line
	bra .loopx						; next list entry
