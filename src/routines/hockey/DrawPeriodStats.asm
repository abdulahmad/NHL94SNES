; Draw the period stats title and both teams' period columns.
DrawPeriodStats:					;period stats box: goals (curitem 0) or shots for periods 1-3, OT and
									;total; called from ShowPeriodStats
	jsl.l SpriteFrameStart			;sprite frame for the title letters
	jsl.l DrawMatchupPictures		;team photos
	jsl.l WaitDMAQueue				; wait until the DMA queue is empty
	ldx.w #$004C					;x
	ldy.w #$0018					;y
	lda.w #PeriodStats>>16
	sta.b a1+2
	lda.w #PeriodStats
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites PeriodStats
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawPeriodStatsPos>>16
	sta.b a1+2
	lda.w #DrawPeriodStatsPos
	sta.b a1
	jsl.l print						; print DrawPeriodStatsPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020					;32 wide
	sta.b d0
	lda.w #$0013					;19 high
	sta.b d1
	lda.l smallfontchars			;small font blank
	sta.b d2
	jsl.l eraser					;clear the box
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawPeriodStatsPos2>>16
	sta.b a1+2
	lda.w #DrawPeriodStatsPos2
	sta.b a1
	jsl.l print						; print DrawPeriodStatsPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w VisTeam					;visitors
	sta.b d1						;d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawPeriodStatsPos3>>16
	sta.b a1+2
	lda.w #DrawPeriodStatsPos3
	sta.b a1
	jsl.l print						; print DrawPeriodStatsPos3
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w HomeTeam					;home
	sta.b d1						;d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	lda.w #$000A					;column 10
	sta.w printx
	ldx.w #$0000					;period 1
	jsl.l .t3						;draw its column
	lda.w #$000E					;column 14
	sta.w printx
	ldx.w #$0001					;period 2
	jsl.l .t3
	lda.w #$0012					;column 18
	sta.w printx
	ldx.w #$0002					;period 3
	jsl.l .t3
	lda.w #$0016					;column 22
	sta.w printx
	ldx.w #$0003					;overtime
	jsl.l .t3
	lda.w #$001A					;column 26
	sta.w printx
	ldx.w #$0004					;total
	jsl.l .t3
	jsl.l SpriteFrameEnd
	rtl

.t3:								;.t3: column X (0-3 periods, 4 total) at printx
	lda.w printx
	sta.b d4						;d4 = column
	lda.w #$2400
	sta.w printa					;normal palette
	lda.w #$000C
	sta.w printy					;heading row 12
	inc.w printx
	cpx.w #$0004					;total column?
	bne .t1							;no
	dec.w printx					;back one
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #TotalShotsLine>>16
	sta.b a1+2
	lda.w #TotalShotsLine
	sta.b a1
	jsl.l print						; print TotalShotsLine
	pla
	sta.b a1
	pla
	sta.b a1+2
	inc.w printy					;next row
	bra .2							;print the values

.t1:								; if zero go to .t2, ...
	cpx.w lastperiod				;period X played?
	beq .t2
	bmi .t2							;yes
	jmp.w .3						;no: leave it blank

.t2:								;period heading
	lda.w #PerLabels>>16
	sta.b a1+2
	lda.w #PerLabels
	sta.b a1
	stx.b d0						;period
	jsl.l AdvanceStringPtr			;its name
	jsl.l print						;print
.2:									; printa = $2000, if curitem = 0 go to .t1x
	txa								;period
	asl a							;x4
	asl a							;home and visitors words
	tax								;index
	lda.w #$2000
	sta.w printa					;highlight palette
	lda.w curitem					;goals or shots?
	beq .t1x						;goals
.1:									; printx = d4, printy = $000F, d0 = tmPerShots+2,x, ...
	lda.b d4
	sta.w printx					;column
	lda.w #$000F
	sta.w printy					;row 15
	lda.w tmPerShots+2,x			;visitors shots
	sta.b d0
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			;push it
	jsl.l print						;print
	lda.b d4
	sta.w printx					;column
	lda.w #$0014
	sta.w printy					;row 20
	lda.w tmPerShots,x				;home shots
	sta.b d0
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			;push it
	jsl.l print						;print
	inc.w printy
	lda.w #$2400					;normal palette
	sta.w printa
	ldx.w #$0068					;x
	ldy.w #$0040					;y
	lda.w #TotalShotsLine>>16
	sta.b a1+2
	lda.w #TotalShotsLine+7			;"shots" title letters
	sta.b a1
	jsl.l PrintLetterSprites
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #TotalShotsLine>>16
	sta.b a1+2
	lda.w #TotalShotsLine+14		;shots label text
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .3							;done

.t1x:								;goals page
	lda.b d4
	sta.w printx					;column
	lda.w #$000F
	sta.w printy					;row 15
	lda.w tmPerGoals+2,x			;visitors goals
	sta.b d0
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			;push it
	jsl.l print						;print
	lda.b d4
	sta.w printx					;column
	lda.w #$0014
	sta.w printy					;row 20
	lda.w tmPerGoals,x				;home goals
	sta.b d0
	lda.w #$0003					;3 digits
	sta.b d1
	jsl.l PushNumberWrap			;push it
	jsl.l print						;print
	ldx.w #$0068					;x
	ldy.w #$0040					;y
	lda.w #GoalsLabel>>16
	sta.b a1+2
	lda.w #GoalsLabel
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites GoalsLabel
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #YShotsTxt>>16
	sta.b a1+2
	lda.w #YShotsTxt
	sta.b a1
	jsl.l print						; print YShotsTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
.3:									; return
	rtl
; Reset_Fast still calls this; emptied in 94
Reset_Fast_ret:						; emptied in 94
	rtl
