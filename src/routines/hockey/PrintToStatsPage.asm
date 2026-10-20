; Print string [a1] at printx / printy into the stats page buffer ($7F2780, 32 wide) through the SmallFontMap
; character map
PrintToStatsPage:					; a1 = string, printx / printy = cell; returns nothing
	phx								; keep x
	lda.w #$0020					; r7 = buffer width, 32 cells
	sta.b r7
	lda.b [a1]						; length word, minus the word itself
	dec a
	dec a
	sta.b r6+2						; r6+2 = number of characters
	inc.b a1						; step over the length word
	inc.b a1
	lda.b a1+2						; p0 = the characters
	sta.b p0+2
	lda.b a1
	sta.b p0
	lda.w #$007F					; p1 = stats page buffer
	sta.b p1+2
	lda.w #$2780
	sta.b p1
	ldy.w printy					; y = row, x = column
	ldx.w printx
	lda.l smallfontchars			; tile base of the small font
	clc								; plus the font set and the attribute (palette) bits
	adc.l printfontset
	ora.w printa
	jsl.l .t1						; write the tiles
	plx								; restore x
	rtl

.t1:								; Write the characters at p0 as tiles: A = tile base, y = row, x = column
	sta.b r7+2						; r7+2 = tile base
	stx.b r5						; r5 = column
	tya								; row * 2 ...
	asl a
	ldx.b r7
	jsl.l Mul16U					; ... times 32: r2 = byte offset of the row
	lda.b r5						; plus 2 * column
	asl a
	clc
	adc.b r2
	adc.b p1						; p1 = address of the first cell
	sta.b p1
	ldy.w #$0000					; y = byte offset in the row
.loop:								; next character
	lda.b [p0]						; character
	and.w #$00FF
	beq .2							; a zero character: blank the rest
	asl a
	tax								; table index
	lda.l SmallFontMap+6,x			; tile number of the character
	clc
	adc.b r7+2						; plus the tile base
	sta.b [p1],y					; store the cell
	iny
	iny
	inc.b p0						; next character
	dec.b r6+2						; count down
	bne .loop						; more characters
.1:									; done
	rtl
.2:									; zero character: fill blank cells
	dex								; count
	bmi .1							; finished
	lda.w #$0020					; the space tile
	clc
	adc.b r7+2						; plus the tile base
	sta.b [p1],y
	iny
	iny
	inc.b p0						; skip
	bra .2							; repeat
