; Scoring summary for both teams. Start leaves.
ShowScoringSummary:					; called from PauseScoringSummary
	lda.w VisTeam
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	jsl.l SetupScreen				; common setup of the stats screens
	lda.w #$0000
	sta.w curitem
	sta.w listtop
	sta.w listend
	ldx.w #$005E
	ldy.w #$0018
	lda.w #ScoringLabel>>16
	sta.b a1+2
	lda.w #ScoringLabel
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites ScoringLabel
	jsl.l SpriteFrameEnd
	lda.w #$FFFF
	sta.l colourbuf+$C2
	lda.w #$2BFF
	sta.l colourbuf+2
	lda.w #$6F7B
	sta.l colourbuf+$22
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoringSummaryHead>>16
	sta.b a1+2
	lda.w #ScoringSummaryHead
	sta.b a1
	jsl.l print						; print ScoringSummaryHead
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0000
	sta.w listend
	lda.l ScoreSumbytes
.loop:								; loop: if minus go to .t1
	cmp.w #$0006
	bmi .t1
.1:									; increment listend, sbc #$0006, go to .loop
	inc.w listend
	sec
	sbc.w #$0006
	bra .loop

.t1:								; if listend < $0006 go to .2
	lda.w listend
	cmp.w #$0006
	bcc .2
.1x:								; call PrintScrollHint
	jsl.l PrintScrollHint			; print the scroll hint under a summary list
.2:									; call FillScoringPage, call SendTextMap, call SetupScrollIRQ, ...
	jsr.w FillScoringPage			; build the scoring summary page in the stats page buffer
	jsl.l SendTextMap
	lda.w #$0058
	ldx.w #$00D0
	ldy.w #$00E0
	jsl.l SetupScrollIRQ			; set up the three-way scroll IRQ
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
	lda.w #$0005
	sta.w listrows
	jsr.w DrawScoringPage			; draw the visible scoring rows, or No Scoring when the list is empty
ScoringSummaryLoop:					; called from ScoringSummaryWait, ScrollScoringDown, ScrollScoringUp
	jsl.l getpzjoy					; ReadjoyA for the controller that owns the pause menu
	lda.b d3
	bit.w #$1000
	beq .t1
	rtl

.t1:								; d3 bits $1000 clear: if not zero go to ScrollScoringUp, ...
	bit.w #$0800
	bne ScrollScoringUp
	bit.w #$0400
	bne ScrollScoringDown
ScoringSummaryWait:					; called from ScrollScoringDown, ScrollScoringUp
	jsl.l WaitFrame
	bra ScoringSummaryLoop
