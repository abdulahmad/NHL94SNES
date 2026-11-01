; In the demo, Start pauses and any other button ends it (back through Opening2); in mode 4 with controller
; sides, Start on any of them pauses from that pad
;
; Takes nothing. Start (bit $1000) starts the pause; any other button leaves via Opening2.
; Called from Gameloop.
demoread:							; read the controllers during the demo
	lda.l OptPlayMode				; play mode
	cmp.w #$0004					; mode 4 with controller teams set: pause from any assigned pad
	bne .2							; not mode 4: single pad check
	lda.w cont1team					; any pad assigned to a team?
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	beq .2							; none: single pad check
	ldx.w #$0000					; X = pad word offset
.1:									; pad loop
	phx								; save offset
	lda.w cont1team,x				; this pad has a team?
	beq .t1							; no: next pad
	txa								; pad number = offset / 2
	lsr a
	jsl.l ReadjoyA					; read that pad
	lda.b d3						; d3 = buttons held
	bit.w #$1000					; Start?
	beq .t1							; no: next pad
	pla								; A = saved pad offset (the pause pad)
	jmp.w PauseFromPad				; pause from this pad

.t1:								; next pad
	plx								; restore X
	inx
	inx								; next word
	cpx.w #$000A					; five pads done?
	bcc .1
	rtl								; nothing pressed
.2:									; single pad check
	lda.w cont1team					; any pad assigned to a team?
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	bne .3							; yes: no demo handling
	jsl.l ReadJoy1					; read pad 1
	lda.b d1						; d1 = new presses
	bit.w #$1000					; Start?
	beq .t1x						; no: look at the other buttons
	jmp.w startpause1				; pause from pad 1

.t1x:								; new presses
	lda.b d1
	bne .4							; any other button: leave the demo
.3:									; return
	rtl								; return
.4:									; leave the demo
	stz.w fadestep					; no fade pending
	stz.w FrameByNumber				; clear the cached frame
	jml.l Opening2					; back to the start (Opening2 does not return)
