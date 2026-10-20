; Script code %h: the home city (the first team String)
ScoutHomeCity:						; Script code %h entry
	lda.w tmdata					; a1 = home team data
	sta.b a1
ScoutTeamCity:						; shared by the city codes: a1 = team data
	lda.w #$009C					; bank of the team strings
	sta.b a1+2
	ldy.w #$0004					; y = offset of the string table
	lda.b a1						; a1 += [a1+4], the start of the strings (the city comes first)
	clc
	adc.b [a1],y
	sta.b a1
ScoutAppend:						; Append the string at a1 to a fresh mesarea and type it
	lda.w #mesarea>>16				; a3 = mesarea
	sta.b a3+2
	lda.w #mesarea
	sta.b a3
	lda.w #$0002					; start a fresh string (length word 2)
	sta.b [a3]
	jsl.l appstring					; append the string
	lda.w #mesarea>>16				; a1 = mesarea, the text to type
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
ScoutTypeText:						; Type the string at a1 word by word; d0 = column, d1 = length, words wrap
									; at 20 columns
	ldy.w #$0003					; y = index of the second character
.loop:								; scan for a space
	lda.b [a1],y
	and.w #$00FF					; is it a space?
	cmp.w #$0020
	bne .2							; no, next character
	lda.b [a1]						; yes: keep the length word on the stack
	pha
	tya								; d4 = number of characters before the space
	dec a
	dec a
	sta.b d4
	tya								; cut the string at the space: length word = y
	sta.b [a1]
	lda.b a1						; save a1
	pha
	jsl.l .3						; type the cut word (.3 below)
	dec.w PlayerScrollCtr			; that call counted one word too many
	pla								; restore a1
	sta.b a1
	lda.b a1
	clc								; a1 += d4, so the rest of the text (space first) gets a new length word
	adc.b d4
	sta.b a1
	pla								; new length word = old length - d4
	sec
	sbc.b d4
	sta.b [a1]
	lda.b d0						; column past 20?
	cmp.w #$0015
	bmi .1							; no
	lda.b d4						; yes: the word went to a new line, column = its length
	sta.b d0
.1:									; restart the scan after the space
	ldy.w #$0002
.2:									; next character
	iny								; y = index of the next character
	tya
	cmp.b [a1]						; inside the string?
	bmi .loop						; yes, keep scanning
.3:									; Type the last word: update column d0 and length d1
	inc.w PlayerScrollCtr			; one more word typed
	lda.b d0
	clc								; column += string length - 1
	adc.b [a1]
	dec a
	sta.b d0
	lda.b [a1]						; d1 = string length - 2
	dec a							; y = index of the last character
	tay
	dec a
	sta.b d1
	lda.b [a1],y
	and.w #$00FF					; last character
	beq .t1							; a zero (terminator) is not printed
	jmp.w ScoutTypeWord				; type the word

.t1:								; one character less
	dec.b d1
	jmp.w ScoutTypeWord
