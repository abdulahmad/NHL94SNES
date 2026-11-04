; d4 = the cross product of the goalie vector and the post vector from the puck
;
; Takes d0/d1 = goalie vector, d3/d4 = a point, d2 = scale. Returns d4 = cross product of the vector and
; (point - puck), divided by d2. Called from shotdiradj.
CalcAngleOffset:					; cross product for the shot aim
	lda.b d3						; point x
	sec
	sbc.w puckx						; minus puck x
	sta.b d3
	lda.b d4						; point y
	sec
	sbc.w pucky						; minus puck y
	ldx.b d0						; X = vector x
	jsl.l Mul16S					; A * X
	lda.b r2+2						; high word of the product
	sta.b d4+2
	lda.b r2						; low word of the product
	sta.b d4
	lda.b d1						; vector y
	ldx.b d3						; X = point x difference
	jsl.l Mul16S					; second product
	lda.b d4						; first product minus the second
	sec
	sbc.b r2
	sta.b r2
	lda.b d4+2
	sbc.b r2+2
	sta.b r2+2
	lda.b d2						; divisor
	sta.b r1
	jsl.l Div32S					; signed 32 bit divide
	lda.b r0						; quotient
	sta.b d4
	rts
