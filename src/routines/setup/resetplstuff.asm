; Reset the team variables and the players on both teams
resetplstuff:
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
	stx.b xsave
	ldx.w #$0000
.loop:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loop
	ldx.b xsave
	stz.b a2
	jsl.l .t1
	lda.w #$0002
	sta.b a2
	jsl.l .t1
	stx.b xsave
	ldx.w #$000E
.loop2:
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave
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
	ldx.b a3
	rtl

.t1:
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFEF
	sta.w tmflags,y
	lda.w #$0005
	sta.b d2
	ldx.w tmsort,y
	stx.b a3
.1:
	stz.w pf2aip,x
	lda.w pflags,x
	and.w #$2FFF
	sta.w pflags,x
	lda.w position,x
	bmi .3
	bne .t1x
	lda.w #SPAgready
	bra .2

.t1x:
	lda.w #SPAglide
.2:
	jsl.l SetSPAFromA
	stz.w impact,x
	stz.w nopuck,x
	lda.w pflags,x
	and.w #$FFF6
	sta.w pflags,x
	stz.w pfnc,x
	stz.w pfrev,x
	stz.w pfalock,x
.3:
	inc.b a3
	inc.b a3
	ldx.b a3
	dec.b d2
	bpl .1
	rtl
