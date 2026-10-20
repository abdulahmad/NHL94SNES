; Draw the exit question and the Yes and No lines.
DrawExitPrompt:						; called from AskExitGame
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawExitPromptPos>>16
	sta.b a1+2
	lda.w #DrawExitPromptPos
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
	ldy.w #$000D
.loop:								; loop: printa = $2400, printx = $0006, printy = Y, ...
	phy
	lda.w #$2400
	sta.w printa
	lda.w #$0006
	sta.w printx
	sty.w printy
	lda.w #ExitPromptClear>>16
	sta.b a1+2
	lda.w #ExitPromptClear
	sta.b a1
	jsl.l print
	ply
	iny
	cpy.w #$0012
	bcc .loop
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawExitPromptPos2>>16
	sta.b a1+2
	lda.w #DrawExitPromptPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$2400
	sta.w printa
	lda.w #ExitGameAsk>>16
	sta.b a1+2
	lda.w #ExitGameAsk
	sta.b a1
	lda.w shootoutmode
	beq .1
	lda.w #ExitShootoutAsk>>16
	sta.b a1+2
	lda.w #ExitShootoutAsk
	sta.b a1
.1:									; call print, a1 = DrawExitPromptPos3, call print, ...
	jsl.l print
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawExitPromptPos3>>16
	sta.b a1+2
	lda.w #DrawExitPromptPos3
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$2400
	sta.w printa
	lda.w curitem
	bne .2
	lda.w #$2000
	sta.w printa
.2:									; a1 = ExitNo, call print, a1 = DrawExitPromptPos4, ...
	lda.w #ExitNo>>16
	sta.b a1+2
	lda.w #ExitNo
	sta.b a1
	jsl.l print
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawExitPromptPos4>>16
	sta.b a1+2
	lda.w #DrawExitPromptPos4
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$2400
	sta.w printa
	lda.w curitem
	beq .3
	lda.w #$2000
	sta.w printa
.3:									; a1 = ExitYes, call print, return
	lda.w #ExitYes>>16
	sta.b a1+2
	lda.w #ExitYes
	sta.b a1
	jsl.l print
	rtl
