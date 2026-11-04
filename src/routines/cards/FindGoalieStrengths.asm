; The player card strengths of goalie curplayer: the best three goalie rating columns into strengths-$1E83
; (AddStrength)
FindGoalieStrengths:				; called from DrawPlayerCard
	lda.w #$FFFF
	sta.w strengths
	sta.w strengths+2
	sta.w strengths+4
	sta.w strengths+6
	sta.w strengths+8
	sta.w strengths+$A
	lda.w #$0005
	sta.b d1
	jsl.l AddStrength
	lda.w #$0002
	sta.b d1
	jsl.l AddStrength
	lda.w #$0006
	sta.b d1
	jsl.l AddStrength
	lda.w #$0004
	sta.b d1
	jsl.l GetPlayerRating			; rating of curplayer with hot / cold
	lda.b d0
	cmp.w #$0032
	bcc .t1
	lda.w #$0008
	sta.b d1
	jsl.l AddStrength
	lda.w #$0009
	sta.b d1
	jsl.l AddStrength
	bra .1

.t1:								; d0 < $0032: d1 = $0007, call AddStrength, d1 = $000A, ...
	lda.w #$0007
	sta.b d1
	jsl.l AddStrength
	lda.w #$000A
	sta.b d1
	jsl.l AddStrength
.1:									; return
	rtl
