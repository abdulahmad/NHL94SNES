; Draw the EASN logo on the rink unless a power play is on
;
; Pastes the EASN logo map into the rink text map and widens the dirty range, unless a power play is on.
; Called from printscores1 and updatepwrplay_clr.
EASNLogo:							; draw the logo
	lda.w sflags					; screen flags
	bit.w #sf2pwrplay				; power play flag
	bne .rtl						; power play on: no logo
	lda.b a1+2						; save a1 (long pointer)
	pha
	lda.b a1
	pha
	lda.w #EASNLogoPos>>16			; a1 = EASNLogoPos (the string position)
	sta.b a1+2
	lda.w #EASNLogoPos
	sta.b a1
	jsl.l print						; print the position string
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w #EASNLogoMap>>16			; p0 = the logo map
	sta.b p0+2
	lda.w #EASNLogoMap
	sta.b p0
	lda.w #textmap>>16				; p1 = the text map
	sta.b p1+2
	lda.w #textmap
	sta.b p1
	lda.w #$0020					; r7 = $20, probably the text map row width in words
	sta.b r7
	ldx.w #$0001					; x = 1 and y = $19 give the map size for PasteMap
	ldy.w #$0019
	lda.w #$2000					; tile base $2000 (palette bits)
	clc
	adc.l EASNcset					; plus the logo character set
	adc.l charofs					; plus the character offset
	jsl.l PasteMap					; paste the map into the text map
	lda.w #$0321					; low dirty text map offset of the logo
	cmp.w textdirtylo
	bcs .1							; text map already dirty from lower: keep
	sta.w textdirtylo				; else lower textdirtylo
.1:									; end of the lower bound test
	lda.l EASNLogoMap+2				; map word at +2
	clc
	adc.w #$0019
	dec a							; plus $19, minus 1
	asl a							; times 32 (a text map row)
	asl a
	asl a
	asl a
	asl a
	clc
	adc.l EASNLogoMap				; plus the map word at +0: last text map offset
	cmp.w textdirtyhi				; compare with textdirtyhi
	bcc .rtl						; already higher: keep
	sta.w textdirtyhi				; else raise textdirtyhi
.rtl:								; done
	rtl								; return
