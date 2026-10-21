; Play sound $0F with the velocity of the faster of players X and Y
; Takes X and Y = the two players in the collision. The speed of each is the length of its Xvel/Yvel
; (ApproxLength); the velocity of the faster one, doubled, is used for sound $0F via sfx.
;
; Called from checkplcoll and FallDown.
CollisionSfx:						; play the collision sound
	phy								; 1,s = Y, the other object
	ldy.w Xvel,x
	lda.w Yvel,x
	jsl.l ApproxLength				; A = the approximate length of the vector
	sta.b r3
	lda.b 1,s
	tay
	lda.w Xvel,y
	pha
	lda.w Yvel,y
	tay
	pla
	jsl.l ApproxLength				; A = the approximate length of the vector
	ply
	cmp.b r3
	bcs .t1
	lda.w Xvel,x
	sta.b p0
	lda.w Yvel,x
	sta.b p0+2
	bra .1

.t1:								; player Y is faster
	lda.w Xvel,y
	sta.b p0
	lda.w Yvel,y
	sta.b p0+2
.1:									; velocity doubled, then sound $0F
	asl.b p0
	asl.b p0+2
	lda.w #$000F
	jsl.l sfx						; play sound A with the velocity in p0 / p0+2
	rtl
