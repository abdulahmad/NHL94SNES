; Clear team a2's offsides flag once none of its skaters is past the blue line
ClearOffsidesIfAllPlayers:
	ldy.b a2
	lda.w tmflags,y
	bit.w #tmfoside
	bne .t1
	jmp.w ChkOffsides_rtl

.t1:
	lda.w tmsort,y
	sta.b a0
	lda.w #$0005
	sta.b d1
.2:
	ldy.b a0
	lda.w position,y
	bmi .1
	lda.w Ypos,y
	sta.b d0
	lda.w pfgoal,y
	bne .1
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1:
	inc.b a0
	inc.b a0
	lda.b d0
	sec
	sbc.w #$0058
	bmi .t1x
	jmp.w ChkOffsides_rtl

.t1x:
	dec.b d1
	bpl .2
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFEF
	sta.w tmflags,y
	rtl
