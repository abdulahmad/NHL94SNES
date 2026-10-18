; d0 = the roster slot of team a2's player for matchup A (center, wings, defense, goalie)
GetMatchupPlayer:
	tay
	lda.w #$009D
	sta.b a1+2
	lda.w #.1
	sta.b a1
	lda.b [a1],y
	and.w #$00FF
	pha
	ldy.b a2
	lda.w #$009C
	sta.b a1+2
	lda.w tmdata,y
	sta.b a1
	ldy.w #$000C
	clc
	adc.b [a1],y
	sta.b a1
	ply
	lda.b [a1],y
	and.w #$00FF
	dec a
	sta.b d0
	rtl
.1:
	db $04,$03,$05,$01,$02,$00
