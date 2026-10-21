; Pad input for a player taking a face off
;
; Takes X = player, d0 = pad direction, d1 = new presses. For the assignment $17 (faceoff) the pad direction
; is stored in fodir1 or fodir2 (by pfgoal); B ($8000) starts SPAfaceoff once, otherwise SPAfaceoffr.
; Called from doinput.
faceoffinput:						; pad input for a player taking a face off
	lda.w asscur,x					; assignment running
	cmp.w #$0017					; $17 = face off
	bne .t2							; other assignment: leave
	lda.w #fodir1>>16				; direction store of the home side
	sta.b a0+2
	lda.w #fodir1
	sta.b a0
	lda.w pfgoal,x					; shoots at the top goal?
	beq .1							; no
	lda.w #fodir2>>16				; direction store of the other side
	sta.b a0+2
	lda.w #fodir2
	sta.b a0
.1:									; store the pad direction
	lda.b d0						; d0 = pad direction
	sta.b [a0]
	lda.w pf2aip,x					; already swinging?
	bne .t2							; yes: leave
	lda.b d1						; new presses
	bit.w #$8000					; B pressed?
	beq .t1							; no
	lda.w #$0001					; swing started
	sta.w pf2aip,x
	lda.w #SPAfaceoff				; face off swing animation
	jml.l SetSPAFromA				; start sprite animation A on object X

.t1:								; not pressed
	lda.w #SPAfaceoffr				; ready animation
	jml.l SetSPAFromA				; start sprite animation A on object X

.t2:								; return
	rtl
