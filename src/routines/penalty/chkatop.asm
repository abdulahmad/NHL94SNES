; Add to the attack zone time of the team with the puck past the blue line
chkatop:							; called from updatepentime
	stz.b d1
	lda.w pucky
	sec
	sbc.w #$0058
	bpl .1
	inc.b d1
	inc.b d1
	lda.w pucky
	sec
	sbc.w #$FFA8
	bpl .rtl
.1:									; if gmode bits gmdir clear go to .2, ...
	lda.w gmode
	bit.w #gmdir
	beq .2
	lda.b d1
	eor.w #$0002
	sta.b d1
.2:									; tmATOP,y = tmATOP,y + 1
	ldy.b d1
	lda.w tmATOP,y
	inc a
	sta.w tmATOP,y
.rtl:								; return
	rtl
