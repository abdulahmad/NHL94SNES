; Other scores: game curitem, its two teams with their scores and the period label (PerLabels)
PrintOtherScore:					; called from FillOtherScores
	lda.w curitem
	asl a
	tax
	lda.l gss1,x
	sta.b d0
	lda.l gst1,x
	jsr.w PrintOtherScoreTeam
	inc.w printy
	lda.l gss2,x
	sta.b d0
	lda.l gst2,x
	jsr.w PrintOtherScoreTeam
	lda.w #$0017
	sta.w printx
	lda.l gsper,x
	sta.b d0
	lda.l gss1,x
	cmp.l gss2,x
	beq .2
	lda.b d0
	cmp.w #$0004
	bne .2
.1:									; increment d0
	inc.b d0
.2:									; a0 = PerLabels
	lda.w #PerLabels>>16
	sta.b a0+2
	lda.w #PerLabels
	sta.b a0
.loop:								; loop: a1+2 = a0+2, a1 = a0, a0 = [a0] + a0, ...
	lda.b a0+2
	sta.b a1+2
	lda.b a0
	sta.b a1
	lda.b [a0]
	clc
	adc.b a0
	sta.b a0
	dec.b d0
	bmi .3
	bne .loop
.3:									; call PrintToStatsPage, increment printy, return
	jsl.l PrintToStatsPage
	inc.w printy
	rts
