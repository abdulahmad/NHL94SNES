; Script code %e: "extremely " (ScoutFragments) when the hot / cold totals differ by 8 or more ($1E43), else
; nothing
ScoutExtremely:
	inc.b a2
	lda.w hotextreme
	bne .t1
	jmp.w ScoutPlainWord

.t1:
	lda.w #ScoutFragments>>16
	sta.b a1+2
	lda.w #ScoutFragments
	sta.b a1
	jmp.w ScoutAppend
