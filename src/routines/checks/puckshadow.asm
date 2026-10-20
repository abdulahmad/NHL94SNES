; Assignment: the puck shadow follows the puck
puckshadow:
	lda.w frame,x					; frame
	cmp.w #SPFpuck					; puck frame: shadow under the puck
	bne .t2
	lda.w puckx						; puck x
	sta.w Xpos,x
	lda.w pucky						; puck y
	sta.w Ypos,x
	stz.w shadowz
	lda.w sfhormode
	beq .t1
	inc.w Xpos,x					; x + 1
	rtl

.t1:								; shadow is drawn 1 unit off the puck
	inc.w Ypos,x					; y + 1
	rtl

.t2:								; nothing to show
	tay								; frame 0
	beq .rtl						; nothing to show
	stz.w Xpos,x					; x = 0
	lda.w #$012C
	sta.w Ypos,x
	lda.w #$000E
	sta.w shadowz
	lda.w pucky
	bpl .rtl
.1:
	lda.w #$8000
	sta.w attribute,x
	lda.w #$FED4
	sta.w Ypos,x
	dec.w shadowz
.rtl:
	rtl
