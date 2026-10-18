; Close the line change box and redraw the scoreboard
lcfound2:
	jsl.l setlccords
	lda.w printy
	sec
	sbc.w #$000F
	bmi .1
	lda.w #$0001
	trb.w sflags3
.1:
	inc.b d1
	lda.l blankchar
	sta.b d2
	lda.l fobox
	bne .2
	jsl.l eraser
.2:
	jml.l printscores1

.t1:
	stx.b xsave
	ldx.w #$0000
.loop:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loop
	ldx.b xsave
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.w #$2000
	sta.w printa
	lda.b d0
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w #$0020
	bcc .1x
	lda.w #$001F
.1x:
	sta.b d0
	ldy.w #$0002
	lda.w #$0006
	sta.w mesarea
	lda.w #$0003
	sta.b d3
.loop2:
	lda.w #$FFFF
	sta.b d2
	lda.b d0
	bmi .2x
	sta.b d2
	cmp.w #$0008
	bcc .2x
	lda.w #$0007
	sta.b d2
.2x:
	lda.b d2
	sec
	adc.b d1
	and.w #$00FF
	bne .3
	lda.w #$0020
.3:
	sta.w mesarea,y
	iny
	lda.b d0
	sec
	sbc.w #$0008
	sta.b d0
	dec.b d3
	bpl .loop2
	lda.b d1
	beq .4
	lda.w #$0C00
	tsb.w printa
.4:
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w printx
	sec
	sbc.w #$000B
	sta.w printx
	lda.w #$4000
	tsb.w printa
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	sep #$20
	lda.w mesarea+5
	ldy.w mesarea+2
	sty.w mesarea+5
	sta.w mesarea+2
	rep #$30
	lda.w mesarea+3
	xba
	sta.w mesarea+3
	lda.w #$4000
	trb.w printa
	pla
	sta.b a1+2
	pla
	sta.b a1
	stx.b xsave
	ldx.w #$000E
.loop3:
	pla
	sta.b d0,x
	dex
	dex
	bpl .loop3
	ldx.b xsave
	rtl
