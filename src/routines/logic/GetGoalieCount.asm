; d0 = the number of goalies on team a2.
GetGoalieCount:						; called from DrawPlayerCard, DrawPlayerPicture, GetPlayerBaseRating, G...
	lda.b a2
	tay
	lda.w #TeamList>>16				; team list bank
	sta.b tmp1
	lda.w tmdata,y					; team data pointer
	sta.b tmp0
	ldy.w #GoalieOdds				; goalie odds offset
	clc
	adc.b [tmp0],y
	sta.b tmp0
	stz.b d0						; count = 0
	lda.b [tmp0]					; goalie odds bits
	xba
.cnt:								; loop: increment d0, asl a, asl a, ...
	inc.b d0						; count the used nibbles
	asl a
	asl a
	asl a
	asl a
	bne .cnt
	rtl
