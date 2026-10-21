; Offsides if the player's team is flagged and the puck is past the blue line.
a2offsides:							; takes a2 = player, called from a2touchpuck
	ldy.b a2						; the player
	lda.w gmode						; game mode
	bit.w #gmoffs					; offsides on
	beq .rtl						; off: none
	lda.w pucky						; puck y
	sta.b d0
	lda.w pfgoal,y					; goal end
	bne .0							; top end
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.0:									; if d0 - blueline negative go to .rtl, ...
	lda.b d0
	cmp.w #blueline
	bmi .rtl
	stz.b a0						; a0 = team offset
	lda.w pfteam,y					; player team
	beq .1
	lda.w #$0002
	sta.b a0
.1:									; if tmflags,y bits tmfoside clear go to .rtl, ...
	ldy.b a0						; team
	lda.w tmflags,y					; team flags
	bit.w #tmfoside					; team flagged offsides
	beq .rtl						; not flagged
	lda.w gmode
	bit.w #gmhl						; gmhl
	bne .rtl						; highlight mode: none
	ldx.b a2						; exg a2,a3
	ldy.b a3
	sty.b a2
	stx.b a3
	lda.w #PenOffsides				; PenOffsides
	sta.b d0
	jsl.l AddPenalty				; AddPenalty
	ldx.b a2						; swap back
	ldy.b a3
	sty.b a2
	stx.b a3
.rtl:								; return
	rtl
