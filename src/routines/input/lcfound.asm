; Change team a2 to the chosen line
lcfound:
	ldx.b a3
	ldy.b a2
	lda.b d2
	sta.b d0
	sta.w tmlcchoice,y
	jsl.l getlchoice
	lda.b d0
	bmi .t1
	lda.w pflags,x
	ora.w #$0008
	sta.w pflags,x
	jsl.l loadTeamStruct
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFF7
	sta.w tmflags,y
	lda.b d0
	sta.w tmline,y
	lda.w #$FFFF
	sta.w lcpad,y
	jsl.l setpersonel
	jmp.w lcfound2

.t1:
	rtl
