; d0 / d1 = the stick hot spot of object A's current frame, read from its SpriteFrames entry (bytes $12-$15),
; x / y flipped by the attribute and rotated in horizontal mode
GetFrameHot:
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
	iny
	lda.b [p0],y
	and.w #$00FF
	cmp.w #$0080
	bcc .3
	ora.w #$FF00
.3:
	sec
	sbc.b d0
	sta.b d0
	iny
	lda.b [p0],y
	and.w #$00FF
	cmp.w #$0080
	bcc .4
	ora.w #$FF00
.4:
	sec
	eor.w #$FFFF
	adc.b d1
	sta.b d1
	lda.w attribute,x
	bit.w #$0800
	beq .6
.5:
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.6:
	lda.w attribute,x
	bit.w #$1000
	bne .7
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.7:
	lda.w sfhormode
	beq .8
	lda.b d0
	ldy.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
	sty.b d0
.8:
	plx
	rtl
