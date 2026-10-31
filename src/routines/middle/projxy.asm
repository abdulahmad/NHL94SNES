; Project a rink position to screen coordinates
projxy:								; called from setffo, setsortcords
	lda.w sfhormode
	beq .t1
	lda.b d0						; x
	pha								; keep x
	lda.b d1						; y
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b d0						; y negated
	pla
	sec
	sbc.w #$00C5					; minus $C5
	sta.b d1
	bra .1

.t1:								; sfhormode = 0: d0 = d0 - Hpos, d1 = d1 - Vpos
	lda.b d0						; normal mode: x minus Hpos
	sec
	sbc.w Hpos						; minus the scroll x
	sta.b d0
	lda.b d1
	sec								; y
	sbc.w Vpos						; minus the scroll y
	sta.b d1
.1:									; if d0 - $FF6F negative go to .t1x, ...
	lda.b d0
	cmp.w #$FF6F
	bmi .t1x
	cmp.w #$0091
	bpl .t1x
	lda.b d0
	clc
	adc.w #$0080					; center on screen x 128
	sta.b d0
	lda.b d2						; d1 += 1.5 * z
	asl a
	clc
	adc.b d2
	pha
	asl a
	pla
	ror a
	clc
	adc.b d1						; plus y
	sta.b d1
	cmp.w #$FF6F
	bmi .t1x
	cmp.w #$0091
	bpl .t1x
	lda.w #$0070					; center y $70
	sec
	sbc.b d1						; screen y
	sta.b d1
	rtl

.t1x:								; d1 = $4E20, return
	lda.w #$4E20
	sta.b d1
	rtl
