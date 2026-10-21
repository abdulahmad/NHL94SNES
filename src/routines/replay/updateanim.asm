; Step object X's sprite animation, looping or ending it
updateanim:							; called from SetSPAUpdate, assbreakaway, puckfaceoff2, updateplayers
	lda.w SPA,x
	bne .2
	stz.w pf2aip,x
	stz.w pfalock,x
	rtl
.1:									; sfhormode != 0: if carry set go to .3, ...
	cpx.w #$0018
	bcs .3
	lda.w attribute,x
	bit.w #$0800
	beq .t1
	lda.w #$0002
	sec
	sbc.w facedir,x
	bra .7

.t1:								; attribute,x bits $0800 clear: go to .7
	lda.w facedir,x
	dec a
	dec a
	bra .7
.2:									; SPA,x != 0: a0 = long A, d1 = [a0],y, ...
	phy
	sta.b a0
	lda.w #SPAlist>>16
	sta.b a0+2
	ldy.w #$0010
	lda.b [a0],y
	sta.b d1
	lda.w sfhormode
	bne .1
.3:									; if SPA,x >= SPAbenchcheckr go to .t1x, ...
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

.t1x:								; falls through
	lda.w facedir,x
.7:									; and #$0007, asl a, a0 = [a0],y, ...
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
.1x:								; if d1 != 0 go to .2x, ...
	lda.b d1
	bne .2x
	stz.w SPA,x
.2x:								; Y + 1, Y + 1, if [a0],y bits $8000 clear go to .3x, ...
	ldy.b d0
	iny
	iny
	lda.b [a0],y
	bit.w #$8000
	beq .3x
	eor.w #$FFFF					; negate: two's complement
	inc a
.3x:								; SPAcnt,x = A
	sta.w SPAcnt,x
.4:									; frame,x = d2
	lda.b d2
	sta.w frame,x
.5:									; return
	ply
	rtl
.6:									; Xpos,x = $FF78, facedir,x = $0002, pfalock,x = $0002, ...
	lda.w #$FF78
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallright
	jsl.l SetSPAUpdate
	bra .5
