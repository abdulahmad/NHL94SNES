; End a string built in mesarea and set a1 to it
;
; Takes a1 = end of the text; called from PlayerInitialName and PlayerShortName.
MesAreaDone:						; end the string built in mesarea
	lda.b a1						; length word of the string = a1 - mesarea
	sec
	sbc.w #mesarea
	sta.w mesarea
	lda.w #mesarea					; a1 = mesarea
	sta.b a1
	rtl
