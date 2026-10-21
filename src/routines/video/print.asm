; Print string [a1] into the text map at printx / printy
; Takes a1 = pointer to a string: a length word (offset after the last byte, counted from the start of the
; word), then bytes. A byte with bit 7 set is a control record (colour/priority/font in its bits, followed by
; the new printx and printy); $40 prints a blank; the others are tiles of SmallFontMap. The tiles are written
; to textmap at printx / printy (the position of the map entry is (printy * 32 + printx) * 2 + printm) and
; textdirtylo / textdirtyhi keep the changed range. Returns a1 advanced to the end of the string.
;
; Called from AttribWeight, AttribStatus, ShowRosterLine, SelectLinePlayer and many others.
print:								; print a string
	phx
	ldy.w #$0002
.1:									; X = text map offset of the print position
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
.2:									; next byte of the string
	tya
	cmp.b [a1]
	bne .t2
	jmp.w .5

.t2:								; not the end: a control record?
	lda.b [a1],y
	bit.w #$0080
	bne .4
	and.w #$00FF
	cmp.w #$0040
	bne .t1
	jmp.w .6

.t1:								; ordinary character
	phx
	asl a
	tax
	lda.l SmallFontMap+6,x
	adc.b r3
	plx
.3:									; write the tile when it differs from the map
	cmp.l textmap,x
	beq .2x
	sta.l textmap,x
	txa
	lsr a
	cmp.w textdirtylo
	bcs .1x
	sta.w textdirtylo
.1x:								; update the end of the dirty range
	cmp.w textdirtyhi
	bcc .2x
	sta.w textdirtyhi
.2x:								; next print position
	inc.w printx
	inx
	inx
	iny
	bra .2
.4:									; control record: palette and priority into printa, font set, position
	eor.w #$FFFF
	inc a
	pha
	and.w #$0030
	cmp.w #$0010
	bne .1xx
	clc
	adc.w #$0050
.1xx:								; shift the palette bits into place
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.w printa
	lda.b 1,s
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
.5:									; end of string: step a1 past it
	clc
	adc.b a1
	sta.b a1
	plx
	rtl
.6:									; blank character
	lda.l blankchar
	clc
	adc.l printfontset
	jmp.w .3
