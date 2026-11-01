; Move the roster attribute column by d0 and redraw.
; Takes d0 = signed column step. Shows the column DispAttribCtr + d0 when that is not negative.
;
; Called from TeamRosterScreen.
MoveRosterColumn:					; step the roster column
	lda.b d0
	clc
	adc.w DispAttribCtr
	sta.b d0
	bmi TeamRosterShowLine
	sta.w DispAttribCtr
	jsl.l ShowRosterLine			; print the roster line with the chosen attribute
	bra TeamRosterShowLine
