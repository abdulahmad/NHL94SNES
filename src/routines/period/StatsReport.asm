; Clear the text screen and draw the horizontal rink scoreboard background
StatsReport:						; called from SetHor
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #StatsReportPos>>16
	sta.b a1+2
	lda.w #StatsReportPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$001D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #StatsReportPos2>>16
	sta.b a1+2
	lda.w #StatsReportPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #rinkmapbuf>>16
	sta.b p0+2
	lda.w #rinkmapbuf
	sta.b p0
	lda.w #$0000
	sta.b r7
	lda.w #$0055
	sta.b r7+2
	lda.w #$0020
	sta.b r4
	lda.w #$001C
	sta.b r4+2
	lda.w #$0400
	sta.w MapVRAM
	ldx.w #$0000
	ldy.w #$0000
	jsl.l MapPartToVRAM
	lda.w #rinkmapbuf>>16
	sta.b p0+2
	lda.w #rinkmapbuf
	sta.b p0
	lda.w #$0010
	sta.b r7
	lda.w #$0055
	sta.b r7+2
	lda.w #$0020
	sta.b r4
	lda.w #$001C
	sta.b r4+2
	lda.w #$0800
	sta.w MapVRAM
	ldx.w #$0000
	ldy.w #$0000
	jsl.l MapPartToVRAM
	jmp.w USBoard
