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
	ldy.w #strtext					; y = 2: after the length word
.7:									; next byte of the string
	tya								; end of the string?
	cmp.b [a1]
	bne .t3
	jmp.w .9

.t3:								; not the end
	lda.w printy					; d1 = textmap offset (printy * 32 + printx) * 2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	sta.b d1
	lda.b [a1],y					; next character
	bit.w #$0080					; bit 7: control code
	beq .t1
	jmp.w .8

.t1:								; a control record when bit 7 is set
	and.w #$00FF					; character code
	bne .t2
	jmp.w .5						; zero: skip it

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
	stz.b d2						; d2 = 1: two columns wide
	inc.b d2
	tax								; index
	lda.l BigFontIndex,x			; character width/tile table (BigFontIndex): negative = 1 column
	and.w #$00FF
	bit.w #$0080
	beq .1xx
	ora.w #$FF00
.1xx:								; negative index = narrow character
	cmp.w #$0000					; negative: one column wide
	bpl .2
	eor.w #$FFFF					; negate
	inc a
	stz.b d2						; d2 = 0
.2:									; d0 = table offset of the character
	asl a							; word offset
	sta.b d0						; keep it
	tax
	lda.l BigFontMap+6,x
	clc
	adc.l BigFontchars
	adc.l printfontset
	ora.w printa					; plus the palette and priority
	ldx.b d1
	sta.l textmap,x					; top left tile
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
	adc.l BigFontchars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+(1*$40)+(0*2),x	; bottom left tile
	lda.b d2						; two columns wide?
	beq .1
	ldx.b d0
	lda.l BigFontMap+8,x
	clc
	adc.l BigFontchars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+2,x				; top right tile
	ldx.b d0
	lda.l BigFontMap+$A0,x
	clc
	adc.l BigFontchars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap+(1*$40)+(1*2),x	; bottom right tile
	inc.w printx					; extra column
.1:									; advance the print position
	inc.w printx					; next column
.5:									; next character
	iny								; next character
	jmp.w .7
.6:									; space: blank block
	lda.l BigFontMap+$32
	clc
	adc.l BigFontchars
	adc.l printfontset
	ora.w printa
	ldx.b d1
	sta.l textmap,x					; top blank tile
	sta.l textmap+(1*$40)+(0*2),x	; bottom blank tile
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
	eor.w #$FFFF					; negate
	inc a
	pha								; 1,s = the control record value, negated
	and.w #$0030					; palette bits
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.w printa					; printa palette
	lda.b 1,s
	and.w #$0040					; priority bit
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	tsb.w printa					; printa priority
	pla
	and.w #$0003					; font number: printfontset from the table at printfontset+2*n
	pha
	asl a
	tax
	lda.l printfontset,x
	sta.l printfontset
	pla								; printm = (map - 1) * $800
	dec a
	xba
	and.w #$FF00
	asl a
	asl a
	asl a
	sta.w printm
	iny
	lda.b [a1],y					; x
	and.w #$001F
	sta.w printx					; printx
	iny
	lda.b [a1],y					; y
	and.w #$001F
	sta.w printy					; printy
	iny
	jmp.w .7						; continue
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
