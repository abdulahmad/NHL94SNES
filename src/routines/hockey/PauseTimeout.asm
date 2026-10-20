; Pause menu Timeout
PauseTimeout:						; called from PauseMenuHandlers
	lda.b d1
	bit.w #$8080
	beq PauseDefStore
	jsl.l GetPadTeam
	ldy.b a2
	lda.w tmtimeouts,y
	dec a
	bmi .1
	sta.w tmtimeouts,y
	jsl.l reenergizeteam
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PauseTimeoutPos>>16
	sta.b a1+2
	lda.w #PauseTimeoutPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016
	sta.b d0
	lda.w #$0007
	sta.b d1
	jsl.l Framer
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #TimeoutTxt>>16
	sta.b a1+2
	lda.w #TimeoutTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	ldy.b a2
	lda.w HomeTeam,y
	jsl.l GetTeamLongName
	lda.b [a1]
	dec a
	dec a
	lsr a
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.w #$0010
	sta.w printx
	jsl.l print
	jsl.l SendTextMap
	ldx.w #$0096
	ldy.w #$0000
	jsl.l WaitFrames_Inc
	jsl.l ChoosePauseMenu
.1:									; go to PauseMenuPoll
	jmp.w PauseMenuPoll
