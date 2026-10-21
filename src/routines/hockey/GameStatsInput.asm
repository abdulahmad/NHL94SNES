; Game stats input. Start leaves, up and down scroll the rows.
; Input loop of the game stats screen. Called from MarkGameStatRows (jump).
GameStatsInput:						; called from MarkGameStatRows
	jsl.l WaitFrame					; wait a frame and read the pad
	jsl.l ReadPausePad				; ReadjoyA for the controller that owns the pause menu
	lda.b d3
	bit.w #$1000
	beq .t1							; not Start (d3 bit $1000 = new press)
	jmp.w GameStatsRtl				; Start: leave the screen

.t1:								; test Up
	bit.w #$0800
	beq .t2							; not Up
.1:									; scroll up (shared with the test in GameStatsKeys)
	jmp.w ScrollGameStatsUp			; Up ($0800): scroll the rows up

.t2:								; test Down
	bit.w #$0400
	beq .t1x						; not Down
	jmp.w ScrollGameStatsDown		; Down ($0400): scroll the rows down

.t1x:								; nothing pressed: poll again
	bra GameStatsInput
; Game stats: Start leaves, up / down scroll, else MarkGameStatRows; the scroll routines come back here
GameStatsKeys:						; scroll routines of the game stats screen return here: read pad, act
	jsl.l ReadPausePad				; ReadjoyA for the controller that owns the pause menu
	lda.b d3
	bit.w #$1000
	bne GameStatsRtl
	bit.w #$0800
	bne ScrollGameStatsUp
	bit.w #$0400
	beq MarkGameStatRows
	jmp.w ScrollGameStatsDown		; scroll the game stats down one row
