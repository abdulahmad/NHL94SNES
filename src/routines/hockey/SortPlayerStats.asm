; Player stats: print the column name, sort the player order (statsorder) by stat column statcolumn
; (ComparePlayerStats), then FillPlayerStatsPage
SortPlayerStats:					; called from ShowPlayerStats, ShowPlayerStats_column, ShowPlayerStats_...
	lda.w statcolumn
	sta.b d0
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #SortPlayerStatsPos>>16
	sta.b a1+2
	lda.w #SortPlayerStatsPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #StatColumnNames>>16
	sta.b a1+2
	lda.w #StatColumnNames
	sta.b a1
	jsl.l AdvanceStringPtr
	jsl.l print
	ldx.w listtop
.loop:								; loop: txy
	txy
.loop2:								; loop: Y + 1, call ComparePlayerStats, if statstemp = 0 go to .2
	iny
	jsl.l ComparePlayerStats
	lda.w statstemp
	beq .2
.1:									; statstemp = statsorder,y, statsorder,y = statsorder,x, statsorder,x =...
	sep #$20
	lda.w statsorder,y
	sta.w statstemp
	lda.w statsorder,x
	sta.w statsorder,y
	lda.w statstemp
	sta.w statsorder,x
	rep #$20
.2:									; if carry clear go to .loop2, ...
	cpy.w listend
	bcc .loop2
	inx
	cpx.w listend
	bcc .loop
	jsl.l FillPlayerStatsPage
	rtl
