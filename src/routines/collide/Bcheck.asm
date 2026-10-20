; Player a2 body checks a3: a3 falls if he is in front, and a charging penalty may be called
Bcheck:								; called from checkcheck
	ldy.b a2						; y = the checker
	lda.w pfalock,x					; animation locked?
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
.1:									; d0 = Xpos,x - Xpos,y, d1 = Ypos,x - Ypos,y, call vtoa, ...
	lda.w Xpos,x					; x of X
	sec
	sbc.w Xpos,y					; minus the checker's x
	sta.b d0
	lda.w Ypos,x					; y of X
	sec
	sbc.w Ypos,y					; minus the checker's y
	sta.b d1
	jsl.l vtoa						; vector to direction
	ldy.b a2						; checker
	lda.b d0						; within one direction of a2 facing
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

.t1:								; return
	rtl

.t2:								; call checkagr, if d0 >= $0005 go to .2, ...
	jsl.l checkagr					; aggression check
	lda.b d0
	cmp.w #$0005					; aggression under 5?
	bcs .2
	lda.w #PenTripping				; penalty $20
	sta.b d0
	jsl.l AddPenalty				; call it
.2:									; a2 = a3, a3 = a2, collflag = $FFFF, ...
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
	lda.w #$FFFF
	sta.w collflag
	rtl
