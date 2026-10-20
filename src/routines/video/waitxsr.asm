; Wait d0 frames or until a button in d1 is pressed
waitxsr:							; called from StartHL2
	phx
	lda.b d0
	pha
.loop:								; loop: falls through
	ldx.w #$0000
.loop2:								; loop: if cont1team,y = 0 go to .1, ...
	txa
	asl a
	tay
	lda.w cont1team,y
	beq .1
	txa
	jsl.l ReadjoyA
	lda.b d3
	bne .2
.1:									; X + 1, if carry clear go to .loop2, ...
	inx
	cpx.w #$0005
	bcc .loop2
	jsl.l SpriteFrameStart
	jsl.l setvideo
	jsl.l SpriteFrameEnd
	lda.b vcount
.loop3:								; loop: if zero go to .loop3, ...
	cmp.b vcount
	beq .loop3
	jsl.l ReadPads
	pla
	dec a
	pha
	bpl .loop
.2:									; return
	pla
	plx
	rtl
