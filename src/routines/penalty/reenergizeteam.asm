; Give every player of team a2 full energy
reenergizeteam:						; called from PauseTimeout, SetupTeamForIntermission, StartHL2, StartPer
	lda.w #$0032
	sta.b d0
.top:								; loop: if a2 = 0 go to .tm, ...
	lda.b a2
	beq .tm
	lda.w #$0034
.tm:								; adc d0, tmpde,y = $1000, if tmpdst,y != TMPDOUT go to .nb, ...
	clc
	adc.b d0
	tay
	lda.w #$1000
	sta.w tmpde,y
	lda.w tmpdst,y
	cmp.w #TMPDOUT
	bne .nb
	cmp.w #rosterNone
	bne .nb
	lda.w #TMPDBENCH
	sta.w tmpdst,y
.nb:								; decrement d0, decrement d0, if d0 still >= 0 go to .top, ...
	dec.b d0
	dec.b d0
	bpl .top
	rtl
