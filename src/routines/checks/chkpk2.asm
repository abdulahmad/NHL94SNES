; Z set if player X is on the shorthanded team
chkpk2:
	lda.w pfteam,x
	bne .t2
	lda.w sflags
	and.w #sf2pwrtm
	eor.w #sf2pwrtm
	rtl

.t2:
	lda.w sflags
	and.w #sf2pwrtm
	rtl
