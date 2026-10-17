; Shootout shooters: the player list rows
PrintShooterList:					;draw the ShooterSelectList list: the title of rating column $0D47, the
									;scroll marks, the rows
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintShooterListPos>>16
	sta.b a1+2
	lda.w #PrintShooterListPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$000D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.w #$0011
	sta.w printx
	lda.w #$0002
	sta.w printy
.1:
	lda.w #ShooterAttribColumns>>16
	sta.b a1+2
	lda.w #ShooterAttribColumns
	sta.b a1
	lda.w DispAttribCtr
	sta.b d0
	bra .3
.2:
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0004
	sta.b a1
.3:
	lda.b [a1]
	bmi .1x
	dec.b d0
	bpl .2
.1x:
	lda.b [a1]
	bpl .t1
	dec.w DispAttribCtr
	bra .1

.t1:
	lda.w #$3800
	sta.w printa
	jsl.l print
	lda.b [a1]
	sta.b d4+2
	ldy.w #$0002
	lda.b [a1],y
	sta.b d4
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayerTxt2>>16
	sta.b a1+2
	lda.w #PlayerTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w picktop
	cmp.w pickfirst
	beq .1xx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #LeftArrowTxt3>>16
	sta.b a1+2
	lda.w #LeftArrowTxt3
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.1xx:
	lda.w picktop
	sec
	sbc.w pickfirst
	clc
	adc.w #$0009
	cmp.w listcount
	bpl .2x
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RightArrowTxt3>>16
	sta.b a1+2
	lda.w #RightArrowTxt3
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.2x:
	jsl.l PrintShooterRows
	rtl
