; Draw the scoreboard: the period and score boxes on the vertical rink, or the period, teams and scores on the
; horizontal rink
printscores1:						; called from ClrHor, Goal, Intermission, Pausemode, StartHL2 and 4 more
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	stx.b xsave
	ldx.w #$0000
.savea:								; loop: X + 1, X + 1, if not zero go to .savea, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave
	lda.w sfhormode
	beq .v
	jmp.w .sbscreen

.v:									; sfhormode = 0: a1 = printscores1Pos, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos>>16
	sta.b a1+2
	lda.w #printscores1Pos
	sta.b a1
	jsl.l print						; print printscores1Pos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0009
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	lda.l OptPlayMode
	cmp.w #$0004
	beq .t2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos2>>16
	sta.b a1+2
	lda.w #printscores1Pos2
	sta.b a1
	jsl.l print						; print printscores1Pos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w gsp
	sta.b d0
	cmp.w #$0004
	bne .noso
	dec.w printx
	inc.b d0
.noso:								; a1 = PerLabels, call PrintStringFromList, call EASNLogo, ...
	lda.w #PerLabels>>16
	sta.b a1+2
	lda.w #PerLabels
	sta.b a1
	jsl.l PrintStringFromList		; prints a string from a list
	jsl.l EASNLogo					; draw the logo
	jsl.l updatepwrplay				; show the power play box: the time left and the team on the power play
	bra .scores

.t2:								; OptPlayMode = $0004: a1 = RoundTxt, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RoundTxt>>16
	sta.b a1+2
	lda.w #RoundTxt
	sta.b a1
	jsl.l print						; print RoundTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0006
	sta.w printx
	lda.w shootoutround
	sta.b d0
	lda.w #$0002
	sta.b d1
	jsl.l PushNumberWrap			; PushNumberWidth, with d0 taken mod 100 when the width d1 is 2
	jsl.l print
.scores:							; if sflags3 bits sf3llcs clear go to .boxes, ...
	lda.w sflags3
	bit.w #sf3llcs
	beq .boxes
	jmp.w .ex

.boxes:								; sflags3 bits sf3llcs clear: a1 = printscores1Pos3, call print, a1 = p...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos3>>16
	sta.b a1+2
	lda.w #printscores1Pos3
	sta.b a1
	jsl.l print						; print printscores1Pos3
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0009
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos4>>16
	sta.b a1+2
	lda.w #printscores1Pos4
	sta.b a1
	jsl.l print						; print printscores1Pos4
	pla
	sta.b a1
	pla
	sta.b a1+2
	stz.b d3
	stz.b a2
	jsl.l PrintTeamNameAndScore		; prints a team and its score
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos5>>16
	sta.b a1+2
	lda.w #printscores1Pos5
	sta.b a1
	jsl.l print						; print printscores1Pos5
	pla
	sta.b a1
	pla
	sta.b a1+2
	inc.b d3
	inc.b a2
	inc.b a2
	jsl.l PrintTeamNameAndScore		; prints a team and its score
	stz.b a2
	lda.w #$0002
	sta.b a3
	lda.w gmode
	bit.w #gmdir
	bne .ends
	stz.b a3
	lda.w #$0002
	sta.b a2
.ends:								; a1 = printscores1Pos6, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos6>>16
	sta.b a1+2
	lda.w #printscores1Pos6
	sta.b a1
	jsl.l print						; print printscores1Pos6
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l nullrtl89					; does nothing
	ldx.b a2
	lda.b a3
	sta.b a2
	stx.b a3
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos7>>16
	sta.b a1+2
	lda.w #printscores1Pos7
	sta.b a1
	jsl.l print						; print printscores1Pos7
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l nullrtl89					; does nothing
.ex:								; xsave = X
	stx.b xsave
	ldx.w #$000E
.resta:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	ldx.b a3
	rtl
.sbscreen:							; a1 = printscores1Pos8, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos8>>16
	sta.b a1+2
	lda.w #printscores1Pos8
	sta.b a1
	jsl.l print						; print printscores1Pos8
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l PrintPerLabel				; prints the period label
	lda.b d1
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos9>>16
	sta.b a1+2
	lda.w #printscores1Pos9
	sta.b a1
	jsl.l print						; print printscores1Pos9
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w tmscore
	sta.b d0
	jsl.l Mod100					; d0 = d0 mod 100
	jsl.l PushNumber				; a1 = d0 as a decimal string, no leading zeros
	jsl.l AlignBigNumber
	jsl.l printbig
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos10>>16
	sta.b a1+2
	lda.w #printscores1Pos10
	sta.b a1
	jsl.l print						; print printscores1Pos10
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w tmscore+2
	sta.b d0
	jsl.l Mod100					; d0 = d0 mod 100
	jsl.l PushNumber				; a1 = d0 as a decimal string, no leading zeros
	jsl.l AlignBigNumber
	jsl.l printbig
	pla
	sta.b d1
	jmp.w .ex
