; wallcollb: not over the glass, bounce off the wall
wallcollb_bounce:					; branch target: bounce off the wall
	jmp.w wallcoll					; bounce object X off a wall
; wallcollb: over the glass, out of play
wallcollb_over:						; branch target: over the glass
	jmp.w wallcollb_out				; puck out of play
; Object X hits a wall: the puck may go over the glass and out of play, else it bounces
;
; Takes X = object. Called from checkwallcoll. Only the puck can go over the glass; anything else, and a
; puck that is low or outside the goal mouth, bounces through wallcoll.
wallcollb:							; object X hits a wall
	cpx.w #$001C					; the puck?
	bne wallcollb_bounce			; no: bounce
	lda.w puckz						; puck height
	cmp.w #$0021					; $21 or more: over the glass
	bpl wallcollb_over
	lda.w puckz						; puck height
	cmp.w #$0016					; below $16: bounce
	bcc wallcollb_bounce
	lda.w pucky						; puck y
	cmp.w #$0112					; y below $112: over the glass
	bmi wallcollb_over
	lda.w puckx						; puck x
	cmp.w #$000D					; x below 13: bounce
	bmi wallcollb_bounce
	lda.w puckx						; puck x
	cmp.w #$0010					; 16 or more: bounce
	bpl wallcollb_bounce
	lda.w puckvy					; puck y speed
	cmp.w #$0FA0					; below $FA0: bounce
	bmi wallcollb_bounce
	phx								; keep X
	lda.w puckvy					; halve puckvy
	pha
	asl a
	pla
	ror a
	sta.w puckvy
	inx								; a3 = the shadow object (X + 2)
	inx
	stx.b a3
	lda.w #SPAbglass				; shadow animation SPAbglass
	sta.b d1
	jsl.l SetSPA					; start animation d1
	plx								; restore X and a3
	stx.b a3
	lda.w #$0006					; streamed sound 6 (over the glass)
	jsl.l StreamSfx					; request streamed sound A
	lda.l Crowdlevel				; crowd level +$258
	clc
	adc.w #$0258
	sta.l Crowdlevel
	lda.w #$005A					; hold it 90 frames
	sta.b crowdhold
	lda.w CwdExciteLvl				; crowd excitement +15
	clc
	adc.w #$000F
	bmi wallcollb_out				; negative: skip the store
	sta.w CwdExciteLvl
wallcollb_out:						; puck out of play
	lda.w #$0040					; sfslock: lock the screen
	tsb.w sflags
	sta.w pfnc+puckscnum			; puck pfnc (no collision mode)
	lda.w pucky						; puck y negative (bottom)?
	bpl .1
	lda.w #$8000
	tsb.w attribute+puckscnum		; yes: y flip the puck sprite
.1:									; clear the puck shadow frame
	stz.w frame+puckscnum+2			; shadow frame 0
	lda.w gmclock					; game clock stopped?
	bne .2							; yes: no shootout check
	lda.l ltplayer					; last touching player
	asl a							; times 2 = object index
	sta.b a3
	tax
	lda.w #$0006
	sta.b d0						; d0 = 6
	jsl.l ShootoutWonBy				; shootout result for that player
	ldx.w #$001C					; X = the puck again
	stx.b a3
.2:									; end the penalty shot
	jsl.l EndPenaltyShot			; clear breakaway and the one-timer below
	stz.w breakaway
	stz.w onetimer
	rtl								; return
