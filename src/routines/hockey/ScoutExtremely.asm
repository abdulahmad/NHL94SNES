; Script code %e: "extremely " (ScoutFragments) when the hot / cold totals differ by 8 or more (hotextreme),
; else nothing
ScoutExtremely:						; Script code %e entry
	inc.b a2						; step past the code letter
	lda.w hotextreme				; hot / cold totals differ by 8 or more?
	bne .t1							; yes, print the word
	jmp.w ScoutPlainWord			; no, treat it as a plain word

.t1:								; the "extremely " fragment
	lda.w #ScoutFragments>>16
	sta.b a1+2
	lda.w #ScoutFragments
	sta.b a1						; type it via the shared append tail
	jmp.w ScoutAppend
