; Copy the next plain script word into mesarea and type it (not a % code)
ScoutPlainWord:						; plain text word: a2 = script text, d0 = column
	lda.w #$FFFF					; no word typed yet
	sta.w PlayerScrollCtr
	lda.w #mesarea>>16				; a0 = mesarea+2, where the text bytes go
	sta.b a0+2
	lda.w #mesarea+2
	sta.b a0
	stz.b d1						; d1 = characters copied
.loop:								; next character of the script
	lda.b [a2]
	and.w #$00FF
	cmp.w #$000D					; carriage return ends the text
	beq .3
	inc.b d0						; one more column used
.loop2:								; copy the character, then look at the next
	sep #$20						; 8-bit A to copy one byte
	lda.b [a2]						; copy the character into mesarea
	sta.b [a0]
	rep #$30
	inc.b a0						; advance the destination
	inc.b d1						; count it
	lda.b [a2]						; a "," or "." adds a pause to the report timer
	and.w #$00FF
	cmp.w #$002C
	beq .1
	cmp.w #$002E
	bne .2							; neither, no pause
.1:									; add 40 to ScoutingReportTimer
	lda.w ScoutingReportTimer
	clc
	adc.w #$0028
	sta.w ScoutingReportTimer
.2:									; next script character
	lda.b [a2]
	inc.b a2						; step the script pointer
	and.w #$00FF
	cmp.w #$0020					; a space ends the word
	bne .loop
	lda.b [a2]						; copy any extra spaces that follow
	and.w #$00FF
	cmp.w #$0020
	beq .loop2
	lda.b a2						; a2 = offset of the script position from a1
	sec
	sbc.b a1
	sta.b a2
	sta.w PlayerScrollCtr			; remember it in PlayerScrollCtr
.3:									; set the string length word
	lda.b d1
	inc a
	inc a
	sta.w mesarea					; length = characters + 2
	lda.w #mesarea>>16				; a1 = mesarea
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
ScoutTypeWord:						; Type the word at a1: d0 = column, d1 = characters
	lda.b d0						; column minus 20
	sec
	sbc.w #$0014
	beq .3							; exactly 20: fits
	bmi .2							; below 20: fits (check overflow)
	bvs .3							; overflow: fits
.1:									; past column 20: start a new line
	jsl.l ScrollDisplayUp			; scroll the scouting text up
	bra .3							; then print
.2:									; below 20 and overflow means past it
	bvs .1
.3:									; at the start of a line (DispAttribCtr zero)?
	lda.w DispAttribCtr
	bne .t1							; no, print
	ldy.w #$0002					; y = index of the first character
.loop:								; next character of the word
	lda.b [a1],y					; drop leading spaces of the word
	and.w #$00FF
	cmp.w #$0020					; not a space: stop
	bne .t1
	lda.b [a1]						; shorten the length word
	dec a
	inc.b a1						; advance the string start
	sta.b [a1]
	dec.b d1						; one character less
	iny
	bra .loop

.t1:								; print the word
	lda.b a1+2						; keep a1 on the stack
	pha
	lda.b a1
	pha
	lda.w #ScoutNamePosAt>>16		; a1 = the name position record
	sta.b a1+2
	lda.w #ScoutNamePosAt
	sta.b a1
	jsl.l print						; print it (sets printx / printy)
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w DispAttribCtr				; x = position + characters already on the line
	clc
	adc.w printx
	sta.w printx
	lda.w VertLineScrolling			; y = position + lines scrolled
	clc
	adc.w printy
	sta.w printy
	jsl.l print						; print the word at that position
	lda.w DispAttribCtr				; advance the line column by the word length
	clc
	adc.b d1
	sta.w DispAttribCtr
	rtl								; done
