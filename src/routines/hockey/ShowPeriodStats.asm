; Period stats for both teams. Start leaves, Y swaps the view.
ShowPeriodStats:					; called from PausePeriodStats
	lda.w VisTeam
	sta.l setupvis
	lda.w HomeTeam
	sta.l setuphome
	jsl.l SetupScreen
	jsl.l SpriteFrameEnd
	jsl.l SendColours
	stz.w listtop
	lda.w #$0006
	sta.w listrows
	stz.w curitem
	jsl.l MenuScreenHDMA
	jsl.l ScreenOn
	jsl.l DrawPeriodStats
.1:									; loop: call SendTextMap, call WaitFrame, call ReadPads, ...
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads
	jsl.l ReadPausePad
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	bne .t1
	bit.w #$4000
	bne .t2
	bra .1

.t1:								; d1 bit $1000 set: return
	rtl

.t2:								; eor #$0001, curitem = A, call DrawPeriodStats, ...
	lda.w curitem
	eor.w #$0001
	sta.w curitem
	jsl.l DrawPeriodStats
	bra .1
