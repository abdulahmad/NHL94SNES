; Draw the two 6 x 6 pictures, visitors at x 1 and home at x $18: a team logo ($7E3454 / $7E3452) or, when
; that is negative, the matchup player picture ($7E345C / $7E345A)
DrawMatchupPictures:				; called from DrawEditLinesTitle, DrawPeriodStats, PasswordScreen, Play...
	lda.b a2
	pha
	lda.l setupvis
	sta.b r0
	bpl .t1
	lda.l setuphome
	bpl .1
	lda.w #$0002
	sta.b a2
.1:									; call DrawPlayerPicture, p0+2 = $007F, p0 = $7780, ...
	lda.l matchupvis
	ldx.w #$0001
	ldy.w #$0001
	jsl.l DrawPlayerPicture
	lda.w #picboxmap>>16
	sta.b p0+2
	lda.w #picboxmap
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020
	sta.b r7
	ldx.w #$0001
	ldy.w #$0001
	lda.w #$0000
	jsl.l PasteMap
	bra .2

.t1:								; p0+2 = LogoPaletteTable+2,x, p0 = LogoPaletteTable,x, call SetColours...
	lda.l setupvis
	asl a
	asl a
	tax
	lda.l LogoPaletteTable+2,x
	sta.b p0+2
	lda.l LogoPaletteTable,x
	sta.b p0
	ldy.w #$00A0
	ldx.w #$0010
	jsl.l SetColours
	lda.w #$007F
	sta.b p1+2
	lda.w #$7800
	sta.b p1
	lda.w #$2400
	ldx.w #$000C
	ldy.w #$000C
	jsl.l DrawSprite
	ldx.w #$0001
	ldy.w #$0001
	jsl.l ClearPictureBox
	lda.w #logoboxmap>>16
	sta.b p0+2
	lda.w #logoboxmap
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020
	sta.b r7
	ldx.w #$0001
	ldy.w #$0001
	lda.w #$0000
	jsl.l PasteMap
.2:									; r0 = setuphome, if plus go to .t1x, ...
	lda.l setuphome
	sta.b r0
	bpl .t1x
	lda.l setupvis
	bpl .1x
	stz.b a2
.1x:								; call DrawPlayerPicture, p0+2 = $007F, p0 = $7780, ...
	lda.l matchuphome
	ldx.w #$0018
	ldy.w #$0001
	jsl.l DrawPlayerPicture
	lda.w #picboxmap>>16
	sta.b p0+2
	lda.w #picboxmap
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020
	sta.b r7
	ldx.w #$0018
	ldy.w #$0001
	lda.w #$0000
	jsl.l PasteMap
	bra .3

.t1x:								; p0+2 = LogoPaletteTable+2,x, p0 = LogoPaletteTable,x, call SetColours...
	lda.l setuphome
	asl a
	asl a
	tax
	lda.l LogoPaletteTable+2,x
	sta.b p0+2
	lda.l LogoPaletteTable,x
	sta.b p0
	ldy.w #$00B0
	ldx.w #$0010
	jsl.l SetColours
	lda.w #$007F
	sta.b p1+2
	lda.w #$7800
	sta.b p1
	lda.w #$2600
	ldx.w #$00C4
	ldy.w #$000C
	jsl.l DrawSprite
	ldx.w #$0018
	ldy.w #$0001
	jsl.l ClearPictureBox
	lda.w #logoboxmap>>16
	sta.b p0+2
	lda.w #logoboxmap
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020
	sta.b r7
	ldx.w #$0018
	ldy.w #$0001
	lda.w #$0000
	jsl.l PasteMap
.3:									; if playerstatson != 0 go to .5, ...
	lda.l playerstatson
	bne .5
	lda.l setupvis
	bmi .1xx
	lda.l setuphome
	bpl .t1xx
.1xx:								; p0+2 = $007F, p0 = homepicaddr, call WaitFrame, ...
	lda.w #$007F
	sta.b p0+2
	lda.l homepicaddr
	sta.b p0
	lda.l picchars
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$2000
	tay
	ldx.w #$0600
	jsl.l WaitFrame
	jsl.l DMAToVRAM
	lda.w #$007F
	sta.b p0+2
	lda.l vispicaddr
	sta.b p0
	lda.l picchars
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$2300
	tay
	ldx.w #$0600
	jsl.l DMAToVRAM
	bra .4

.t1xx:								; setuphome >= 0: call WaitFrame
	jsl.l WaitFrame
.4:									; call SendTextMapRows, call SendTextMap2Rows
	jsl.l SendTextMapRows
	jsl.l SendTextMap2Rows
.5:									; a2 = pulled value, return
	pla
	sta.b a2
	rtl
