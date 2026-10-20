; Print the label of the current period
;
; Called from printscores1. In overtime (gsp = 4) the label is printed one column to the left.
PrintPerLabel:						; prints the period label
	lda.w gsp						; game period
	sta.b d0						; d0 = label number
	cmp.w #$0004					; overtime?
	bne .list						; no: print it
	dec.w printx					; x - 1
	inc.b d0						; label after the period labels
.list:								; find label d0 in the list
	lda.w #PerLabels>>16			; a0 = PerLabels
	sta.b a0+2
	lda.w #PerLabels
	sta.b a0
.next:								; step through the labels
	lda.b a0+2						; a1 = the label a0 points at
	sta.b a1+2
	lda.b a0
	sta.b a1
	lda.b [a0]						; label length word
	clc
	adc.b a0
	sta.b a0
	dec.b d0						; until the label d0 is reached
	bpl .next
	jml.l print						; print it
