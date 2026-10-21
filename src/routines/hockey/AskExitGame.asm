; Yes or No exit prompt
AskExitGame:						; called from PauseExitGame
	lda.w #$0000
	sta.w curitem
.1:									; loop: call DrawExitPrompt, call SendTextMap, call WaitFrame, ...
	jsl.l DrawExitPrompt			; draw the exit question and the Yes and No lines
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadPausePad				; ReadjoyA for the controller that owns the pause menu
	lda.b d1
	bit.w #$1000
	bne .t4
	bit.w #$8080
	bne .2
	bit.w #$0800
	bne .t1
	bit.w #$0400
	bne .t2
	bra .1

.t1:								; if a still >= 0 go to .t3, ...
	lda.w curitem
	dec a
	bpl .t3
	bra .1

.t2:								; if minus go to .t3, ...
	lda.w curitem
	inc a
	cmp.w #$0002
	bmi .t3
	bra .1

.t3:								; curitem = A, go to .1
	sta.w curitem
	bra .1

.t4:								; d1 bit $1000 set: curitem = $0000
	lda.w #$0000
	sta.w curitem
.2:									; call WaitButtonRelease, return
	jsl.l WaitButtonRelease			; wait until the pause pad has no button down
	lda.w curitem
	rtl
