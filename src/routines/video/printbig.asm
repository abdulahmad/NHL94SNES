; Print with the big font (2 by 2 tiles per character)
; Takes a1 = string like print. Each character is 2 by 2 tiles (BigFontIndex / BigFontMap), the top left at
; printx / printy in textmap; lower case is turned into upper case, a space (and $40) draws a blank block.
; BigFontIndex tells if the character is narrow (one tile wide, else it takes two and printx advances by 2).
; d0, d1, d2 and X are preserved.
;
; Called from puckfaceoff2, printscores1, ShowGoalBox and ShootoutWonBy.
printbig:							; print a string with the big font
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
.7:									; next byte of the string
	tya
	cmp.b [a1]
	bne .t3
	jmp.w .9

.t3:								; not the end
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

.t1:								; a control record when bit 7 is set
	and.w #$00FF
	bne .t2
	jmp.w .5

.t2:								; zero byte: skip it
	cmp.w #$0061
	bcc .1x
	cmp.w #$007B
	bcs .1x
	adc.w #$FFE0
.1x:								; 1 to 59 = character index minus $20
	sec
	sbc.w #$0020
	bne .t1x
	jmp.w .6

.t1x:								; d2 = 1: wide character
	stz.b d2
	inc.b d2
	tax
	lda.l BigFontIndex,x
	and.w #$00FF
	bit.w #$0080
	beq .1xx
	ora.w #$FF00
.1xx:								; negative index = narrow character
	cmp.w #$0000
	bpl .2
	eor.w #$FFFF
	inc a
	stz.b d2
.2:									; d0 = table offset of the character
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
.3:									; first top row tile written
	clc
	adc.w #$0021
	cmp.w textdirtyhi
	bcc .4
	sta.w textdirtyhi
.4:									; second row tile
	ldx.b d0
	lda.l BigFontMap+$9E,x
	clc
	adc.l BigFontChars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+(1*$40)+(0*2),x
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
	sta.l textmap+(1*$40)+(1*2),x
	inc.w printx
.1:									; advance the print position
	inc.w printx
.5:									; next character
	iny
	jmp.w .7
.6:									; space: blank block
	lda.l BigFontMap+$32
	clc
	adc.l BigFontChars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap,x
	sta.l textmap+(1*$40)+(0*2),x
	txa
	lsr a
	cmp.w textdirtylo
	bcs .1xxx
	sta.w textdirtylo
.1xxx:								; end of the dirty update
	clc
	adc.w #$0020
	cmp.w textdirtyhi
	bcc .1
	sta.w textdirtyhi
	bra .1
.8:									; control record: palette, font set, then position
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
	and.w #$001F
	sta.w printx
	iny
	lda.b [a1],y
	and.w #$001F
	sta.w printy
	iny
	jmp.w .7
.9:									; end of string: restore registers
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
