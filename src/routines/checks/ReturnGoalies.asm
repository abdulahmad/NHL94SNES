; If the computer pulled its goalie, should he come back?
ReturnGoalies:						; tests both teams (a1 / a2 swapped); called from puckfaceoff
	stz.b a2
	lda.w #$0002
	sta.b a1
	jsl.l .1
	stz.b a1
	lda.w #$0002
	sta.b a2
.1:									; subroutine: if tmgoalie,y >= 0 go to .t1
	ldy.b a2
	lda.w tmgoalie,y
	bpl .t1
.2:									; and #$00FF, if carry set go to .t1, ...
	and.w #$00FF
	cmp.w #$000A
	bcs .t1
	sta.w tmgoalie,y
	lda.w teampads,y
	bne .t1
	lda.l foy
	sta.b d1
	jmp.w CPgoalie

.t1:								; goalie not pulled, still too far away, or a pad controls him: return
	rtl
