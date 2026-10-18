; Print string [a1] into the text map at printx / printy
print:
	phx
	ldy.w #$0002
.1:
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.w printm
	tax
	lda.l smallfontchars
	adc.l printfontset
	ora.w printa
	sta.b r3
.2:
	tya
	cmp.b [a1]
	bne .t2
	jmp.w .5

.t2:
	lda.b [a1],y
	bit.w #$0080
	bne .4
	and.w #$00FF
	cmp.w #$0040
	bne .t1
	jmp.w .6

.t1:
	phx
	asl a
	tax
	lda.l SmallFontMap+6,x
	adc.b r3
	plx
.3:
	cmp.l textmap,x
	beq .2x
	sta.l textmap,x
	txa
	lsr a
	cmp.w textdirtylo
	bcs .1x
	sta.w textdirtylo
.1x:
	cmp.w textdirtyhi
	bcc .2x
	sta.w textdirtyhi
.2x:
	inc.w printx
	inx
	inx
	iny
	bra .2
.4:
	eor.w #$FFFF
	inc a
	pha
	and.w #$0030
	cmp.w #$0010
	bne .1xx
	clc
	adc.w #$0050
.1xx:
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
	and.w #$007F
	sta.w printx
	iny
	lda.b [a1],y
	and.w #$007F
	sta.w printy
	iny
	jmp.w .1
.5:
	clc
	adc.b a1
	sta.b a1
	plx
	rtl
.6:
	lda.l blankchar
	clc
	adc.l printfontset
	jmp.w .3
