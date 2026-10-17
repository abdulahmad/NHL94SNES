; sound driver command $02 (the sample count and the free sound RAM pointer); returns its answers in A (a
; byte) and X
SPCCmd02:
	sep #$20
.wait:
	lda.w APUIO0
	bne .wait
	lda.b #$02
	sta.w APUIO0
.ack:
	cmp.w APUIO0
	bne .ack
	lda.w APUIO1
	tay
	lda.b #$80
	sta.w APUIO0
.ack2:
	cmp.w APUIO0
	bne .ack2
	ldx.w APUIO1
	stz.w APUIO0
	rep #$20
	tya
	and.w #$00FF
	rtl
