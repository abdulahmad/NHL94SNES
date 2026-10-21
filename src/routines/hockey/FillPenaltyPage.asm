; Build the penalty summary page in the stats page buffer
FillPenaltyPage:					; called from ShowPenaltySummary
	lda.w #statspage>>16
	sta.b p1+2
	lda.w #statspage
	sta.b p1
	ldx.w #$4D80
	lda.l smallfontchars
	clc
	adc.l printfontset
	jsl.l MemFill
	lda.w #$0000
	sta.b a3+2
	lda.w #PenSum
	sta.b a3
	lda.w #$0000
	sta.w printy
	pha
.loop:								; loop: if zero go to .t1
	cmp.w listend
	beq .t1
.1:									; call .t2, a3 = a3 + $0004, increment printy, ...
	jsr.w .t2
	lda.b a3
	clc
	adc.w #$0004
	sta.b a3
	inc.w printy
	inc.w printy
	pla
	inc a
	pha
	bra .loop

.t1:								; return
	pla
	rts

.t2:								; subroutine: printx = $0001, printa = $2000, xba, ...
	lda.w #$0001
	sta.w printx
	lda.w #$2000
	sta.w printa
	ldy.w #$0000
	lda.b [a3],y
	phy
	pha
	and.w #$F000
	xba
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0
	lda.w #PerLabels>>16
	sta.b a1+2
	lda.w #PerLabels
	sta.b a1
	jsl.l AdvanceStringPtr
	jsl.l PrintToStatsPage
	lda.w #$0004
	sta.w printx
	pla
	and.w #$0FFF
	sta.b d0
	jsl.l PushTime
	lda.b [a1]
	cmp.w #$0006
	bne .1x
	inc.w printx
.1x:								; call PrintToStatsPage, printx = $000A, Y + 1, ...
	jsl.l PrintToStatsPage
	lda.w #$000A
	sta.w printx
	ply
	iny
	iny
	sep #$20
	lda.b [a3],y
	rep #$20
	phy
	and.w #$00FF
	pha
	and.w #$0080
	sta.b d3
	stz.b a2
	lda.b d3
	beq .2
	lda.w #$0002
	sta.b a2
.2:									; call PrintTeamAbbrev, decrement printy, decrement printy, ...
	jsl.l PrintTeamAbbrev
	dec.w printy
	dec.w printy
	lda.w #$000E
	sta.w printx
	pla
	and.w #$007F
	sta.b d0
	jsl.l PlayerInitialName
	jsl.l PrintToStatsPage
	ply
	iny
	sep #$20
	lda.b [a3],y
	rep #$20
	and.w #$00FF
	tay
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.w #$001D
	sta.w printx
	lda.b [a1]
	and.w #$00FF
	sta.b d0
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l PrintToStatsPage
	pla
	sta.b a1+2
	pla
	sta.b a1
	lda.w #$2400
	sta.w printa
	inc.w printy
	lda.w #$0010
	sta.w printx
	inc.b a1
	inc.b a1
	lda.b [a1]
	sta.b d0
	tay
	dec.b a1
	lda.b [a1],y
	inc.b a1
	and.w #$00FF
	bne .3
	dec.b d0
.3:									; call PrintToStatsPage, return
	jsl.l PrintToStatsPage
	rts
