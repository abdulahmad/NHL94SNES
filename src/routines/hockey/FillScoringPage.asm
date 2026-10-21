; Build the scoring summary page in the stats page buffer: a line per goal (ScoreSum, 6 bytes each)
FillScoringPage:					; called from ShowScoringSummary
	lda.w #statspage>>16
	sta.b p1+2
	lda.w #statspage
	sta.b p1
	ldx.w #$4D80
	lda.l smallfontchars
	clc
	adc.l printfontset
	jsl.l MemFill
	lda.w #$007E
	sta.b a3+2
	lda.w #ScoreSum
	sta.b a3
	lda.w #$0000
	sta.w printy
	pha
.loop:								; loop: if zero go to .t1
	cmp.w listend
	beq .t1
.1:									; call .t4, a3 = a3 + $0006, increment printy, ...
	jsr.w .t4
	lda.b a3
	clc
	adc.w #$0006
	sta.b a3
	inc.w printy
	pla
	inc a
	pha
	bra .loop

.t1:								; return
	pla
	rts

.t4:								; subroutine: printx = $0001, printa = $2000, xba, ...
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
	and.w #$00F0
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
	lda.w #$001C
	sta.w printx
	pla
	and.w #$000F
	cmp.w #$0000
	beq .t3
	cmp.w #$0001
	beq .t2
	cmp.w #$0002
	beq .3
	cmp.w #$0003
	beq .t1x
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoringPP2>>16
	sta.b a1+2
	lda.w #ScoringPP2
	sta.b a1
	jsl.l PrintToStatsPage
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .3

.t1x:								; a1 = ScoringPP, call PrintToStatsPage, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoringPP>>16
	sta.b a1+2
	lda.w #ScoringPP
	sta.b a1
	jsl.l PrintToStatsPage
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .3

.t2:								; a1 = ScoringSH, call PrintToStatsPage, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoringSH>>16
	sta.b a1+2
	lda.w #ScoringSH
	sta.b a1
	jsl.l PrintToStatsPage
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .3

.t3:								; a1 = ScoringSH2, call PrintToStatsPage, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoringSH2>>16
	sta.b a1+2
	lda.w #ScoringSH2
	sta.b a1
	jsl.l PrintToStatsPage
	pla
	sta.b a1
	pla
	sta.b a1+2
.3:									; Y + 1, d0 = [a3],y & $00FF, printx = $000E, ...
	ply
	iny
	sep #$20
	lda.b [a3],y
	rep #$20
	phy
	and.w #$00FF
	sta.b d0
	lda.w #$000E
	sta.w printx
	jsl.l PlayerInitialName
	jsl.l PrintToStatsPage
	ply
	iny
	lda.w #$2400
	sta.w printa
	sep #$20
	lda.b [a3],y
	rep #$20
	phy
	inc.w printy
	and.w #$00FF
	cmp.w #$00FF
	beq .1xx
	sta.b d0
	lda.w #$0010
	sta.w printx
	jsl.l PlayerInitialName
	jsl.l PrintToStatsPage
.1xx:								; Y + 1, increment printy, if zero go to .rts, ...
	ply
	iny
	sep #$20
	lda.b [a3],y
	rep #$20
	inc.w printy
	and.w #$00FF
	cmp.w #$00FF
	beq .rts
	sta.b d0
	lda.w #$0010
	sta.w printx
	jsl.l PlayerInitialName
	jsl.l PrintToStatsPage
.rts:								; return
	rts
