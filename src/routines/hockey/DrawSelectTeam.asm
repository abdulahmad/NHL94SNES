; Draw team d1 on the player select screen at printx: its palette, logo tiles and city name (TeamPlaceNames)
DrawSelectTeam:						; called from PlayerSelect
	lda.b a2
	pha
	phx
	lda.w #$0001
	sta.l bigtextchar
	lda.w #$1800
	sta.b r3
	ldy.w #$0060
	lda.b d1
	cmp.w HomeTeam
	bne .1
	ldx.w #$1C00
	stx.b r3
	ldy.w #$0070
	lda.w #$0018
	sta.l bigtextchar
.1:									; loop: p0+2 = TeamBlockPalettes+2,x, p0 = TeamBlockPalettes,x, call Se...
	lda.b d1
	asl a
	asl a
	tax
	lda.l TeamBlockPalettes+2,x
	sta.b p0+2
	lda.l TeamBlockPalettes,x
	sta.b p0
	ldx.w #$0010
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w HomeTeam
	cmp.w VisTeam
	bne .t1
	lda.b r3
	cmp.w #$1800
	beq .t1
	lda.w #$1800
	sta.b r3
	ldy.w #$0060
	lda.b d1
	bra .1

.t1:								; if redrawblocks = 0 go to .1x, ...
	lda.l redrawblocks
	beq .1x
	ldy.w #$0000
	lda.w #TeamBlocksMap>>16
	sta.b a2+2
	lda.w #TeamBlocksMap+6
	sta.b a2
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
	lda.w #$0009
	sta.b tmp0
	sta.b tmp1
.loop:								; loop: textmap,x = [a2],y + scorechars + printfontset + r3, Y + 1, ...
	lda.b [a2],y
	clc
	adc.l scorechars
	clc
	adc.l printfontset
	clc
	adc.b r3
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp0
	bne .loop
.loop2:								; loop: textmap+$2E,x = [a2],y + scorechars + printfontset + r3, Y + 1...
	lda.b [a2],y
	clc
	adc.l scorechars
	clc
	adc.l printfontset
	clc
	adc.b r3
	sta.l textmap+(23*2),x
	iny
	iny
	inx
	inx
	dec.b tmp1
	bne .loop2
.1x:								; p0 = long TeamPlaceNames,x, jmlvector = $005C, ...
	lda.b d1
	asl a
	tax
	lda.l TeamPlaceNames,x
	sta.b p0
	lda.w #TeamPlaceNames>>16
	sta.b p0+2
	lda.w printx
	pha
	lda.w #$005C
	sta.w jmlvector
	lda.w #BigLetterSelect
	sta.w jmlvector+1
	lda.w #BigLetterSelect>>16
	sta.w jmlvector+3
	jsl.l RenderBigText				; draw string [p0] in the big proportional font
	pla
	sta.w printx
	plx
	pla
	sta.b a2
	rts
