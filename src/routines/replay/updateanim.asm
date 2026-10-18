; Step object X's sprite animation, looping or ending it
updateanim:
	lda.w SPA,x
	bne .2
	stz.w pf2aip,x
	stz.w pfalock,x
	rtl
.1:
	cpx.w #$0018
	bcs .3
	lda.w attribute,x
	bit.w #$0800
	beq .t1
	lda.w #$0002
	sec
	sbc.w facedir,x
	bra .7

.t1:
	lda.w facedir,x
	dec a
	dec a
	bra .7
.2:
	phy
	sta.b a0
	lda.w #$009D
	sta.b a0+2
	ldy.w #$0010
	lda.b [a0],y
	sta.b d1
	lda.w sfhormode
	bne .1
.3:
	lda.w SPA,x
	cmp.w #SPAbenchcheckr
	bcs .t1x
	lda.w attribute,x
	bit.w #$0800
	beq .t1x
	lda.w #$0000
	sec
	sbc.w facedir,x
	bra .7

.t1x:
	lda.w facedir,x
.7:
	and.w #$0007
	asl a
	tay
	lda.b [a0],y
	sta.b a0
	ldy.w SPAnum,x
	sty.b d0
	lda.b [a0],y
	sta.b d2
	lda.w SPAcnt,x
	bmi .2x
	sec
	sbc.w timestep
	sta.w SPAcnt,x
	bpl .4
	lda.w SPAnum,x
	clc
	adc.w #$0004
	sta.w SPAnum,x
	sta.b d0
	iny
	iny
	lda.b [a0],y
	cmp.w #$0000
	bpl .2x
	stz.b d0
	stz.w SPAnum,x
	stz.w pf2aip,x
	stz.w pfalock,x
	lda.w SPA,x
	cmp.w #SPAunused1
	bcs .1x
	cmp.w #SPAbenchcheckr
	bcs .6
.1x:
	lda.b d1
	bne .2x
	stz.w SPA,x
.2x:
	ldy.b d0
	iny
	iny
	lda.b [a0],y
	bit.w #$8000
	beq .3x
	eor.w #$FFFF
	inc a
.3x:
	sta.w SPAcnt,x
.4:
	lda.b d2
	sta.w frame,x
.5:
	ply
	rtl
.6:
	lda.w #$FF78
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallright
	jsl.l SetSPAUpdate
	bra .5
