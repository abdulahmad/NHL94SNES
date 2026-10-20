; Bad password: wait for a button, then offer retry or exit
BadPasswordPrompt:					; called from PasswordRedraw
	jsl.l DecodePW
	lda.l postarts
	bpl PasswordCursorRtl
.loop:								; loop: if JoyPad bit $4000 set go to .loop, ...
	lda.w JoyPad
	bit.w #$4000
	bne .loop
	bit.w #$8080
	bne .loop
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #BadPassword>>16
	sta.b a1+2
	lda.w #BadPassword
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ARetryTxt>>16
	sta.b a1+2
	lda.w #ARetryTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #YExitScreenTxt>>16
	sta.b a1+2
	lda.w #YExitScreenTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #BadPasswordPromptPos>>16
	sta.b a1+2
	lda.w #BadPasswordPromptPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l QueueTextDMA
.loop2:								; loop: call ReadPads, call ReadJoy1, if d3 = 0 go to .loop2, ...
	jsl.l ReadPads
	jsl.l ReadJoy1
	lda.b d3
	beq .loop2
	bit.w #$4000
	bne .t1
	bit.w #$8080
	beq .loop2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #BadPasswordPromptPos2>>16
	sta.b a1+2
	lda.w #BadPasswordPromptPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$000F
	sta.b d0
	lda.w #$0003
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	jsr.w PrintPasswordHelp
	jsl.l QueueTextDMA
	jsl.l WaitNoButtons
	jmp.w PasswordRedraw

.t1:								; OptPlayMode = $0002, go to Restart
	lda.w #$0002
	sta.l OptPlayMode
	jml.l Restart
