; Fill a d0 by d1 rectangle of the text map at printx / printy with tile d2.
eraser:								; called from BadPasswordPrompt, ClearEditLinesMenu, DrawEditLinesBack...
	phx								; keep X
	lda.b d2						; tile
	clc
	adc.l printfontset
	sta.b d2
	stz.b d1+2						; row counter 0
.row:								; loop: falls through
	lda.w printy					; print y
	clc
	adc.b d1+2						; plus the row
	asl a							; times 32
	asl a
	asl a
	asl a
	asl a
	adc.w printx					; plus print x
	asl a							; word offset
	adc.w printm
	tax								; X = map offset
	ldy.b d0						; columns
	lda.b d2						; tile
.col:								; loop: textmap,x = A, X + 1, X + 1, ...
	sta.l textmap,x					; fill a word
	inx
	inx
	dey								; next column
	bne .col
	inc.b d1+2						; next row
	lda.b d1+2
	cmp.b d1						; all rows done?
	bne .row
	plx								; restore X
	lda.w printy					; print y
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx					; plus print x
	cmp.w textdirtylo
	bcs .hi
	sta.w textdirtylo
.hi:								; printy = printy + d1 & $001F, if carry clear go to .rtl, ...
	lda.w printy					; print y
	clc
	adc.b d1						; plus the height
	and.w #$001F					; wrap at 32
	sta.w printy					; new print y
	dec a							; last row
	and.w #$001F
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx					; plus print x
	adc.b d0						; plus the width
	dec a							; last word
	cmp.w textdirtyhi
	bcc .rtl
	sta.w textdirtyhi
.rtl:								; return
	rtl
