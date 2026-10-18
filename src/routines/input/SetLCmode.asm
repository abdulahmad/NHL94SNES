; Open the line change box for player X's team, when line changes are on and the box is not open
SetLCmode:
	lda.l OptLine
	cmp.w #$0001
	bne .t1
	jsl.l loadTeamStruct
	ldy.b a2
	lda.w tmflags,y
	bit.w #$0008
	bne .t1
	ora.w #$0008
	sta.w tmflags,y
	lda.w #$000C
	trb.w sflags
	jmp.w SetLCmode2

.t1:
	rtl
