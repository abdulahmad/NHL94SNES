; d0 / d1 = the hot spot x / y of object A's current frame
GetHot:
	phx
	tay
	lda.w frame,y
	dec a
	asl a
	asl a
	tax
	lda.l SpriteFrames,x
	clc
	adc.w #$8000
	sta.b p0
	lda.l SpriteFrames+2,x
	adc.w #$0082
	sta.b p0+2
	tyx
	ldy.w #$0012
	lda.b [p0],y
	and.w #$00FF
	cmp.w #$0080
	bcc .1
	ora.w #$FF00
.1:
	sta.b d0
	iny
	lda.b [p0],y
	and.w #$00FF
	cmp.w #$0080
	bcc .2
	ora.w #$FF00
.2:
	sta.b d1
	lda.w attribute,x
	bit.w #$0800
	beq .3
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.3:
	lda.w attribute,x
	bit.w #$1000
	bne .4
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.4:
	lda.w sfhormode
	beq .5
	lda.b d0
	ldy.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	sty.b d0
.5:
	plx
	rtl
