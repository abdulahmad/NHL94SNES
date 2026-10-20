; Z set if player X is on the shorthanded team
chkpk2:
	lda.w pfteam,x
	bne .t2
	lda.w sflags					; team 0: flags
	and.w #sf2pwrtm					; sf2pwrtm
	eor.w #sf2pwrtm					; Z if the sf2pwrtm bit is set
	rtl

.t2:								; team 1
	lda.w sflags					; team 1 flags
	and.w #sf2pwrtm					; Z if the sf2pwrtm bit is clear
	rtl
