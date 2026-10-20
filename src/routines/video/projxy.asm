; Project a rink position to screen coordinates
projxy:								; called from setffo, setsortcords
	lda.w sfhormode
	beq .t1
	lda.b d0
	pha
	lda.b d1
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b d0
	pla
	sec
	sbc.w #$00C5
	sta.b d1
	bra .1

.t1:								; sfhormode = 0: d0 = d0 - Hpos, d1 = d1 - Vpos
	lda.b d0
	sec
	sbc.w Hpos
	sta.b d0
	lda.b d1
	sec
	sbc.w Vpos
	sta.b d1
.1:									; if d0 - $FF6F negative go to .t1x, ...
	lda.b d0
	cmp.w #$FF6F
	bmi .t1x
	cmp.w #$0091
	bpl .t1x
	lda.b d0
	clc
	adc.w #$0080
	sta.b d0
	lda.b d2
	asl a
	clc
	adc.b d2
	pha
	asl a
	pla
	ror a
	clc
	adc.b d1
	sta.b d1
	cmp.w #$FF6F
	bmi .t1x
	cmp.w #$0091
	bpl .t1x
	lda.w #$0070
	sec
	sbc.b d1
	sta.b d1
	rtl

.t1x:								; d1 = $4E20, return
	lda.w #$4E20
	sta.b d1
	rtl
