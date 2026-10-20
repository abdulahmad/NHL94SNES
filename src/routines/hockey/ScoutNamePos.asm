; Where the name of a player shown on the scouting report is printed
ScoutNamePos:						; Set the print position of a scouting report name; a2 = side (0 home)
	lda.b a1+2						; save a1 on the stack
	pha
	lda.b a1
	pha
	lda.w #ScoutNamePosAt>>16		; a1 = the name position record
	sta.b a1+2
	lda.w #ScoutNamePosAt+5			; skip to the position part of the record
	sta.b a1
	jsl.l print						; print probably sets printx / printy from it
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.b a2						; a2 = team side
	bne .rtl						; visitors (a2 nonzero) keep the position
	lda.w #$0014					; home: x column $14
	sta.w printx
.rtl:								; exit when the visitors use the record position
	rtl
