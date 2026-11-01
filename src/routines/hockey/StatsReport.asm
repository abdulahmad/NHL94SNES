; Game stats screen: both teams and the stat rows
StatsReport:						; called from PauseGameStats
	lda.w VisTeam
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	jsl.l SetupScreen				; common setup of the stats screens
	ldx.w #$0050
	ldy.w #$0018
	lda.w #GameStats>>16
	sta.b a1+2
	lda.w #GameStats
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites GameStats
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #StatsReportPos>>16
	sta.b a1+2
	lda.w #StatsReportPos
	sta.b a1
	jsl.l print						; print StatsReportPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w VisTeam
	sta.b d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #StatsReportPos2>>16
	sta.b a1+2
	lda.w #StatsReportPos2
	sta.b a1
	jsl.l print						; print StatsReportPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w HomeTeam
	sta.b d1
	jsl.l DrawTeamBlocks			; entry: the block of team d1
	jsl.l SpriteFrameEnd
	lda.w #$FFFF
	sta.l colourbuf+$42
	lda.w #$2BFF
	sta.l colourbuf+$22
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	stz.w listtop
	lda.w #$0006
	sta.w listrows
	lda.w #$0010
	sta.w listcount
	lda.w #$0010
	sta.w statpenrows
	lda.l OptPen
	bne .2
.1:									; listcount = $000B, statpenrows = $0000
	lda.w #$000B
	sta.w listcount
	lda.w #$0000
	sta.w statpenrows
.2:									; decrement listcount, call SetupScrollIRQ, irqvscroll2 = $0010, ...
	dec.w listcount
	lda.w #$0060
	ldx.w #$00C8
	ldy.w #$00D8
	jsl.l SetupScrollIRQ			; set up the three-way scroll IRQ
	lda.w #$0010
	sta.w irqvscroll2
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
	jsr.w DisplayStats				; print each team-stat name and both teams' numbers
	jsl.l SendTextMap
	bra MarkGameStatRows
