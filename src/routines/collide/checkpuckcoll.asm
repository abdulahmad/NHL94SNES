; Puck collision with the players near it
checkpuckcoll:						; called from pucknorm_move
	lda.w puckz
	sec
	sbc.w #$0010
	bpl .1
	ldy.w OOlistpos+puckobj
.loop:								; loop: d1 = Y, if zero go to .t1, ...
	sty.b d1
	cpy.w #$000F
	beq .t1
	lda.w OOlist+1,y
	and.w #$00FF
	tay
	lda.w Ylist,y					; y of the next higher object
	sec
	sbc.w pucky						; minus the puck's y
	sec
	sbc.w #$0028
	bpl .t1
	jsl.l checkpuckcoll_ccx			; puck contact with a player's stick, body or the goalie
	ldy.b d1
	iny
	bra .loop

.t1:								; if OOlistpos+puckobj = 0 go to .1
	ldy.w OOlistpos+puckobj
	beq .1
.loopx:								; loop: d1 = Y, if plus go to .1, ...
	sty.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	tay
	lda.w pucky						; puck's y
	sec
	sbc.w Ylist,y					; minus the y of the next lower object
	sec
	sbc.w #$0028
	bpl .1
	jsl.l checkpuckcoll_ccx			; puck contact with a player's stick, body or the goalie
	ldy.b d1
	dey
	bne .loopx
.1:									; return
	rtl
