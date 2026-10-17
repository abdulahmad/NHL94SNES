; On a penalty clock tick: the team with more players on the ice (tmap against tmap+2) gets one more tick of
; power play time ($1756 home, $1758 visitors)
CountPowerPlayTime:
	stz.b d1
	lda.w tmap
	sec
	sbc.w tmap+2
	beq .rtl
	bpl .1
	lda.w #$0002
	sta.b d1
.1:
	ldy.b d1
	lda.w tmPwrPlayTime,y
	inc a
	sta.w tmPwrPlayTime,y
.rtl:
	rtl
