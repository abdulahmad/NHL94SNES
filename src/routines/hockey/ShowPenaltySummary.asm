; Penalty summary for both teams. Start leaves.
ShowPenaltySummary:					; called from PausePenaltySummary
	lda.w VisTeam
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	jsl.l SetupScreen				; common setup of the stats screens
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
	jsl.l PrintLetterSprites		; PrintLetterSprites PenaltiesLabel
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
	lda.w #PenaltySummaryHead>>16
	sta.b a1+2
	lda.w #PenaltySummaryHead
	sta.b a1
	jsl.l print						; print PenaltySummaryHead
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
	jsl.l PrintScrollHint			; print the scroll hint under a summary list
.2:									; call FillPenaltyPage, call SendTextMap, call SetupScrollIRQ, ...
	jsr.w FillPenaltyPage			; build the penalty summary page in the stats page buffer
	jsl.l SendTextMap
	lda.w #$0058
	ldx.w #$00D0
	ldy.w #$00E0
	jsl.l SetupScrollIRQ			; set up the three-way scroll IRQ
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
	lda.w #$0005
	sta.w listrows
	jsr.w DrawPenaltyPage			; draw the visible penalty rows, or No Penalties when the list is empty
PenaltySummaryLoop:					; called from PenaltySummaryWait, ScrollPenaltyDown, ScrollPenaltyUp
	jsl.l getpzjoy					; ReadjoyA for the controller that owns the pause menu
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
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
