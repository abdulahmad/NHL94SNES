; Set the default menu choices at power on
DefaultMenus:
	lda.w #$FFFF
	sta.l notdemo
	lda.w #OptPlayMode>>16
	sta.b a0+2
	lda.w #OptPlayMode
	sta.b a0
	lda.w #$009D
	sta.b a1+2
	lda.w #.1
	sta.b a1
	ldy.w #$0000
	ldx.w #$0007
.loop:
	lda.b [a1],y
	sta.b [a0],y
	iny
	iny
	dex
	bpl .loop
	rtl
.1:
	dw $0000,$000B,$000A,$0001,$0000,$0000,$0000,$0001
