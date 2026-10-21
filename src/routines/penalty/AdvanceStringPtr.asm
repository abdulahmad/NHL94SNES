; a1 = string d0 of the string list [a1]
AdvanceStringPtr:					; called from DrawPeriodStats, DrawPlayerCard, EditLinesScreen, FillPen...
	bra .2
.1:									; loop: d0 still >= 0: a1 = a1 + [a1]
	lda.b a1
	clc
	adc.b [a1]						; plus the string length: next string
	sta.b a1
.2:									; decrement d0, if d0 still >= 0 go to .1, ...
	dec.b d0						; one less to skip
	bpl .1
	rtl
