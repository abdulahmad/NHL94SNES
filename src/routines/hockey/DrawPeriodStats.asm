; Draw the period stats title and both teams' period columns.
DrawPeriodStats:					; called from ShowPeriodStats
	jsl.l SpriteFrameStart
	jsl.l DrawMatchupPictures
	jsl.l WaitDMAQueue
	ldx.w #$004C
	ldy.w #$0018
	lda.w #PeriodStats>>16
	sta.b a1+2
	lda.w #PeriodStats
	sta.b a1
	jsl.l PrintLetterSprites
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawPeriodStatsPos>>16
	sta.b a1+2
	lda.w #DrawPeriodStatsPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$0013
	sta.b d1
	lda.l smallfontchars
	sta.b d2
	jsl.l eraser
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawPeriodStatsPos2>>16
	sta.b a1+2
	lda.w #DrawPeriodStatsPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w VisTeam
	sta.b d1
	jsl.l DrawTeamBlocks
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawPeriodStatsPos3>>16
	sta.b a1+2
	lda.w #DrawPeriodStatsPos3
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w HomeTeam
	sta.b d1
	jsl.l DrawTeamBlocks
	lda.w #$000A
	sta.w printx
	ldx.w #$0000
	jsl.l .t3
	lda.w #$000E
	sta.w printx
	ldx.w #$0001
	jsl.l .t3
	lda.w #$0012
	sta.w printx
	ldx.w #$0002
	jsl.l .t3
	lda.w #$0016
	sta.w printx
	ldx.w #$0003
	jsl.l .t3
	lda.w #$001A
	sta.w printx
	ldx.w #$0004
	jsl.l .t3
	jsl.l SpriteFrameEnd
	rtl

.t3:								; subroutine: d4 = printx, printa = $2400, printy = $000C, ...
	lda.w printx
	sta.b d4
	lda.w #$2400
	sta.w printa
	lda.w #$000C
	sta.w printy
	inc.w printx
	cpx.w #$0004
	bne .t1
	dec.w printx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #TotalShotsLine>>16
	sta.b a1+2
	lda.w #TotalShotsLine
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	inc.w printy
	bra .2

.t1:								; if zero go to .t2, ...
	cpx.w lastperiod
	beq .t2
	bmi .t2
	jmp.w .3

.t2:								; a1 = PerLabels, d0 = X, call AdvanceStringPtr, ...
	lda.w #PerLabels>>16
	sta.b a1+2
	lda.w #PerLabels
	sta.b a1
	stx.b d0
	jsl.l AdvanceStringPtr
	jsl.l print
.2:									; printa = $2000, if curitem = 0 go to .t1x
	txa
	asl a
	asl a
	tax
	lda.w #$2000
	sta.w printa
	lda.w curitem
	beq .t1x
.1:									; printx = d4, printy = $000F, d0 = tmPerShots+2,x, ...
	lda.b d4
	sta.w printx
	lda.w #$000F
	sta.w printy
	lda.w tmPerShots+2,x
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l print
	lda.b d4
	sta.w printx
	lda.w #$0014
	sta.w printy
	lda.w tmPerShots,x
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l print
	inc.w printy
	lda.w #$2400
	sta.w printa
	ldx.w #$0068
	ldy.w #$0040
	lda.w #TotalShotsLine>>16
	sta.b a1+2
	lda.w #TotalShotsLine+7
	sta.b a1
	jsl.l PrintLetterSprites
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #TotalShotsLine>>16
	sta.b a1+2
	lda.w #TotalShotsLine+14
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .3

.t1x:								; curitem = 0: printx = d4, printy = $000F, d0 = tmPerGoals+2,x, ...
	lda.b d4
	sta.w printx
	lda.w #$000F
	sta.w printy
	lda.w tmPerGoals+2,x
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l print
	lda.b d4
	sta.w printx
	lda.w #$0014
	sta.w printy
	lda.w tmPerGoals,x
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l PushNumberWrap
	jsl.l print
	ldx.w #$0068
	ldy.w #$0040
	lda.w #GoalsLabel>>16
	sta.b a1+2
	lda.w #GoalsLabel
	sta.b a1
	jsl.l PrintLetterSprites
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #YShotsTxt>>16
	sta.b a1+2
	lda.w #YShotsTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.3:									; return
	rtl
