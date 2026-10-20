; At a period start (not overtime): CwdExciteLvl = $10 per playoff stage (0 outside the playoffs)
;
; Called from StartPer. Skips period 4 (overtime, gsp 3) so excitement carries over.
InitCrowdExcite:					; set the crowd excitement for a new period
	lda.w gsp
	cmp.w #$0003
	beq .rtl
	stz.b r0						; r0 = stage 0 (regular season, or mode 4)
	lda.l OptPlayMode
	cmp.w #$0000
	beq .1
	cmp.w #$0004
	beq .1
	inc.b r0						; playoffs: stage 1, 2 from round 2, 3 from round 3
	lda.l playoffRoundIdx
	cmp.w #$0002
	bmi .1
	inc.b r0
	lda.l playoffRoundIdx
	cmp.w #$0003
	bmi .1
	inc.b r0
.1:									; excitement = stage * 16
	lda.b r0
	asl a
	asl a
	asl a
	asl a
	sta.w CwdExciteLvl
.rtl:								; return
	rtl
