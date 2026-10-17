; A = -1 when the player hit (a2) is the puck carrier on a breakaway (no penalty shot under way): a penalty
; shot instead of the penalty; else 0
PenShotChk:
	lda.w gmode
	bit.w #$0010
	bne .t3
	lda.b a2
	cmp.w puckc
	bne .t3
	lda.w breakaway
	bne .t2
	jmp.w .t3

.t2:
	jsl.l CheckBreakaway
	lda.w IsBreakaway
	sta.w breakaway
	bne .t1
	jmp.w .t3

.t1:
	lda.w #$FFFF
	bra .1

.t3:
	lda.w #$0000
.1:
	rtl
