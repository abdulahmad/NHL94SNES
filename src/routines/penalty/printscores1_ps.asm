; Print team a2's name, then its score as two characters
;
; Called from printscores1. Prints the name via printscores1_ps_name, then the score modulo 100 as two digits.
printscores1_ps:				; prints a team and its score
	jsl.l printscores1_ps_name				; print the name
	ldy.b a2						; team a2
	lda.w tmscore,y					; its score
	sta.b d0
	jsl.l Mod100					; modulo 100
	lda.w #mesarea>>16				; a1 = mesarea
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0004					; length 4
	sta.b [a1]
	lda.w #$0020					; blank in the tens place
	sta.w mesarea+2
	lda.b d0						; d0 = score
	sta.b r2
	lda.w #$000A					; divide by 10
	sta.b r1
	phx								; keep x
	jsl.l Div16x8U					; divide
	plx								; restore x
	lda.b r0						; tens digit
	beq .1							; below 10: keep the blank
	adc.w #$0030					; else tens digit character
	sta.w mesarea+2
.1:									; ones digit
	lda.w RDMPYL
	adc.w #$0030					; ones digit character
	sta.w mesarea+3
	jml.l print						; print it
