; Draw the scoreboard: the period and score boxes on the vertical rink, or the period, teams and scores on the
; horizontal rink
printscores1:
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
.savea:
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

.v:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos>>16
	sta.b a1+2
	lda.w #printscores1Pos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0009
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer
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
	jsl.l print
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
.noso:
	lda.w #PerLabels>>16
	sta.b a1+2
	lda.w #PerLabels
	sta.b a1
	jsl.l PrintStringFromList
	jsl.l EASNLogo
	jsl.l updatepwrplay
	bra .scores

.t2:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RoundTxt>>16
	sta.b a1+2
	lda.w #RoundTxt
	sta.b a1
	jsl.l print
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
	jsl.l PushNumberWrap
	jsl.l print
.scores:
	lda.w sflags3
	bit.w #sf3llcs
	beq .boxes
	jmp.w .ex

.boxes:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos3>>16
	sta.b a1+2
	lda.w #printscores1Pos3
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0009
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos4>>16
	sta.b a1+2
	lda.w #printscores1Pos4
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	stz.b d3
	stz.b a2
	jsl.l PrintTeamNameAndScore
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos5>>16
	sta.b a1+2
	lda.w #printscores1Pos5
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	inc.b d3
	inc.b a2
	inc.b a2
	jsl.l PrintTeamNameAndScore
	stz.b a2
	lda.w #$0002
	sta.b a3
	lda.w gmode
	bit.w #gmdir
	bne .ends
	stz.b a3
	lda.w #$0002
	sta.b a2
.ends:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos6>>16
	sta.b a1+2
	lda.w #printscores1Pos6
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l nullrtl89
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l nullrtl89
.ex:
	stx.b xsave
	ldx.w #$000E
.resta:
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
.sbscreen:
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #printscores1Pos8>>16
	sta.b a1+2
	lda.w #printscores1Pos8
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l PrintPerLabel
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w tmscore
	sta.b d0
	jsl.l Mod100
	jsl.l PushNumber
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w tmscore+2
	sta.b d0
	jsl.l Mod100
	jsl.l PushNumber
	jsl.l AlignBigNumber
	jsl.l printbig
	pla
	sta.b d1
	jmp.w .ex
