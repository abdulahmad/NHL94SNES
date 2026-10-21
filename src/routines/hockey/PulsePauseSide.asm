; Pulse the palette colour of the pausing pad's side (colourbuf+$1DE or +$1FE, PulseColour), the other side
; white; both white with no side
PulsePauseSide:						; returns nothing (rts); takes no input
	lda.l notdemo					; not a demo game?
	beq .2							; demo: both sides white
	ldx.w pausepad					; pad that paused
	bmi .2							; no pad: both white
	lda.w cont1team,x				; team side of that pad
	beq .2							; no side: both white
	dec a							; side 1?
	beq .t1							; yes, pulse the other palette entry
	ldx.w #$76DE					; side 2: pulse this colour
	ldy.w #$007F
	lda.w #$FFFF					; the other side's colour white
	sta.l colourbuf+$1FE			; (colour buffer entry)
	bra .1							; pulse

.t1:								; side 1: pulse the other colour
	ldx.w #$76FE					; colour to pulse
	ldy.w #$007F
	lda.w #$FFFF
	sta.l colourbuf+$1DE			; the other side's colour white
.1:									; pulse the colour at x / y
	jsl.l PulseColour				; step the pulse
	bra .3							; done
.2:									; no side: both colours white
	lda.w #$FFFF
	sta.l colourbuf+$1DE			; side 1 colour white
	sta.l colourbuf+$1FE			; side 2 colour white
.3:									; done
	rts
