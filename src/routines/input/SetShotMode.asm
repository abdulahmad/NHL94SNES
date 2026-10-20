; Start a shot by player X: shot mode, aim at the goal, shot animation
;
; Takes X = shooter. Sets passdir = 8 (none), sflags bit 3, aims d0/d1 at the goal (x 0, y +$128 or -$128
; by pfgoal), turns that into a direction with vtoa, passspeed = $F and starts a forehand or backhand shot.
; Called from doinput and assshoot.
SetShotMode:						; start a shot by player X
	lda.w #$0008					; no direction yet
	sta.w passdir
	lda.w #$0008					; shot mode flag
	tsb.w sflags
	stz.b d0						; goal x = 0
	lda.w #$0128					; goal y = +$128
	sta.b d1
	lda.w pfgoal,x					; shoots at the top goal?
	bne .1							; yes
	lda.w #$FED8					; no: y = -$128
	sta.b d1
.1:									; vector to the goal
	lda.b d0
	sec
	sbc.w Xpos,x					; minus player x
	sta.b d0
	lda.b d1						; d1 = goal y
	sec
	sbc.w Ypos,x					; minus player y
	sta.b d1
	jsl.l vtoa						; d0 = direction toward the goal
	lda.w #$000F					; starting shot speed 15
	sta.w passspeed
	ldy.w #SPAshotf					; forehand shot animation
	jsl.l Findhittype				; forehand or backhand for this direction
	beq .2							; forehand: keep it
	ldy.w #SPAshotb					; backhand shot animation
.2:									; Y holds the animation
	sty.b d1						; d1 = animation
	jml.l SetSPA					; start it
