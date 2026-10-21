; Draw the two 6 x 6 pictures, visitors at x 1 and home at x $18: a team logo (setupvis / setuphome) or, when
; that is negative, the matchup player picture (matchupvis / matchuphome)
DrawMatchupPictures:				; called from DrawEditLinesTitle, DrawPeriodStats, PasswordScreen, Play...
	lda.b a2						;keep the team offset
	pha
	lda.l setupvis					;visitors' side
	sta.b r0
	bpl .t1							;logo team: draw the logo
	lda.l setuphome					;home side a logo too?
	bpl .1							;yes: a2 stays
	lda.w #$0002					;visitors' team offset
	sta.b a2
.1:									;visitors' player picture
	lda.l matchupvis				;visitors' matchup player
	ldx.w #$0001					;column 1
	ldy.w #$0001					;row 1
	jsl.l DrawPlayerPicture			; draw the picture of a player
	lda.w #picboxmap>>16			;paste the picture box
	sta.b p0+2
	lda.w #picboxmap
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020					;32-column map
	sta.b r7
	ldx.w #$0001
	ldy.w #$0001
	lda.w #$0000
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	bra .2							;home side next

.t1:								;visitors' logo
	lda.l setupvis
	asl a							;4 bytes per pointer
	asl a
	tax
	lda.l LogoPaletteTable+2,x		;logo palette
	sta.b p0+2
	lda.l LogoPaletteTable,x
	sta.b p0
	ldy.w #$00A0					;sprite palette 2
	ldx.w #$0010					;16 colours
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #logosprbuf>>16
	sta.b p1+2
	lda.w #logosprbuf
	sta.b p1
	lda.w #$2400					;sprite palette 2 attributes
	ldx.w #$000C					;x 12
	ldy.w #$000C					;y 12
	jsl.l DrawSprite				;draw the logo sprite
	ldx.w #$0001
	ldy.w #$0001
	jsl.l ClearPictureBox			; blank the 6 x 6 picture area at x, y of the text map
	lda.w #logoboxmap>>16			;paste the logo box frame
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
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
.2:									;home side
	lda.l setuphome
	sta.b r0
	bpl .t1x						;logo team: draw the logo
	lda.l setupvis					;visitors a logo?
	bpl .1x							;yes: a2 stays
	stz.b a2						;home team offset
.1x:								; call DrawPlayerPicture, p0+2 = $007F, p0 = $7780, ...
	lda.l matchuphome				;home matchup player
	ldx.w #$0018					;column 24
	ldy.w #$0001
	jsl.l DrawPlayerPicture			;draw it
	lda.w #picboxmap>>16			;paste the picture box
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
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	bra .3							;done with the boxes

.t1x:								;home logo
	lda.l setuphome
	asl a							;4 bytes per pointer
	asl a
	tax
	lda.l LogoPaletteTable+2,x		;logo palette
	sta.b p0+2
	lda.l LogoPaletteTable,x
	sta.b p0
	ldy.w #$00B0					;sprite palette 3
	ldx.w #$0010
	jsl.l SetColours				; copy X colours from [p0] into the colour buffer colourbuf
	lda.w #logosprbuf>>16
	sta.b p1+2
	lda.w #logosprbuf
	sta.b p1
	lda.w #$2600					;sprite palette 3 attributes
	ldx.w #$00C4					;x 196
	ldy.w #$000C					;y 12
	jsl.l DrawSprite				;draw the logo sprite
	ldx.w #$0018
	ldy.w #$0001
	jsl.l ClearPictureBox			; blank the 6 x 6 picture area at x, y of the text map
	lda.w #logoboxmap>>16			;paste the logo box frame
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
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
.3:									;pictures to send
	lda.l playerstatson
	bne .5							;stats on: no picture send
	lda.l setupvis					;visitors a picture?
	bmi .1xx						;yes: send them
	lda.l setuphome					;home a picture?
	bpl .t1xx						;no: logos only
.1xx:								;send both picture tile sets
	lda.w #Ram7F>>16
	sta.b p0+2
	lda.l homepicaddr				;home picture tiles
	sta.b p0
	lda.l picchars
	asl a							;words per character x 16
	asl a
	asl a
	asl a
	clc
	adc.w #$2000					;plus BG2 char base
	tay								;VRAM address
	ldx.w #$0600					;$600 bytes
	jsl.l WaitFrame					;wait for vblank
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	lda.w #Ram7F>>16
	sta.b p0+2
	lda.l vispicaddr				;visitors' picture tiles
	sta.b p0
	lda.l picchars
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$2300					;next $300 words
	tay
	ldx.w #$0600					;$600 bytes
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	bra .4							;send the maps

.t1xx:								; setuphome >= 0: call WaitFrame
	jsl.l WaitFrame
.4:									;send the text maps
	jsl.l SendTextMapRows
	jsl.l SendTextMap2Rows
.5:									; a2 = pulled value, return
	pla								;restore the team offset
	sta.b a2
	rtl
