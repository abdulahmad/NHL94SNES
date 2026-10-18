; Player a2 body checks a3: a3 falls if he is in front, and a charging penalty may be called
Bcheck:
	ldy.b a2
	lda.w pfalock,x
	bne .t1
	lda.w position,x
	beq .t1
	lda.l OptPen
	bne .1
	lda.w playerpad,y
	bmi .1
	lda.w #$0010
	clc
	adc.w aggress,y
	sec
	sbc.w legstr,x
	jsl.l randoma8
	cmp.w #$000C
	bcc .t1
.1:
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	ldy.b a2
	lda.b d0
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .t1
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	jsl.l FallDown
	jsl.l PenShotChk
	beq .t2
	lda.w BA_Sktr_SCnum
	bpl .t2
	ldy.b a2
	sty.w BA_Sktr_SCnum
	lda.w playerpad,y
	sta.w pspad
	lda.w #PenShot
	sta.b d0
	jsl.l AddPenalty
	bra .2

.t1:
	rtl

.t2:
	jsl.l checkagr
	lda.b d0
	cmp.w #$0005
	bcs .2
	lda.w #PenTripping
	sta.b d0
	jsl.l AddPenalty
.2:
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	lda.w #$FFFF
	sta.w collflag
	rtl
