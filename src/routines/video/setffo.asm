; Draw the objects tied to rink scrolling (the pad labels)
setffo:								; called from setvideo
	lda.w #SpriteFrames>>16
	sta.b p1+2
	lda.w #SpriteFrames
	sta.b p1
	lda.w #$000C
	sta.b a2
.1:									; if PadControlObj,y != $000F go to .3
	ldy.b a2
	lda.w PadControlObj,y
	cmp.w #$000F
	bne .3
.2:									; go to .6
	jmp.w .6
.3:									; PadControlObj,y != $000F: tyx, r0 = .7,x, d0 = Xpos,x, ...
	tyx
	lda.l .7,x
	sta.b r0
	lda.w PadControlObj,y
	asl a
	tax
	lda.w Xpos,x
	sta.b d0
	lda.w Ypos,x
	sta.b d1
	stz.b d2
	jsl.l find3d					; project a rink position to screen coordinates
	cmp.w #$4E20
	beq .2
	ldy.w position,x
	bmi .2
	phx
	tay
	clc
	adc.w #$000A
	sta.b d1
	ldx.b d0
	lda.w #$2000
	jsl.l DrawSprite
	plx
	cpx.w #$0020
	beq .2
	ldy.w #$0000
	lda.w rostnum,x
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F					; high digit
	beq .1x
	sta.w mesarea+2,y
	iny
	lda.b d0
	sec
	sbc.w #$0004
	sta.b d0
.1x:								; mesarea+2,y = rostnum,x & $000F, Y + 1, d0 = d0 - $0004, ...
	lda.w rostnum,x
	and.w #$000F
	sta.w mesarea+2,y
	iny
	lda.b d0
	sec
	sbc.w #$0004
	sta.b d0
	lda.w shootoutmode
	bne .2x
	lda.w position,x
	and.w #$0007
	beq .2x
	tax
	lda.w #$FFFF
	sta.w mesarea+2,y
	iny
	lda.l ButtonLabelCharTable-1,x
	sta.w mesarea+2,y
	iny
	lda.b d0						; left 6 more
	sec
	sbc.w #$0006
	sta.b d0
.2x:								; mesarea = Y
	sty.w mesarea
	ldy.w #$0000
.4:									; d2 = Y, if zero go to .t1, ...
	sty.b d2
	lda.w mesarea+2,y				; character
	and.w #$00FF
	cmp.w #$00FF					; blank?
	beq .t1
	adc.w #SPFsmallfont-1			; DrawSprite index (frame - 1) of the glyph
	sta.b r0
	ldx.b d0
	ldy.b d1
	lda.w #$2000
	jsl.l DrawSprite
	lda.b d0
	clc
	adc.w #$0008
	sta.b d0
	bra .5

.t1:								; d0 = d0 + $0004
	lda.b d0
	clc
	adc.w #$0004
	sta.b d0
.5:									; Y + 1, if not zero go to .4
	ldy.b d2
	iny
	cpy.w mesarea
	bne .4
.6:									; decrement a2, decrement a2, if a2 counted below 0 go to .t1x, ...
	dec.b a2
	dec.b a2
	bmi .t1x
	jmp.w .1

.t1x:								; a2 counted below 0: return
	rtl
.7:									; DrawSprite index (frame - 1) of each label
	dw SPFpad-1,SPFpad+1-1,SPFpad+2-1,SPFpad+3-1,SPFpad+4-1,SPFpad+5-1,SPFreplay-1
