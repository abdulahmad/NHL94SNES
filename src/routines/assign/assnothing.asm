; A computer player stands still
; Takes: X = player object. Called through asstab and jumped to by the assignments asscentero, asscenterd,
; asswingo, asswingd, asspuckc, assbreakaway and assnearest when the clock is stopped.
; A computer player (negative playerpad) gets doplayeracc with d0 = 8 (no stick input); a human is left alone.
assnothing:							; computer player stands still
	lda.w playerpad,x
	bpl .t1							; human: leave him
	lda.w #$0008
	sta.b d0						; d0 = 8
	jml.l doplayeracc

.t1:								; return
	rtl
