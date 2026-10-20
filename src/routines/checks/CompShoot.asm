; Computer player X shoots
; Takes: X = player object. Called by jump from chk4shot, chk4lc and assdumpin; it pops the caller's return
; address. The shot swing time temp2b is (y distance to the goal line)/8 up to 20 frames, then the
; assignment is replaced by assignment $13 (assshoot).
CompShoot:							; computer player X shoots
	pla								; pop the return address of the caller
	sep #$20
	pla								; (the caller is abandoned)
	rep #$30
	lda.w pucky						; puck y
	sta.b d0
	lda.w pfgoal,x					; which goal he shoots at
	bne .1
	lda.w #$0000					; mirror y for the other end
	sec
	sbc.b d0
	sta.b d0
.1:
	lda.w #$0108					; $108 minus the puck y
	sec
	sbc.b d0
	lsr a							; divided by 8
	lsr a
	lsr a
	cmp.w #$0014					; at most 20
	bcc .2
	lda.w #$0014
.2:									; swing time ready
	sta.b d1
	stz.w temp2,x					; temp2 = 0
	lda.b d1
	sta.w temp2b,x					; temp2b = swing time
	lda.w #$0013					; assignment $13: assshoot
	sta.b d0
	jmp.w assreplace				; replace the assignment with d0
