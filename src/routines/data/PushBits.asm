; password bits = password bits * d1 + d0
;
; Takes d0 = the value to add and d1 = the multiplier. Saves and restores d0 and d1 (both words). Called from
; WritePassBits.
PushBits:							; passbits = passbits * d1 + d0
	lda.b d0						; save d0 and d1
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d0						; swap d0 and d1
	ldx.b d1
	sta.b d1
	stx.b d0
	jsl.l SuperMult					; passbits *= d0
	stz.b d0+2						; d0 high word 0
	lda.b d1						; old d0
	sta.b d0
	jsl.l SuperAdd					; passbits += d0
	pla								; restore d1 and d0
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	rtl
