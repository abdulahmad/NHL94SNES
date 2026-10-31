; Hold button: pick the nearest opponent in front of player X (distance plus facing), then Acheck hooks or
; holds him
;
; Takes X = player. A goalie, or a player locked in an animation other than the burst, does nothing.
; Otherwise the six players of the other team are scored as distance + 16 * (facing difference, 0-4); the
; lowest score is a0 (-1 = nobody).
;
; Acheck then starts the hook, or the hold when the target faces roughly towards X.
; Called from doinput; Acheck is entered by jml from check4check.
Holdplayer:							; hold button for player X
	lda.w position,x				; position
	beq .rtl						; goalie: nothing
	lda.w pfalock,x					; animation lock
	beq .t1							; not locked
	lda.w SPA,x						; current animation
	cmp.w #SPAburst
	bne .t1							; not the burst: go on
.rtl:								; locked in the burst: leave
	rtl

.t1:								; find the best player to hold
	lda.w #$FFFF					; no best score yet
	sta.b d3
	sta.b a0						; no best player yet
	ldy.w #$0000					; Y = team 0 players
	cpx.w #$000C					; X is on team 0?
	bcs .1							; X on team 1: the other team is at offset 0
	ldy.w #$000C					; X on team 0: the other team starts at offset $0C
.1:									; both set
	lda.w #$0006					; six players to try
	sta.b d2
.loop:								; loop over the other team
	sty.b a2						; remember the player
	lda.w position,y				; position
	beq .2							; position 0 (goalie): skip the angle
	bmi .2							; not on ice: skip the angle
	lda.w Xpos,y					; dx to player X
	sec
	sbc.w Xpos,x
	sta.b d0						; d0 = dx
	lda.w Ypos,y					; dy
	sec
	sbc.w Ypos,x
	sta.b d1						; d1 = dy
	ldy.b d1						; Y = dy
	lda.b d0						; A = dx
	jsl.l ApproxLength				; distance
	sta.b d4						; d4 = distance
	jsl.l vtoa						; direction from X to the player
	lda.b d0						; direction
	sec
	sbc.w facedir,x					; minus his facing
	and.w #$0007					; 0-7
	cmp.w #$0005					; 5 or more is behind: fold it
	bcc .2							; in front: use it
	eor.w #$FFFF					; fold 5-7 to 3-1
	adc.w #$0008
.2:									; score = angle difference * 16 + distance
	asl a							; difference 0-4 times 16
	asl a
	asl a
	asl a
	adc.b d4						; plus the distance
	cmp.b d3						; better than the best so far?
	bcs .3							; no
	sta.b d3						; new best score
	lda.b a2						; and its player
	sta.b a0
.3:									; next player
	ldy.b a2
	iny
	iny								; two bytes per player
	dec.b d2						; all six done
	bne .loop
Acheck:								; hook or hold the chosen player
	lda.w #SPAhook					; hook animation
	sta.b d1						; d1 = animation
	sta.w pfalock,x					; lock X in it
	ldy.b a0						; best player
	bmi .1							; none found: hook
	lda.w facedir,x					; X facing
	sec
	sbc.w facedir,y					; minus his facing
	inc a							; plus two
	inc a
	and.w #$0007					; 0-7
	cmp.w #$0005					; 5 or more: hook
	bcc .1
	lda.w #SPAHold					; hold animation
	sta.b d1
.1:									; start the animation
	jml.l SetSPA
