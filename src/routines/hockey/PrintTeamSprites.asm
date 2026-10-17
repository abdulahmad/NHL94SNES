; Draw the place name of team d1 (TeamPlaceNames), or string [a1] when d1 is negative, as letter sprites at X
; / Y
PrintTeamSprites:
	phb
	phk
	plb
	stx.w letterx
	sty.w lettery
	stz.b r3
	stz.b r3+2
	lda.b d1
	pha
	bmi .t1
	asl a
	tay
	lda.w TeamPlaceNames,y
	sta.b d1
	ldy.w #$0000
	bra PrintTeamSprites_go

.t1:
	inc.b r3+2
	sep #$30
	lda.b a1+2
	pha
	plb
	rep #$30
	lda.b (a1)
	tay
	dey
	dey
	lda.b a1
	inc a
	inc a
	sta.b d1
	lda.w #$0000
	sta.b (d1),y
	ldy.w #$0000
PrintTeamSprites_go:
	lda.b (d1),y
	and.w #$00FF
	beq .4
	cmp.w #$0020
	bne .t3
	cpy.w #$0000
	beq .3
	lda.w #$0005
	bra .2

.t3:
	cmp.w #$002E
	bne .t1
	lda.w #$0003
	bra .2

.t1:
	cmp.w #$0040
	bne .t2
	lda.l LetterWidths+$1B
	and.w #$00FF
	bra .2

.t2:
	cmp.w #$0030
	bcc .t1x
	cmp.w #$003A
	bcs .t1x
	sec
	sbc.w #$0030
	clc
	adc.w #$001C
	bra .1

.t1x:
	and.w #$00DF
	sec
	sbc.w #$0041
.1:
	tax
	lda.l LetterWidths,x
	and.w #$00FF
.2:
	clc
	adc.b r3
	sta.b r3
.3:
	iny
	bra PrintTeamSprites_go
.4:
	ldy.w #$0000
	lda.b r3+2
	beq .t1xx
	lda.b a2
	bmi .t1xx
	bne .5
	lda.w #$00F8
	sec
	sbc.b r3
	sta.w letterx
	bra .5

.t1xx:
	lda.b r3
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w letterx
	sta.w letterx
.5:
	lda.b (d1),y
	and.w #$00FF
	bne .t4
	jmp.w .10

.t4:
	cmp.w #$0020
	bne .t2x
	cpy.w #$0000
	bne .t1xxx
	jmp.w .9

.t1xxx:
	lda.w #$0005
	bra .8

.t2x:
	cmp.w #$002E
	bne .t3x
	ldx.w #$001A
	bra .6

.t3x:
	cmp.w #$0040
	bne .t1xxxx
	ldx.w #$001B
	bra .6

.t1xxxx:
	cmp.w #$0030
	bcc .t2xx
	cmp.w #$003A
	bcs .t2xx
	sec
	sbc.w #$0030
	clc
	adc.w #$001C
	tax
	bra .6

.t2xx:
	and.w #$00DF
	sec
	sbc.w #$0041
	tax
.6:
	lda.w #SpriteFrames>>16
	sta.b p1+2
	lda.w #SpriteFrames
	sta.b p1
	phy
	phx
	txa
	clc
	adc.w #SPFbigfont-1				; DrawSprite index (frame - 1) of the letter
	sta.b r0
	lda.l horblocks
	bne .t1xxxxx
	lda.w #$3800
	bra .7

.t1xxxxx:
	lda.w #$3C00
	ldx.b a2
	bne .7
	lda.w #$3E00
.7:
	ldx.w letterx
	ldy.w lettery
	jsl.l DrawSprite
	plx
	ply
	lda.l LetterWidths,x
	and.w #$00FF
.8:
	clc
	adc.w letterx
	sta.w letterx
.9:
	iny
	jmp.w .5
.10:
	pla
	sta.b d1
	plb
	rtl
