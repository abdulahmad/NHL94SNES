; Script code %m: the visitors nickname (the third team String)
ScoutVisNick:						; Script code %m entry
	lda.w tmdata+2					; a1 = visitors team data
	sta.b a1
	bra ScoutTeamNick				; share the nickname lookup

; Script code %n: the home nickname (the third team String)
ScoutHomeNick:						; Script code %n entry
	lda.w tmdata					; a1 = home team data
	sta.b a1
ScoutTeamNick:						; shared by the nickname codes: a1 = team data
	lda.w #$009C					; bank of the team strings
	sta.b a1+2
	ldy.w #$0004					; y = offset of the string table
	lda.b a1						; a1 += [a1+4], the start of the strings
	clc
	adc.b [a1],y
	sta.b a1
	lda.b d0						; keep the column in d0 across the call
	pha
	lda.w #$0002					; skip 2 strings (city, name)
	sta.b d0
	jsl.l AdvanceStringPtr			; a1 is now at the nickname string
	pla								; restore the column
	sta.b d0
	jmp.w ScoutAppend				; append and type it
