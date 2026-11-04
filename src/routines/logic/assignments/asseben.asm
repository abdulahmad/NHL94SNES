; Assignment: the player comes onto the ice from the bench
; Takes: X = player object. Called through asstab (assignment $0A).
; First frame: puts the player at the door of his bench (x -136, y from his slot number) and starts him
; gliding out of the wall. Later frames: face right, clear the flags, push him out with Xvel $1000, assexit.
asseben:							; assignment: skate on from the bench
	lda.w pfalock,x					; locked: animation still running
	bne .t1							; yes: leave
	lda.w pflags,x					; player flags
	bit.w #pfna						; first frame of the assignment (pfna)?
	beq .t2							; not new
	and.w #(~pfna&$FFFF)			; clear pfna
	sta.w pflags,x
	stz.w Xvel,x					; stand still
	stz.w Yvel,x					; no speed
	stz.w goalieflags,x				; clear goalie flags
	txa								; y by slot: (object/2 - 6), +1 when not negative
	lsr a
	sec								; minus 6
	sbc.w #$0006
	bmi .1							; first team: slot is negative
	inc a							; away: +1
.1:									; slot number
	phx								; keep X
	tax
	lda.w #$000E					; multiply by 14
	jsl.l Mul16x8XS
	plx								; restore X
	lda.b r2						; Ypos = result of Mul16x8XS
	sta.w Ypos,x					; y
	lda.w #-Sideline				; door x at the left boards
	sta.w Xpos,x
	lda.w #$0002					; face left
	sta.w facedir,x
	sta.w pfalock,x					; lock the assignment
	lda.w #SPAwallright				; wall animation for a skater
	ldy.w position,x
	bne .3
.2:									; goalie wall animation
	lda.w #SPAgwallright
.3:									; start the animation
	jml.l SetSPAUpdate				; start sprite animation A on object X and update it at once

.t1:								; locked: return
	rtl

.t2:								; animation over: step out
	lda.w #$0004					; face right
	sta.w facedir,x
	lda.w pflags,x					; clear the flags in $9000
	and.w #(~(pf2unav|pf2npc)&$FFFF)
	sta.w pflags,x
	stz.w pfnc,x					; collisions on again
	stz.w SPA,x						; clear the animation
	lda.w #$1000					; skate out at Xvel $1000
	sta.w Xvel,x
	jml.l assexit					; assignment over
