; Shootout shooters screen: clear the top, the frame, and the background map (MenuBackMap) in map 2
DrawShootersBack:					; called from ShootersBackground
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawShootersBackPos>>16
	sta.b a1+2
	lda.w #DrawShootersBackPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$000D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawShootersBackPos2>>16
	sta.b a1+2
	lda.w #DrawShootersBackPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa
	lda.w #$000E
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l FramerOutline
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #LineupTxt2>>16
	sta.b a1+2
	lda.w #LineupTxt2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #MenuBackMap>>16
	sta.b p0+2
	lda.w #MenuBackMap
	sta.b p0
	lda.w #$007F
	sta.b p1+2
	lda.w #$0000
	sta.b p1
	jsl.l Decompress
	lda.w #$007F
	sta.b p0+2
	lda.w #$0000
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	lda.w #$0020
	sta.b r7
	lda.w #$001C
	sta.b r7+2
	ldx.w #$0000
	ldy.w #$0000
	lda.l charofs2
	clc
	adc.w #$0C00
	jsl.l PasteMap
	rtl
