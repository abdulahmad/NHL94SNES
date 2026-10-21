; Draw the logo of team A as sprites at x, y with its LogoPaletteTable palette
DrawLogoSprite:						; called from DrawPlayerCard
	sta.b r0
	stx.b r1
	sty.b r2
	lda.b r0
	asl a
	asl a
	tax
	lda.l LogoPaletteTable+2,x
	sta.b p0+2
	lda.l LogoPaletteTable,x
	sta.b p0
	ldy.w #$00A0
	ldx.w #$0010
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #logosprbuf>>16
	sta.b p1+2
	lda.w #logosprbuf
	sta.b p1
	lda.w #$2400
	ldx.b r1
	ldy.b r2
	jsl.l DrawSprite
	rtl
