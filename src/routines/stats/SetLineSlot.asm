; Put player lineplayer in the cursor slot of the selected line; if he is already in another slot of that
; line, the old occupant moves there (swap)
; Takes A = player (kept in lineplayer). d0 is set to the first slot of the selected line (GetTeamLines + 8 *
; (SelectedPlayerIdx - 1) + 1). Depending on how far the cursor row is from the end of the line (lineslots -
; linecursor) the neighbouring slots are searched for the same player, who then is swapped into the cursor
; slot, and the player is written to the cursor slot with WriteLineSlot.
;
; Called from EditLinesScreen.
SetLineSlot:						; put a player in the cursor slot of the line
	sta.w lineplayer				;keep the player
	lda.w SelectedPlayerIdx			;selected line
	dec a							;0-based
	asl a
	asl a
	asl a							;8 slots per line
	sta.b d0						;line offset
	jsl.l GetTeamLines				;team line table
	sec
	adc.b d0						;plus the line offset + 1
	sta.b d0						;first slot of the line
	lda.w lineslots					;slots in the line
	sec
	sbc.w linecursor				;minus the cursor row
	cmp.w #$0001					;1?
	beq .2							;1 from the end
	cmp.w #$0002					;2?
	beq .t4							;2 from the end
	cmp.w #$0003					;3?
	beq .t3							;3 from the end
	cmp.w #$0004					;4?
	beq .t2							;4 from the end
	lda.b d0						;line start
	inc a
	inc a							;third slot
	sta.b a3						;slot to check
	jsr.w ReadLineSlot				;read it
	cmp.w lineplayer				;the player?
	bne .t1							;not there: check the fourth slot
	jsr.w SwapLineSlots				;swap the slots
	bra .4							;write the player

.t1:								; compare the slot after the next
	lda.b d0						;line start
	inc a
	inc a
	inc a							;fourth slot
	bra .1							;check it

.t2:								; cursor 4 rows from the end
	lda.b d0						;line start
	clc
	adc.w #$0004					;fifth slot
	sta.b a3						;slot to check
	jsr.w ReadLineSlot				;read it
	cmp.w lineplayer				;the player?
	bne .t1x						;not there: check the third slot
	dec.b a3						;the slot before
	jsr.w .5						;swap the fourth and fifth slots
	bra .4							;write the player

.t1x:								; compare the third slot
	lda.b d0						;line start
	inc a
	inc a							;third slot
	bra .1							;check it

.t3:								; cursor 3 rows from the end
	lda.b d0						;line start
	clc
	adc.w #$0004					;fifth slot
	sta.b a3						;slot to check
	jsr.w ReadLineSlot				;read it
	cmp.w lineplayer				;the player?
	bne .t1x2						;not there: check the fourth slot
	jsr.w SwapLineSlots				;swap the slots
	bra .4							;write the player

.t1x2:								; compare the fourth slot
	lda.b d0
	inc a							;line start
	inc a
	inc a							;fourth slot
	bra .3							;check it

.t4:								; cursor 2 rows from the end
	lda.b d0						;first slot
.1:									; compare slot a3 with the player
	sta.b a3						;slot to check
	jsr.w ReadLineSlot				;read it
	cmp.w lineplayer				;the player?
	bne .4							;not there: just write
	jsr.w .5						;swap the slot with the next
	bra .4
.2:									; cursor 1 row from the end
	lda.b d0						;line start
	inc a							;second slot
.3:									; compare slot a3 with the player
	sta.b a3						;slot to check
	jsr.w ReadLineSlot				;read it
	cmp.w lineplayer				;the player?
	bne .4							;not there: just write
	dec.b a3						;the slot before
	jsr.w .5						;swap them
.4:									; write the player to the cursor slot
	lda.b d0						;line start
	clc
	adc.w lineslots					;plus the slot count
	sbc.w linecursor				;minus the cursor row (carry clear: one less)
	sta.b a3						;cursor slot
	lda.w lineplayer				;the player
	jsr.w WriteLineSlot				;write it
	rts
.5:									; swap the slots a3 and a3+1
	jsr.w ReadLineSlot				;first slot's player
	sta.w lineswap					;keep it
	inc.b a3						;slot a3+1
	jsr.w ReadLineSlot				;second slot's player
	dec.b a3						;back to slot a3
	jsr.w WriteLineSlot				;into slot a3
	inc.b a3						;slot a3+1
	lda.w lineswap					;first slot's player
	jsr.w WriteLineSlot				;into slot a3+1
	dec.b a3						;back to slot a3
	rts
