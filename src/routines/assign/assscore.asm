; Assignment: celebrating a goal
; Takes: X = player object. Called through asstab (assignment 8). After a goal the players slow down
; (velocity * $C0/256), the scorer drops the puck, and each man skates to a spot at the side of the
; screen and celebrates. Humans (a pad with buttons held) are left alone.
assscore:							; assignment: celebrate a goal
	lda.w gmode						; game mode bit $0040: bench cheer on?
	bit.w #$0040
	beq .1x							; no: skip
	lda.b a2						; team index + 2
	inc a
	inc a
	jsl.l StartBenchCheer			; start the bench cheer
.1x:								; human pad?
	ldy.w playerpad,x
	bmi .t2							; no pad: computer
	lda.w JoyPad,y					; buttons held? (any bit above the low nibble)
	and.w #$FFF0
	beq .t2							; none held: go on
	rtl								; a button is held: leave him

.t2:								; Xvel, Yvel *= $C0/256
	lda.w Xvel,x					; X velocity
	tax
	lda.w #$00C0
	jsl.l Mul16x8XS					; multiply by $C0
	ldx.b a3						; restore X
	lda.b r2+1						; high bytes: divided by 256
	sta.w Xvel,x
	lda.w Yvel,x					; Y velocity
	tax
	lda.w #$00C0
	jsl.l Mul16x8XS
	ldx.b a3
	lda.b r2+1
	sta.w Yvel,x
	txa								; the puck carrier loses the puck
	lsr a							; player number
	cmp.w puckc						; is this the puck carrier?
	bne .1x2
	lda.w #$FFFF					; drop the puck
	sta.w puckc
	lda.w #$0708					; no puck pickup for 1800 frames
	sta.w nopuck,x
.1x2:								; new assignment?
	lda.w pflags,x
	bit.w #pfna						; pfna
	beq .3
	and.w #$FFFD					; clear pfna
	sta.w pflags,x
	jsl.l .6						; temp1 = random countdown
	stz.w temp2,x
	lda.w #$0008					; temp2b = 8
	sta.w temp2b,x
	lda.w #$005A					; x target 90
	sta.w temp3,x
	lda.w Hpos						; scroll side
	bpl .2x
	lda.w #$FFA6					; left side: -90
	sta.w temp3,x
.2x:								; y target is the scroll y
	lda.w Vpos
	sta.w temp4,x
.3:									; target in d0/d1
	lda.w #rtss>>16					; a0 = rtss
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w temp1,x					; temp1 counts down
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .t1x						; still counting: skate
	lda.w #SPAcelebrate				; celebrate animation
	sta.b d1
	sta.w pfalock,x					; lock the assignment
	cpx.w shotplayer				; the player who shot the goal?
	bne .5							; someone else: celebrate
.4:									; unreferenced label
	lda.w #SPApump2					; shot player pumps his arm
	sta.b d1
	lda.w #$FFFF					; clear the shot player
	sta.w shotplayer
.5:									; start the animation
	jsl.l SetSPA
.6:									; temp1 = random countdown (up to 120)
	lda.w #$0078
	jsl.l randoma8
	sta.w temp1,x
	rtl								; return

.t1x:								; skate to the target
	jmp.w skateto					; skate to (temp3,temp4)
