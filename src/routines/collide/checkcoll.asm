; Move object X to its new x / y, checking wall and player collisions
checkcoll:
	stz.w collflag
	lda.w sfhormode
	beq .1
	lda.b d2
	ldy.b d3
	sty.b d2
	sta.b d3
.1:
	lda.w pfnc,x
	bne .3
	lda.b d3
	pha
	lda.b d2
	pha
	lda.w Xpos,x
	sta.b d2
	lda.w Ypos,x
	sta.b d3
	lda.w radiusx,x
	sta.w wcradiusx
	lda.w radiusy,x
	sta.w wcradiusy
	jsl.l checkwallcoll
	lda.w Wallcos,x
	ora.w Wallsin,x
	bne .2
	cpx.w #$0018
	bcs .2
	txa
	jsl.l GetHot
	lda.w Xpos,x
	clc
	adc.b d0
	sta.b d2
	lda.w Ypos,x
	clc
	adc.b d1
	sta.b d3
	lda.w #$0001
	sta.w wcradiusx
	sta.w wcradiusy
	jsl.l checkwallcoll
.2:
	pla
	sta.b d2
	pla
	sta.b d3
	lda.w position,x
	bmi .3
	jsl.l checkplcoll
.3:
	lda.w collflag
	beq .t2
	jmp.w .t3

.t2:
	lda.w OOlistpos,x
	sta.b d1
.loop:
	ldy.b d1
	cpy.w #$000F
	beq .t1
	lda.w OOlist+1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	beq .t1
	bmi .t1
	inc.w OOlistpos,x
	lda.w OOlistpos,y
	dec a
	sta.w OOlistpos,y
	sep #$30
	ldy.b d1
	lda.b d4
	sta.w OOlist,y
	txa
	sta.w OOlist+1,y
	rep #$30
	inc.b d1
	bra .loop

.t1:
	lda.w OOlistpos,x
	beq .1x
	sta.b d1
.loopx:
	ldy.b d1
	lda.w OOlist-1,y
	and.w #$00FF
	sta.b d4
	tay
	lda.b d3
	sec
	sbc.w Ylist,y
	bpl .1x
	dec.w OOlistpos,x
	lda.w OOlistpos,y
	inc a
	sta.w OOlistpos,y
	sep #$30
	ldy.b d1
	lda.b d4
	sta.w OOlist,y
	txa
	sta.w OOlist-1,y
	rep #$30
	dec.b d1
	bne .loopx
.1x:
	lda.b d3
	sta.w Ylist,x
	rtl

.t3:
	lda.w SPA,x
	cmp.w #SPAboardfront
	bcs .rtl
	lda.w OldXpos,x
	sta.w Xpos,x
	lda.w OldYpos,x
	sta.w Ypos,x
.rtl:
	rtl
