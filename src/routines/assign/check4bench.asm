; If a line change wants player X off, send him to the bench
check4bench:
	lda.w pflags,x
	bit.w #$4000
	bne .t1
	lda.w newpos,x
	bpl .1
	lda.w newpnum,x
	bmi .t1
.1:
	lda.w newpnum,x
	cmp.w pnum,x
	beq .t2
	lda.w asscur,x
	cmp.w #$000C
	beq .t1
	cpx.w puckc
	beq .t1
	sep #$20
	pla
	rep #$30
	pla
	lda.w pflags,x
	ora.w #$1000
	sta.w pflags,x
	stz.w temp1,x
	lda.w #$000C
	sta.b d0
	jml.l assreplace

.t1:
	rtl

.t2:
	sep #$20
	pla
	rep #$30
	pla
	lda.w pflags,x
	and.w #$EFFF
	sta.w pflags,x
	stz.w pfnc,x
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	lda.w position
	sta.b d0
	jmp.w Setplass
