; mesarea = the number, first initial and last name of roster player d0 of team a2
PlayerShortName:					; called from GetPlayerNumInitial, PrintLineSlotName, ShowGoalBox, seto...
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b a2
	pha
	lda.b a2+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	jsl.l GetPlayerRecord			; a0 = the roster record of player d0 of team a2
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0002
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	sta.b d0
	jsl.l PutDigits2				; write the two digit number d0 as two characters at [a1]
	lda.w #$0020
	sta.b [a1]
	inc.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	lda.b [a0]
	sta.b d0
	clc
	adc.b a0
	sta.b a2
	lda.b a0+2
	sta.b a2+2
	inc.b a0
	inc.b a0
	lda.b [a0]
	inc.b a0
	sta.b [a1]
	inc.b a1
	lda.w #$002E
	sta.b [a1]
	inc.b a1
	lda.w #$0020
	sta.b [a1]
	inc.b a1
.loop:								; loop: increment a0, if not zero go to .loop
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	cmp.w #$0020
	bne .loop
.loop2:								; loop: increment a0, [a1] = [a0], increment a1, ...
	lda.b [a0]
	inc.b a0
	sta.b [a1]
	inc.b a1
	lda.b a0
	cmp.b a2
	bne .loop2
	jsl.l MesAreaDone				; end the string built in mesarea
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b a2+2
	pla
	sta.b a2
	pla
	sta.b d0+2
	pla
	sta.b d0
	rtl
