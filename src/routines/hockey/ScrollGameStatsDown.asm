; Scroll the game stats down one row.
ScrollGameStatsDown:				; called from GameStatsInput, GameStatsKeys
	jsr.w ClearGameStatBraces
	lda.w listtop
	clc
	adc.w listrows
	cmp.w listcount
	bmi .t2
	jmp.w MarkGameStatRows

.t2:								; increment listrows, call SendGameStatsPage, decrement listrows, ...
	inc.w listrows
	jsr.w SendGameStatsPage
	dec.w listrows
	jsl.l WaitFrame
	inc.w listtop
	lda.w #$0001
	sta.w irqvscroll1
.loop:								; loop: call WaitFrame, increment irqvscroll1, increment irqvscroll1, ...
	jsl.l WaitFrame
	inc.w irqvscroll1
	inc.w irqvscroll1
	lda.w irqvscroll1
	cmp.w #$000D
	bne .loop
	jsr.w SendGameStatsPage
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	jmp.w GameStatsKeys

.t1:								; scrollirqdone = $0000
	lda.w #$0000
	sta.w scrollirqdone
.loopx:								; loop: if scrollirqdone != $FFFF go to .loopx, ...
	lda.w scrollirqdone
	cmp.w #$FFFF
	bne .loopx
	rts
