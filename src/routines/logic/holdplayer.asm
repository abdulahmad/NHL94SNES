; Hold button: pick the nearest opponent in front of player X (distance plus facing), then Acheck hooks or
; holds him
Holdplayer:
	lda.w position,x
	beq .rtl
	lda.w pfalock,x
	beq .t1
	lda.w SPA,x
	cmp.w #SPAburst
	bne .t1
.rtl:
	rtl

.t1:
	lda.w #$FFFF
	sta.b d3
	sta.b a0
	ldy.w #$0000
	cpx.w #$000C
	bcs .1
	ldy.w #$000C
.1:
	lda.w #$0006
	sta.b d2
.loop:
	sty.b a2
	lda.w position,y
	beq .2
	bmi .2
	lda.w Xpos,y
	sec
	sbc.w Xpos,x
	sta.b d0
	lda.w Ypos,y
	sec
	sbc.w Ypos,x
	sta.b d1
	ldy.b d1
	lda.b d0
	jsl.l ApproxLength
	sta.b d4
	jsl.l vtoa
	lda.b d0
	sec
	sbc.w facedir,x
	and.w #$0007
	cmp.w #$0005
	bcc .2
	eor.w #$FFFF
	adc.w #$0008
.2:
	asl a
	asl a
	asl a
	asl a
	adc.b d4
	cmp.b d3
	bcs .3
	sta.b d3
	lda.b a2
	sta.b a0
.3:
	ldy.b a2
	iny
	iny
	dec.b d2
	bne .loop
Acheck:
	lda.w #SPAhook
	sta.b d1
	sta.w pfalock,x
	ldy.b a0
	bmi .1
	lda.w facedir,x
	sec
	sbc.w facedir,y
	inc a
	inc a
	and.w #$0007
	cmp.w #$0005
	bcc .1
	lda.w #SPAHold
	sta.b d1
.1:
	jml.l SetSPA
