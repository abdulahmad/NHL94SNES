; Set the pass direction from player X's facing (passdir, sflags sfspdir), unless he is the goalie holding the
; puck behind the net
;
; Takes X = player. For a goalie (position 0) with the puck x within -16..15 and y 264..271 (just behind the
; net) nothing is set; otherwise passdir = his facing (0-7) and sfspdir is set. Called from doinput.
setpassmode:						; pass direction from the facing of player X
	lda.w position,x				; position
	bne .2							; not the goalie: use his facing
	lda.w puckx						; puck x
	cmp.w #$FFF0
	bmi .2							; left of -16: use his facing
	cmp.w #$0010
	bpl .2							; right of 15: use his facing
	lda.w pucky						; puck y
	cmp.w #$0108
	bpl .1							; 264 or more: check the upper limit
	cmp.w #$FEF8
	bpl .2							; above -264: use his facing
.1:									; goalie with the puck at the back of the net
	cmp.w #$0110
	bcc .rtl						; puck y 264-271: no direction
.2:									; use the facing
	lda.w facedir,x					; facing
	and.w #$0007					; 0-7
	sta.w passdir					; pass direction
	lda.w #sfspdir					; a pass direction is set
	tsb.w sflags
.rtl:								; return
	rtl
