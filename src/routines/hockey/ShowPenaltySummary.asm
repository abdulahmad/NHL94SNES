; Penalty summary for both teams. Start leaves.
ShowPenaltySummary:					; called from PausePenaltySummary
	lda.w VisTeam
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	jsl.l SetupScreen
	lda.w #$0000
	sta.w curitem
	sta.w listtop
	sta.w listend
	ldx.w #$0058
	ldy.w #$0018
	lda.w #PenaltiesLabel>>16
	sta.b a1+2
	lda.w #PenaltiesLabel
	sta.b a1
	jsl.l PrintLetterSprites
	jsl.l SpriteFrameEnd
	lda.w #$FFFF
	sta.l colourbuf+$C2
	lda.w #$2BFF
	sta.l colourbuf+2
	lda.w #$6F7B
	sta.l colourbuf+$22
	jsl.l SendColours
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PenaltySummaryHead>>16
	sta.b a1+2
	lda.w #PenaltySummaryHead
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w PenSumLength
	sta.w listend
	lda.w listend
	cmp.w #$0006
	bcc .2
.1:									; call PrintScrollHint
	jsl.l PrintScrollHint
.2:									; call FillPenaltyPage, call SendTextMap, call SetupScrollIRQ, ...
	jsr.w FillPenaltyPage
	jsl.l SendTextMap
	lda.w #$0058
	ldx.w #$00D0
	ldy.w #$00E0
	jsl.l SetupScrollIRQ
	jsl.l MenuScreenHDMA
	jsl.l ScreenOn
	lda.w #$0005
	sta.w listrows
	jsr.w DrawPenaltyPage
PenaltySummaryLoop:					; called from PenaltySummaryWait, ScrollPenaltyDown, ScrollPenaltyUp
	jsl.l ReadPausePad
	jsl.l ProcessInputWithRepeat
	lda.b d3
	bit.w #$1000
	beq .t1
	rtl

.t1:								; d3 bits $1000 clear: if not zero go to ScrollPenaltyUp, ...
	bit.w #$0800
	bne ScrollPenaltyUp
	bit.w #$0400
	bne ScrollPenaltyDown
PenaltySummaryWait:					; called from ScrollPenaltyDown, ScrollPenaltyUp
	jsl.l WaitFrame
	bra PenaltySummaryLoop
