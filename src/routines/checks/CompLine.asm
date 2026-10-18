; The computer team picks a line by the man advantage, the score and the line energies
CompLine:
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
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.w #$0003
	sta.b d0
	ldy.b a2
	lda.w tmap,y
	ldy.b a1
	cmp.w tmap,y
	beq .4
	bpl .1
	inc.b d0
	inc.b d0
.1:
	lda.b d0
	pha
	jsl.l getlinee
	lda.b d0
	sta.b d1
	lda.b r0+1,s
	inc a
	sta.b d0
	jsl.l getlinee
	lda.b d1
	sec
	sbc.b d0
	bpl .2
	pla
	inc a
	pha
.2:
	pla
	ldy.b a2
	sta.w tmline,y
.3:
	pla
	sta.b a0+2
	pla
	sta.b a0
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
	rtl
.4:
	ldy.b a2
	beq .t2
	jmp.w .6

.t2:
	lda.l OptLine
	cmp.w #$0002
	bne .t1
	lda.w c1playernum,y
	bmi .t1
	jmp.w .6

.t1:
	lda.w #$0002
	sta.b d1
	lda.w #$009F
	sta.b a0+2
	lda.w #.5
	sta.b a0
	lda.w gsp
	cmp.w #$0002
	bne .1x
	lda.w tmscore,y
	ldy.b a1
	cmp.w tmscore,y
	beq .1x
	php
	lda.w #$009F
	sta.b a0+2
	lda.w #.5+14
	sta.b a0
	plp
	bpl .1x
	lda.w #$009F
	sta.b a0+2
	lda.w #.5+28
	sta.b a0
.1x:
	ldy.b a1
	lda.w tmline,y
	asl a
	sta.b d1
	tay
	lda.b [a0],y
	sta.b d0
	jsl.l getlinee
	lda.b d0
	cmp.w #$0C01
	bcc .6
	ldy.b d1
	lda.b [a0],y
	ldy.b a2
	sta.w tmline,y
	jmp.w .3
.5:
	dw 0,1,2,0,1,0,1
	dw 2,0,1,2,0,2,0
	dw 0,1,0,0,1,0,1
.6:
	lda.w #$0002
	sta.b d1
	lda.w #$009F
	sta.b a0+2
	lda.w #.7
	sta.b a0
	lda.w gsp
	cmp.w #$0002
	bne .1xx
	ldy.b a2
	lda.w tmscore,y
	ldy.b a1
	cmp.w tmscore,y
	beq .1xx
	php
	lda.w #$009F
	sta.b a0+2
	lda.w #.7+6
	sta.b a0
	plp
	bpl .1xx
	lda.w #$009F
	sta.b a0+2
	lda.w #.7+12
	sta.b a0
.1xx:
	lda.b [a0]
	inc.b a0
	inc.b a0
	sta.b d0
	jsl.l getlinee
	lda.b d0
	cmp.w #$0F34
	bcs .2x
	dec.b d1
	bpl .1xx
.2x:
	dec.b a0
	dec.b a0
	ldy.b a2
	lda.b [a0]
	sta.w tmline,y
	jmp.w .3
.7:
	dw 0,1,2,0,2,1,0,1,0
