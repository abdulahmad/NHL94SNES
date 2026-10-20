; a2 = the team of the controller that paused (0 home, 2 visitors), from its side ($1C84)
;
; Returns a2 = 0 or 2 (the team index of the pad that paused, set from pausepad) and a2+2 = the side
; searched for. Called from PauseGoalieMode, PauseDefControl, PauseTimeout, PauseGoalie and Pmenu.
GetPadTeam:							; a2 = team (0/2) of the controller that paused
	stz.b a2						; a2 = 0 (home), a2+2 = 1
	lda.w #$0001
	sta.b a2+2
	ldx.w pausepad
	bpl .t1							; pausepad >= 0: use it as the controller index
	txa
	eor.w #$FFFF					; negative: look for the first controller whose team equals -pausepad
	inc a
	sta.b a2+2
	ldx.w #$0000
.loop:								; scan the five controller teams
	lda.w cont1team,x
	cmp.b a2+2
	beq .t1
	inx
	inx
	cpx.w #$000A
	bcc .loop
	bra .1							; none found

.t1:								; team of the controller
	lda.w cont1team,x				; team of that controller: anything but 1 is the visitors
	cmp.w #$0001
	beq .1
	inc.b a2
	inc.b a2
.1:									; return
	rtl
