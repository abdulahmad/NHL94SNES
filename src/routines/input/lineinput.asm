; Pad input while the line change box is open
lineinput:
	lda.b d1
	pha
	stz.b a2
	lda.w pfteam,x
	beq .1
	inc.b a2
	inc.b a2
.1:
	ldy.b a2
	lda.w tmflags,y
	bit.w #$0001
	beq .2
	and.w #$FFFE
	sta.w tmflags,y
	lda.w #$FFFF
	sta.w lcpad,y
	jsl.l lcfound2
	jsl.l SetLCmode2
.2:
	pla
	sta.b d1
	stz.b d2
	bit.w #$4000
	bne .t3
	inc.b d2
	bit.w #$8000
	bne .t3
	inc.b d2
	bit.w #$0080
	bne .t3
	bit.w #$2000
	bne .t2
	lda.w pflags,x
	bit.w #$0008
	beq .t1
	lda.w pfalock,x
	bne .t1
	jml.l doplayeracc

.t1:
	rtl

.t2:
	lda.w pflags,x
	ora.w #$0008
	sta.w pflags,x
	jsl.l loadTeamStruct
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFF7
	sta.w tmflags,y
	lda.w #$FFFF
	sta.w lcpad,y
	jmp.w lcfound2

.t3:
	jmp.w lcfound
