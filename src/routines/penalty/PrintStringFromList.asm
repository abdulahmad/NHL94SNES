; Print string d0 of the string list [a1]
;
; Prints string d0 of the string list [a1]; each string starts with its length word.
; Called from AttribStatus, AttribHanded, puckfaceoff2, setoptions, SetLCmode2, NewTicker3 and printscores1.
PrintStringFromList:				; prints a string from a list
	lda.b d0						; keep the number
	sta.b p1
.1:									; count down the list
	lda.b d0
	bne .t1							; at the string
	jmp.w print						; print it

.t1:								; skip a string
	lda.b [a1]						; length word
	clc
	adc.b a1
	sta.b a1
	dec.b d0						; one fewer
	bra .1							; next
