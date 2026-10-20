; Start bench A cheering, unless one already is: benchcheer = A, benchframe = A * 8, its step timer
StartBenchCheer:					; called from FallDown, Goal, assscore
	ldy.w benchcheer
	bne .rtl
	sta.w benchcheer
	asl a
	asl a
	asl a
	sta.w benchframe
	lda.w #$000B
	sta.w benchtimer
	stz.w benchrounds
.rtl:								; return
	rtl
