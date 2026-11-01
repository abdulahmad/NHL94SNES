; Build the scoring summary page in the stats page buffer: a line per goal (ScoreSum, 6 bytes each)
FillScoringPage:					; called from ScoringSummaryScreen
	lda.w #statspage>>16
	sta.b p1+2
	lda.w #statspage
	sta.b p1
	ldx.w #$4D80					;whole page
	lda.l smallfontchars			;blank tile
	clc
	adc.l printfontset				;of the print font
	jsl.l MemFill					; fill X bytes at [p1] with the word A
	lda.w #ScoreSum>>16				;goal records, 6 bytes each
	sta.b a3+2
	lda.w #ScoreSum
	sta.b a3
	lda.w #$0000					;goal 0
	sta.w printy					;top row
	pha								;goal count on the stack
.loop:								; loop: if zero go to .t1
	cmp.w listend					;all goals?
	beq .t1							;yes
.1:									; call .t4, a3 = a3 + $0006, increment printy, ...
	jsr.w .t4						;print this goal
	lda.b a3						;next record
	clc
	adc.w #$0006
	sta.b a3
	inc.w printy					;next row
	pla								;goal
	inc a							;+1
	pha
	bra .loop

.t1:								; return
	pla
	rts

.t4:								;.t4: one goal line: period, time, team, type, scorer and assists
	lda.w #$0001					;column 1
	sta.w printx
	lda.w #$2000					;highlight palette
	sta.w printa
	ldy.w #$0000					;word 0
	lda.b [a3],y					;period and time
	phy
	pha								;save it
	and.w #$F000
	xba								;high byte
	lsr a							;shift bits 14-15 down
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d0						;period
	lda.w #PerLabels>>16			;period names
	sta.b a1+2
	lda.w #PerLabels
	sta.b a1
	jsl.l AdvanceStringPtr			;its name
	jsl.l PrintToStatsPage			;print
	lda.w #$0004					;column 4
	sta.w printx
	pla								;word 0
	and.w #$0FFF					;time in the period
	sta.b d0
	jsl.l PushTime					;as m:ss
	lda.b [a1]						;length
	cmp.w #$0006					;6 (two-digit minutes)?
	bne .1x							;no
	inc.w printx					;one column right
.1x:								; call PrintToStatsPage, printx = $000A, Y + 1, ...
	jsl.l PrintToStatsPage			;print
	lda.w #$000A					;column 10
	sta.w printx
	ply
	iny
	iny
	sep #$20
	lda.b [a3],y					;team and type
	rep #$20
	phy
	and.w #$00FF					;low byte
	pha								;keep it
	and.w #$00F0					;team in the high nibble
	sta.b d3
	stz.b a2						;home
	lda.b d3
	beq .2							;home
	lda.w #$0002					;visitors
	sta.b a2
.2:									; call PrintTeamAbbrev, decrement printy, decrement printy, ...
	jsl.l PrintTeamAbbrev			;team name
	dec.w printy					;back 2 rows
	dec.w printy
	lda.w #$001C					;column 28
	sta.w printx
	pla								;byte 2
	and.w #$000F					;goal type
	cmp.w #$0000
	beq .t3							;type 0
	cmp.w #$0001
	beq .t2							;type 1: short handed
	cmp.w #$0002
	beq .3							;type 2: even strength, no tag
	cmp.w #$0003
	beq .t1x						;type 3: power play
	lda.b a1+2						;other types: ScoringPP2 text
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

.t1x:								;type 3: ScoringPP text
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

.t2:								;type 1: ScoringSH text
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

.t3:								;type 0: ScoringSH2 text
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
.3:									;scorer
	ply
	iny
	sep #$20
	lda.b [a3],y					;scorer slot
	rep #$20
	phy
	and.w #$00FF
	sta.b d0						;player
	lda.w #$000E					;column 14
	sta.w printx
	jsl.l PlayerInitialName			;name
	jsl.l PrintToStatsPage			;print
	ply								;first assist
	iny
	lda.w #$2400					;normal palette
	sta.w printa
	sep #$20
	lda.b [a3],y					;assist slot
	rep #$20
	phy
	inc.w printy					;next row
	and.w #$00FF
	cmp.w #$00FF					;none?
	beq .1xx						;yes
	sta.b d0						;player
	lda.w #$0010					;column 16
	sta.w printx
	jsl.l PlayerInitialName			;name
	jsl.l PrintToStatsPage			;print
.1xx:								;second assist
	ply
	iny
	sep #$20
	lda.b [a3],y					;assist slot
	rep #$20
	inc.w printy					;next row
	and.w #$00FF
	cmp.w #$00FF					;none?
	beq .rts						;yes
	sta.b d0						;player
	lda.w #$0010					;column 16
	sta.w printx
	jsl.l PlayerInitialName			;name
	jsl.l PrintToStatsPage			;print
.rts:								; return
	rts
