; Fill a d0 by d1 rectangle of the text map at printx / printy with tile d2.
eraser:
	phx
	lda.b d2
	clc
	adc.l printfontset
	sta.b d2
	stz.b d1+2
.row:
	lda.w printy
	clc
	adc.b d1+2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.w printm
	tax
	ldy.b d0
	lda.b d2
.col:
	sta.l textmap,x
	inx
	inx
	dey
	bne .col
	inc.b d1+2
	lda.b d1+2
	cmp.b d1
	bne .row
	plx
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	cmp.w textdirtylo
	bcs .hi
	sta.w textdirtylo
.hi:
	lda.w printy
	clc
	adc.b d1
	and.w #$001F
	sta.w printy
	dec a
	and.w #$001F
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.b d0
	dec a
	cmp.w textdirtyhi
	bcc .rtl
	sta.w textdirtyhi
.rtl:
	rtl
