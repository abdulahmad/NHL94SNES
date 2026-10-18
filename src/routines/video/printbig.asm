; Print with the big font (2 by 2 tiles per character)
printbig:
	phx
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	ldy.w #$0002
.7:
	tya
	cmp.b [a1]
	bne .t3
	jmp.w .9

.t3:
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	sta.b d1
	lda.b [a1],y
	bit.w #$0080
	beq .t1
	jmp.w .8

.t1:
	and.w #$00FF
	bne .t2
	jmp.w .5

.t2:
	cmp.w #$0061
	bcc .1x
	cmp.w #$007B
	bcs .1x
	adc.w #$FFE0
.1x:
	sec
	sbc.w #$0020
	bne .t1x
	jmp.w .6

.t1x:
	stz.b d2
	inc.b d2
	tax
	lda.l BigFontIndex,x
	and.w #$00FF
	bit.w #$0080
	beq .1xx
	ora.w #$FF00
.1xx:
	cmp.w #$0000
	bpl .2
	eor.w #$FFFF
	inc a
	stz.b d2
.2:
	asl a
	sta.b d0
	tax
	lda.l BigFontMap+6,x
	clc
	adc.l BigFontChars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap,x
	txa
	lsr a
	cmp.w textdirtylo
	bcs .3
	sta.w textdirtylo
.3:
	clc
	adc.w #$0021
	cmp.w textdirtyhi
	bcc .4
	sta.w textdirtyhi
.4:
	ldx.b d0
	lda.l BigFontMap+$9E,x
	clc
	adc.l BigFontChars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+$40,x
	lda.b d2
	beq .1
	ldx.b d0
	lda.l BigFontMap+8,x
	clc
	adc.l BigFontChars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+2,x
	ldx.b d0
	lda.l BigFontMap+$A0,x
	clc
	adc.l BigFontChars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+$42,x
	inc.w printx
.1:
	inc.w printx
.5:
	iny
	jmp.w .7
.6:
	lda.l BigFontMap+$32
	clc
	adc.l BigFontChars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap,x
	sta.l textmap+$40,x
	txa
	lsr a
	cmp.w textdirtylo
	bcs .1xxx
	sta.w textdirtylo
.1xxx:
	clc
	adc.w #$0020
	cmp.w textdirtyhi
	bcc .1
	sta.w textdirtyhi
	bra .1
.8:
	eor.w #$FFFF
	inc a
	pha
	and.w #$0030
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.w printa
	lda.b r0+1,s
	and.w #$0040
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	tsb.w printa
	pla
	and.w #$0003
	pha
	asl a
	tax
	lda.l printfontset,x
	sta.l printfontset
	pla
	dec a
	xba
	and.w #$FF00
	asl a
	asl a
	asl a
	sta.w printm
	iny
	lda.b [a1],y
	and.w #$001F
	sta.w printx
	iny
	lda.b [a1],y
	and.w #$001F
	sta.w printy
	iny
	jmp.w .7
.9:
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	plx
	rtl
