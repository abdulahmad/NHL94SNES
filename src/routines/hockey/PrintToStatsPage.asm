; Print string [a1] at printx / printy into the stats page buffer ($7F2780, 32 wide) through the SmallFontMap
; character map
PrintToStatsPage:
	phx
	lda.w #$0020
	sta.b r7
	lda.b [a1]
	dec a
	dec a
	sta.b r6+2
	inc.b a1
	inc.b a1
	lda.b a1+2
	sta.b p0+2
	lda.b a1
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$2780
	sta.b p1
	ldy.w printy
	ldx.w printx
	lda.l smallfontchars
	clc
	adc.l printfontset
	ora.w printa
	jsl.l .t1
	plx
	rtl

.t1:
	sta.b r7+2
	stx.b r5
	tya
	asl a
	ldx.b r7
	jsl.l Mul16U
	lda.b r5
	asl a
	clc
	adc.b r2
	adc.b p1
	sta.b p1
	ldy.w #$0000
.loop:
	lda.b [p0]
	and.w #$00FF
	beq .2
	asl a
	tax
	lda.l SmallFontMap+6,x
	clc
	adc.b r7+2
	sta.b [p1],y
	iny
	iny
	inc.b p0
	dec.b r6+2
	bne .loop
.1:
	rtl
.2:
	dex
	bmi .1
	lda.w #$0020
	clc
	adc.b r7+2
	sta.b [p1],y
	iny
	iny
	inc.b p0
	bra .2
