; Give every player of team a2 full energy
reenergizeteam:						; called from PauseTimeout, SetupTeamForIntermission, StartHL2, StartPer
	lda.w #$0032					; last player
	sta.b d0
.top:								; loop: if a2 = 0 go to .tm, ...
	lda.b a2						; team
	beq .tm
	lda.w #$0034					; away team offset $34
.tm:								; adc d0, tmpde,y = $1000, if tmpdst,y != TMPDOUT go to .nb, ...
	clc
	adc.b d0
	tay								; index
	lda.w #$1000					; max energy
	sta.w tmpde,y					; full
	lda.w tmpdst,y					; out: back to the bench
	cmp.w #TMPDOUT					; out of play?
	bne .nb
	cmp.w #rosterNone
	bne .nb
	lda.w #TMPDBENCH				; back to the bench
	sta.w tmpdst,y
.nb:								; decrement d0, decrement d0, if d0 still >= 0 go to .top, ...
	dec.b d0						; previous player
	dec.b d0
	bpl .top
	rtl
