; Draw the line change box for team a2, one row per line it can change to
SetLCmode2:
	jsl.l setlccords
	inc.b d0
	inc.b d1
	lda.l blankchar
	sta.b d2
	lda.l fobox
	bne .1
	jsl.l eraser
.1:
	jsl.l setlccords
	lda.w printy
	sec
	sbc.w #$000F
	bmi .t1
	lda.w #$0001
	tsb.w sflags3
	bra .4

.t1:
	jsl.l box
	jsl.l setlccords
.4:
	jsl.l Framer
	dec.w printy
	dec.w printy
	inc.w printx
	lda.w #$0002
	sta.b d4
	lda.w printx
	pha
.loop:
	lda.b r0+1,s
	sta.w printx
	lda.b d4
	sta.b d0
	jsl.l getlchoice
	lda.b d0
	bmi .3
	ldy.b a2
	lda.w tmflags,y
	bit.w #$0008
	bne .1x
	lda.b d4
	cmp.w tmlcchoice,y
	bne .2
	lda.w tmline,y
	sta.b d0
.1x:
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0004
	sta.b [a1]
	phx
	ldx.b d4
	lda.l LineChangeButtons,x
	plx
	and.w #$00FF
	ora.w #$2000
	ldy.w #$0002
	sta.b [a1],y
	jsl.l print
	lda.b d0
	pha
	lda.w #linelist>>16
	sta.b a1+2
	lda.w #linelist
	sta.b a1
	jsl.l PrintStringFromList
	pla
	sta.b d0
	jsl.l linebar
.2:
	dec.w printy
.3:
	dec.b d4
	bpl .loop
	pla
	clc
	adc.w #$0005
	sta.w printx
	ldy.b a2
	lda.w HomeTeam,y
	lda.w #$009C
	sta.b a1+2
	lda.w tmdata,y
	sta.b a1
	ldy.w #$0004
	clc
	adc.b [a1],y
	sta.b a1
	clc
	adc.b [a1]
	sta.b a1
	jml.l print
