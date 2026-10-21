; The next line of the scouting report; scroll the text box up when it is full
;
; Takes nothing, returns rtl. Called from UpdateScoutingDisplay and ScoutPlainWord. Counts lines in
; VertLineScrolling; once 8 lines are on the screen it moves the 8 text rows up one row.
ScrollDisplayUp:					; scroll the scouting text up
	stz.w DispAttribCtr				; back to column 0
	inc.w VertLineScrolling			; one more line printed
	lda.w VertLineScrolling
	sec
	sbc.w #$0008					; lines minus 8
	bmi .2							; negative: check overflow
	bvc .3							; no overflow: fewer than 8 lines
.1:									; fewer than 8 lines: nothing to scroll
	jmp.w UpdateScoutingDisplay_rtl
.2:									; negative with overflow: fewer than 8 lines
	bvc .1
.3:									; box is full: scroll the text up
	dec.w VertLineScrolling			; undo the increment: the count stays at 8
	lda.w #$0007					; 8 rows (r3 counts 7 to 0)
	sta.b r3
	lda.w #$007E					; p1 = text map row at textmap+$384
	sta.b p1+2
	lda.w #$3B78
	sta.b p1
	lda.b p1+2						; p0 bank = same
	sta.b p0+2
.loop:								; move one row up
	ldx.w #$0028
	lda.b p1						; p0 = p1 + $40: the row below
	clc
	adc.w #$0040
	sta.b p0
	jsl.l MemCopy					; copy $28 bytes up one row
	lda.b p0						; the row below is the next destination
	sta.b p1
	dec.b r3						; next row
	bpl .loop
	rtl
