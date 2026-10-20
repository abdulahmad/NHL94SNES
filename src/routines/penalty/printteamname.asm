; Print team d3's name, then move down two rows
printteamname:						; called from PrintTeamNameAndScore, ShowStars
	lda.w printx
	pha
	lda.w tmdata
	sta.b a1
	lda.w #$009C
	sta.b a1+2
	lda.b d3
	beq .1
	lda.w tmdata+2
	sta.b a1
.1:									; a1 = [a1],y + a1, a1 = [a1] + a1, call print, ...
	ldy.w #$0004
	lda.b [a1],y
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]
	adc.b a1
	sta.b a1
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	inc.w printy
	rtl
