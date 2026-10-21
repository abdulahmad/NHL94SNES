; Put player lineplayer in the cursor slot of the selected line; if he is already in another slot of that
; line, the old occupant moves there (swap)
; Takes A = player (kept in lineplayer). d0 is set to the first slot of the selected line (GetTeamLines + 8 *
; (SelectedPlayerIdx - 1) + 1). Depending on how far the cursor row is from the end of the line (lineslots -
; linecursor) the neighbouring slots are searched for the same player, who then is swapped into the cursor
; slot, and the player is written to the cursor slot with WriteLineSlot.
;
; Called from EditLinesScreen.
SetLineSlot:						; put a player in the cursor slot of the line
	sta.w lineplayer
	lda.w SelectedPlayerIdx
	dec a
	asl a
	asl a
	asl a
	sta.b d0
	jsl.l GetTeamLines
	sec
	adc.b d0
	sta.b d0
	lda.w lineslots
	sec
	sbc.w linecursor
	cmp.w #$0001
	beq .2
	cmp.w #$0002
	beq .t4
	cmp.w #$0003
	beq .t3
	cmp.w #$0004
	beq .t2
	lda.b d0
	inc a
	inc a
	sta.b a3
	jsr.w ReadLineSlot
	cmp.w lineplayer
	bne .t1
	jsr.w SwapLineSlots
	bra .4

.t1:								; compare the slot after the next
	lda.b d0
	inc a
	inc a
	inc a
	bra .1

.t2:								; cursor 4 rows from the end
	lda.b d0
	clc
	adc.w #$0004
	sta.b a3
	jsr.w ReadLineSlot
	cmp.w lineplayer
	bne .t1x
	dec.b a3
	jsr.w .5
	bra .4

.t1x:								; compare the third slot
	lda.b d0
	inc a
	inc a
	bra .1

.t3:								; cursor 3 rows from the end
	lda.b d0
	clc
	adc.w #$0004
	sta.b a3
	jsr.w ReadLineSlot
	cmp.w lineplayer
	bne .t1x2
	jsr.w SwapLineSlots
	bra .4

.t1x2:								; compare the fourth slot
	lda.b d0
	inc a
	inc a
	inc a
	bra .3

.t4:								; cursor 2 rows from the end
	lda.b d0
.1:									; compare slot a3 with the player
	sta.b a3
	jsr.w ReadLineSlot
	cmp.w lineplayer
	bne .4
	jsr.w .5
	bra .4
.2:									; cursor 1 row from the end
	lda.b d0
	inc a
.3:									; compare slot a3 with the player
	sta.b a3
	jsr.w ReadLineSlot
	cmp.w lineplayer
	bne .4
	dec.b a3
	jsr.w .5
.4:									; write the player to the cursor slot
	lda.b d0
	clc
	adc.w lineslots
	sbc.w linecursor
	sta.b a3
	lda.w lineplayer
	jsr.w WriteLineSlot
	rts
.5:									; swap the slots a3 and a3+1
	jsr.w ReadLineSlot
	sta.w lineswap
	inc.b a3
	jsr.w ReadLineSlot
	dec.b a3
	jsr.w WriteLineSlot
	inc.b a3
	lda.w lineswap
	jsr.w WriteLineSlot
	dec.b a3
	rts
