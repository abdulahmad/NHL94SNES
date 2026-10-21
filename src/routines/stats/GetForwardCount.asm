; d0 = forwards on team a2 (high nibble of team data byte 3 at +8)
; Takes a2 = team offset, returns d0.
;
; Called from SelectLinePlayer and DrawPlayerCard.
GetForwardCount:					; count the forwards of the team
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #$0008
	clc
	adc.b [a3],y
	clc
	adc.w #$0003
	sta.b a3
	lda.b [a3]
	lsr a
	lsr a
	lsr a
	lsr a
	and.w #$000F
	sta.b d0
	rtl
