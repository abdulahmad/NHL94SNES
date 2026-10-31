; When and where the puck will cross each goal line
;
; Takes X = player and d4 = pad number. Chooses the player for the pad:
; of the six skaters of the pad team it takes the one closest to the puck (puckdist plus a
; penalty for facing the wrong way) and gives him the pad with AssignPadPlayer, or runs
; Sweepcheck on X. d0-d7 are preserved.
;
; Called from FaceoffPads, doinput and dopass.
findpc:								; choose the player for pad d4
	stx.b xsave						; keep X
	ldx.w #$0000					; save d0 through d4
.loop:								; save d0 and the words after it (10 words)
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loop
	ldx.b xsave						; player X again
	lda.w #$0008					; r0 = 8: no preferred direction
	sta.b r0
	ldy.w puckc						; puck carrier
	bmi .9							; loose puck: .9
	lda.w position,x				; goalie?
	beq .t1							; goalie: .t1
	lda.w playerpad,x				; player with no pad?
	bmi .t1
	lda.w pfalock,x					; locked in an animation?
	bne .t1
	lda.w puckdist2,x				; close to the puck?
	cmp.w #$0064
	bcs .t1
	jmp.w .10						; close: check him directly (.10)

.t1:								; puck carrier: same pad side as X?
	lda.w playerpad,y				; carrier without a pad: .1
	bmi .1
	tay
	lda.w padside,y
	cmp.w padside,x					; same pad side as X: .9
	beq .9
.1:									; direction to prefer from the goal X shoots at
	ldy.w #$0000					; r0 = 0 or 4
	lda.w pfgoal,x
	bne .2
	ldy.w #$0004
.2:									; store the preferred direction
	sty.b r0						; r0 = preferred direction
.9:									; search the six players of the pad team for the best one
	lda.w #$0006					; 6 players
	sta.b d1
	ldy.b d4						; Y = pad number (d4)
	lda.w #$FFFF					; d2 = best cost, none yet
	sta.b d2
	ldx.w #$0000					; first player of team 1
	lda.w cont1team,y				; team of the pad
	cmp.w #$0001
	beq .1x
	ldx.w #$000C					; team 2 players start at $0C
.1x:								; next candidate
	lda.w position,x				; goalies and empty slots are skipped
	bmi .8
	beq .8
	lda.w pflags,x					; flags bit $1000 set: skip
	bit.w #$1000
	bne .8
	lda.w SPA,x						; animation of the candidate
	cmp.w #SPAturnl
	bcc .2x
	cmp.w #$EBE3
	bcc .4
.2x:								; not a turn animation: cross check range?
	cmp.w #SPAcrosscheck
	bcc .3
	cmp.w #$F343
	bcc .4
.3:									; neither: locked or flag $1000 skips him
	lda.w pflags,x
	and.w #$1000
	ora.w pfalock,x
	bne .8
.4:									; candidate already has a pad?
	lda.w playerpad,x				; no pad: fine
	bmi .5
	cmp.b d4						; other pad: skip
	bne .8
.5:									; cost of the candidate
	stz.b r3						; r3 = direction penalty, 0
	lda.w puckc						; loose puck: no penalty
	bmi .7
	lda.b r0
	cmp.w #$0008					; no preferred direction: no penalty
	beq .7
	eor.w puckdir,x					; puck direction against the preferred one
	cmp.w #$0004
	bcc .6
	eor.w #$FFFF
	adc.w #$0008
.6:									; fold to 0-4
	cmp.w #$0000					; same direction: no penalty
	beq .7
	dec a							; penalty = (difference-1)*32
	asl a
	asl a
	asl a
	asl a
	asl a
	clc
	adc.b r3
	sta.b r3
.7:									; cost = distance to the puck plus penalty
	lda.w puckdist,x				; distance to the puck
	clc
	adc.b r3
	bcs .8							; overflow: skip
	cmp.b d2						; not better than the best: skip
	bcs .8
	stx.b d3						; best candidate and cost
	sta.b d2
.8:									; next candidate
	inx
	inx
	dec.b d1						; six candidates done?
	bne .1x
	ldx.b a3						; back to player X
	lda.b d2						; any candidate found?
	cmp.w #$FFFF
	beq .12							; none: done
	ldy.b d4						; current player of the pad
	lda.b d3
	cmp.w c1playernum,y				; is the best one already the pad player?
	bne .11							; no: change over
.10:								; already the pad player: run Sweepcheck for X unless locked
	lda.w pfalock,x					; locked: done
	bne .12							; done
	lda.b d4
	pha								; save d4-d6, a0 and a1 around Sweepcheck
	lda.b d4+2
	pha
	lda.b d5
	pha
	lda.b d5+2
	pha
	lda.b d6
	pha
	lda.b d6+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	jsl.l Sweepcheck				; sweep check for X
	pla								; restore
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d6+2
	pla
	sta.b d6
	pla
	sta.b d5+2
	pla
	sta.b d5
	pla
	sta.b d4+2
	pla
	sta.b d4
	bra .12							; done
.11:								; give the pad to the best candidate
	sta.b d0						; d0 = best player
	jsl.l AssignPadPlayer			; move the pad to him
.12:								; restore d0-d7 from the stack
	stx.b xsave
	ldx.w #$000E
.loopx:								; pull d0-d7 back
	pla
	sta.b d0,x
	dex
	dex
	bpl .loopx
	ldx.b xsave
	rtl
