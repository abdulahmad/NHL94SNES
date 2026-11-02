; Draw string [a1] with the letter sprites at X / Y
PrintLetterSprites:					; called from DrawEditLinesTitle, DrawPeriodStats, PasswordScreen, Play...
	stx.w letterx
	sty.w lettery
	ldy.w #$0002
.1:									; if not zero go to .t4, ...
	tya
	cmp.b [a1]
	bne .t4
	jmp.w .4

.t4:								; if not zero go to .t1, ...
	lda.b [a1],y
	and.w #$00FF
	cmp.w #$0020
	bne .t1
	lda.w #$0006
	bra .2

.t1:								; if carry clear go to .t2, ...
	cmp.w #$0030
	bcc .t2
	cmp.w #$003A
	bcs .t2
	sec
	sbc.w #$0030
	clc
	adc.w #$001A
	bra .t3

.t2:								; if carry clear go to .t1x, ...
	cmp.w #$0061
	bcc .t1x
	cmp.w #$007B
	bcs .t1x
	sec
	sbc.w #$0061
	bra .t3

.t1x:								; if carry clear go to .3, ...
	cmp.w #$0041
	bcc .3
	cmp.w #$005B
	bcs .3
	sec
	sbc.w #$0041
	bra .t3

.t3:								; p1 = LetterSprites, r0 = X, call DrawSprite, ...
	tax
	phx
	phy
	lda.w #LetterSprites>>16
	sta.b p1+2
	lda.w #LetterSprites
	sta.b p1
	stx.b r0
	lda.w #$2000
	ldx.w letterx
	ldy.w lettery
	jsl.l DrawSprite
	ply
	plx
	lda.l LetterSpriteWidths,x
	and.w #$00FF
.2:									; adc letterx, letterx = A
	clc
	adc.w letterx
	sta.w letterx
.3:									; Y + 1, go to .1
	iny
	jmp.w .1
.4:									; return
	rtl
