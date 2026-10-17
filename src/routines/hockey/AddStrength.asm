; Insert rating column d1 of player $1D9B (GetPlayerRating) into the best-three list at $1E79-$1E83 (column,
; rating pairs)
AddStrength:
	jsl.l GetPlayerRating
	lda.b d0
	dec a
	cmp.w strengths+2
	bpl .t1
	cmp.w strengths+6
	bpl .1
	cmp.w strengths+$A
	bpl .2
	bra .3

.t1:
	lda.w strengths+2
	sta.b r0
	lda.w strengths
	sta.b r1
	lda.b d0
	sta.w strengths+2
	lda.b d1
	sta.w strengths
	lda.b r0
	sta.b d0
	lda.b r1
	sta.b d1
.1:
	lda.w strengths+6
	sta.b r0
	lda.w strengths+4
	sta.b r1
	lda.b d0
	sta.w strengths+6
	lda.b d1
	sta.w strengths+4
	lda.b r0
	sta.b d0
	lda.b r1
	sta.b d1
.2:
	lda.b d0
	sta.w strengths+$A
	lda.b d1
	sta.w strengths+8
.3:
	rtl
