; Call penalty d0 on player X, unless the clock is stopped or penalties (or offsides) are turned off
AddPenalty:
	lda.w gmclock
	bne .rtl
	lda.w PenShotActive
	bne .rtl
	lda.b d0
	cmp.w #PenIcing
	beq AddPenalty2
	cmp.w #PenShot
	beq AddPenalty2
	lda.l OptPen
	beq .rtl
	lda.w gmode
	bit.w #gmoffs
	bne AddPenalty2
	lda.b d0
	cmp.w #PenOffsides
	bne AddPenalty2
.rtl:
	rtl
