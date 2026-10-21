; d0 = rating column d1 (AttribMenuSkater / AttribMenuGoalie) of player curplayer of team a2 through
; CalcAttrib, with the hot / cold adjustment
; Takes d1 = rating column number, a2 = team offset, curplayer = player. Saves d0 to d9 and the pointers,
; picks the AttribMenuGoalie list for a goalie (curplayer past the skaters) or AttribMenuSkater, finds the
; d1-th entry and gets the value with CalcAttrib. Returns d0 = rating, the other registers restored.
;
; Called from ScoutingReport, ShowMatchups, AddStrength, FindGoalieStrengths and DrawPlayerCard.
GetPlayerRating:					; rating of curplayer with hot / cold
	stx.b xsave
	ldx.w #$0000
.loop:								; save d0 to d9 on the stack
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .loop
	ldx.b xsave
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.w #AttribMenuSkater>>16
	sta.b a1+2
	lda.w #AttribMenuSkater
	sta.b a1
	stz.b r2
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.w curplayer
	cmp.b d0
	bpl .1
	lda.w #AttribMenuGoalie>>16
	sta.b a1+2
	lda.w #AttribMenuGoalie
	sta.b a1
	lda.w #$0010
	sta.b r2
.1:									; goalie: use the goalie menu and r2 = $10
	phx
	ldx.b d1
.loop2:								; skip the entries before column d1
	dex
	bmi .t1
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0004
	sta.b a1
	bra .loop2

.t1:								; found the entry: d4 = its attribute and word
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
	lda.b [a1]
	sta.b d4+2
	ldy.w #$0002
	lda.b [a1],y
	sta.b d4
	plx
	lda.w curplayer
	sta.b d0
	lda.w #$0001
	sta.l usehotcold
	jsl.l CalcAttrib				; overall rating of a player from his attributes and hot / cold values
	lda.b d0
	sta.b r0
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	stx.b xsave
	ldx.w #$0012
.loopx:								; restore d0 to d9
	pla
	sta.b d0,x
	dex
	dex
	bpl .loopx
	ldx.b xsave
	lda.b r0
	sta.b d0
	rtl
