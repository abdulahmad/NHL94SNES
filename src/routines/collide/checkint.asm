; A goalie and another player collide: the skater falls, and an interference penalty may be called
checkint:							; called from checkplcoll
	jsl.l .ci						; a2 goalie vs X
	ldx.b a2						; swap a2 and a3
	ldy.b a3
	sty.b a2
	stx.b a3
	jsl.l .ci						; and the other way round
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
.rtl:								; return
	rtl
.ci:								;a2 must be a goalie, clock running
	ldy.b a2						; a2
	lda.w position,y				; goalie?
	bne .rtl
	lda.w gmclock					; clock running?
	bne .rtl
	lda.w puckc						; a3 has the puck: skip the impact 26 test
	cmp.b a3
	beq .1
	lda.w impact,x					; impact of X
	sec
	sbc.w #$001A					; minus 26
	bmi .rtl
.1:									; if minus go to .rtl, ...
	lda.w impact,x					; impact of X
	sec
	sbc.w #$0003					; minus 3
	bmi .rtl
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	jsl.l FallDown					; make X fall
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	lda.w impact,y					; impact of a2 > 31
	sec
	sbc.w #$001F					; minus 31
	bmi .rtl
	lda.w pflags,x
	bit.w #$4000
	bne .rtl
	lda.w #$0014
	sec
	sbc.w aggress,x					; 20 minus aggression
	jsl.l randoma8
	cmp.w #$0002
	bcs .rtl
	lda.w gmode						; not in highlights
	bit.w #gmhl						; not in highlights
	bne .rtl
	lda.w goalieflags,y
	and.w #$0004
	bne .rtl
	lda.w #PenInterference			; interference penalty
	sta.b d0
	jmp.w AddPenalty				; call it
