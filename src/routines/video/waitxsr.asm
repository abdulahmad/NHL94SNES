; Wait d0 frames or until a button in d1 is pressed
waitxsr:
	phx
	lda.b d0
	pha
.loop:
	ldx.w #$0000
.loop2:
	txa
	asl a
	tay
	lda.w cont1team,y
	beq .1
	txa
	jsl.l ReadjoyA
	lda.b d3
	bne .2
.1:
	inx
	cpx.w #$0005
	bcc .loop2
	jsl.l SpriteFrameStart
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	lda.b vcount
.loop3:
	cmp.b vcount
	beq .loop3
	jsl.l ReadPads
	pla
	dec a
	pha
	bpl .loop
.2:
	pla
	plx
	rtl
