; a2 holds or hooks X: both slow down, and a penalty may be called
holdcheck:
	lda.w position,x
	beq .t1
	lda.w pfalock,x
	bne .t1
	ldy.b a2
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
	lda.w puckc
	cmp.b a3
	bne .t2
	lda.w #$0008
	trb.w sflags
	bra .t2

.t1:
	rtl

.t2:
	lda.b d0
	sta.w facedir,y
	ldy.b a2
	lda.w Xvel,x
	clc
	adc.w Xvel,y
	pha
	asl a
	pla
	ror a
	sta.w Xvel,x
	sta.w Xvel,y
	lda.w Yvel,x
	clc
	adc.w Yvel,y
	pha
	asl a
	pla
	ror a
	sta.w Yvel,x
	sta.w Yvel,y
	tya
	sta.w impactp,x
	lda.w #SPAflail
	sta.w pfalock,x
	jsl.l SetSPAFromA
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	tya
	sta.w impactp,x
	lda.w #SPAHold2
	sta.w pfalock,x
	ldy.w SPA,x
	cpy.w #SPAHold
	beq .1
	lda.w #SPAhook2
.1:
	jsl.l SetSPAFromA
	jsl.l PenShotChk
	beq .t1x
	lda.w BA_Sktr_SCnum
	bpl .t1x
	ldy.b a2
	sty.w BA_Sktr_SCnum
	lda.w playerpad,y
	sta.w pspad
	lda.w #PenShot
	sta.b d0
	jsl.l AddPenalty
	bra .2

.t1x:
	jsl.l checkagr
	lda.b d0
	cmp.w #$0001
	bcs .2
	lda.w #$0028
	sta.b d0
	lda.w SPA,x
	cmp.w #SPAHold2
	beq .1x
	lda.w #PenHooking
	sta.b d0
.1x:
	jsl.l AddPenalty
.2:
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	lda.w #$FFFF
	sta.w collflag
	rtl
