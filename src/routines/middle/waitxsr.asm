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
	jsl.l ReadjoyA					; read pad A: d0 = direction, d1 = new presses, d2 = changed buttons
	lda.b d3
	bne .2
.1:									; X + 1, if carry clear go to .loop2, ...
	inx
	cpx.w #$0005
	bcc .loop2
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l SpriteFrameEnd			; update the screen
	lda.b Vcount					; frame counter
.loop3:								; loop: if zero go to .loop3, ...
	cmp.b Vcount
	beq .loop3						; wait for the next frame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	pla
	dec a							; one frame less
	pha
	bpl .loop						; until past zero
.2:									; return
	pla
	plx
	rtl
