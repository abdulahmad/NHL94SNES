; d0 / d1 = the hot spot x / y of object A's current frame
GetHot:								; takes A = object, returns d0 / d1 (many callers)
	phx
	tay
	lda.w frame,y
	dec a
	asl a
	asl a
	tax
	lda.l SpriteFrames,x
	clc
	adc.w #SpriteFrames
	sta.b p0
	lda.l SpriteFrames+2,x
	adc.w #SpriteFrames>>16
	sta.b p0+2
	tyx
	ldy.w #$0012
	lda.b [p0],y
	and.w #$00FF
	cmp.w #$0080
	bcc .1
	ora.w #$FF00
.1:									; d0 = A, Y + 1, if carry clear go to .2, ...
	sta.b d0
	iny
	lda.b [p0],y
	and.w #$00FF
	cmp.w #$0080
	bcc .2
	ora.w #$FF00
.2:									; d1 = A, if attribute,x bits $0800 clear go to .3, ...
	sta.b d1
	lda.w attribute,x
	bit.w #$0800
	beq .3
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.3:									; if attribute,x bit $1000 set go to .4, ...
	lda.w attribute,x
	bit.w #$1000
	bne .4
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.4:									; if sfhormode = 0 go to .5, ...
	lda.w sfhormode
	beq .5
	lda.b d0						; rotate by 90 degrees
	ldy.b d1
	eor.w #$FFFF					; negate: two's complement
	inc a
	sta.b d1
	sty.b d0						; swap x and y
.5:									; return
	plx								; restore X
	rtl
