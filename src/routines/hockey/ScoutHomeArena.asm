; Script code %r: the home arena (the fourth team String)
ScoutHomeArena:						; Script code %r entry
	lda.w tmdata					; a1 = home team data
	sta.b a1
	lda.w #TeamList>>16				; bank of the team strings
	sta.b a1+2
	ldy.w #$0004					; y = offset of the string table
	lda.b a1						; a1 += [a1+4], the start of the strings
	clc
	adc.b [a1],y
	sta.b a1
	lda.b d0
	pha								; keep the column in d0 across the call
	lda.w #$0003
	sta.b d0						; skip 3 strings (city, name, nickname)
	jsl.l AdvanceStringPtr
	pla								; AdvanceStringPtr leaves a1 at the arena string
	sta.b d0						; restore the column
	jmp.w ScoutAppend
; append and type it