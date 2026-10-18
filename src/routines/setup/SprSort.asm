; Sort the objects by screen position for drawing
SprSort:
	phx
	phy
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
	ldx.w #$0000
	lda.w sfhormode
	bne .1
.loop0:
	lda.w Ypos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .loop0
	bra .2
.1:
	lda.w Xpos,x
	sta.w Ylist,x
	inx
	inx
	cpx.w #$0020
	bne .1
.2:
	stz.b d2
	ldx.w #$0000
.loop:
	lda.w OOlist+1,x
	and.w #$00FF
	sta.b d1
	lda.w OOlist,x
	and.w #$00FF
	sta.b d0
	tay
	lda.w Ylist,y
	ldy.b d1
	cmp.w Ylist,y
	bmi .1x
	beq .1x
	lda.w OOlist,x
	xba
	sta.w OOlist,x
	txa
	sta.w OOlistpos,y
	inc a
	ldy.b d0
	sta.w OOlistpos,y
	inc.b d2
.1x:
	inx
	cpx.w #$000F
	bne .loop
	lda.b d2
	bne .2
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
	ply
	plx
	rtl
