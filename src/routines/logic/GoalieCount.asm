; d0 = the number of goalies on team a2.
GoalieCount:						; called from DrawPlayerCard, DrawPlayerPicture, GetPlayerBaseRating, G...
	lda.b a2
	tay
	lda.w #TeamList>>16
	sta.b tmp1
	lda.w tmdata,y
	sta.b tmp0
	ldy.w #GoalieOdds
	clc
	adc.b [tmp0],y
	sta.b tmp0
	stz.b d0
	lda.b [tmp0]
	xba
.cnt:								; loop: increment d0, asl a, asl a, ...
	inc.b d0
	asl a
	asl a
	asl a
	asl a
	bne .cnt
	rtl
