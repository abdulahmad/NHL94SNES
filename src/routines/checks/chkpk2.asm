; Z set if player X is on the shorthanded team
;
; Takes player X. Returns Z set if X is on the team that is a man short in the
; power play (sf2pwrtm is 0 for team 1, so home needs the eor).
;
; Called from assnearest, and falls in from chkpk.
chkpk2:								; Z if X is on the shorthanded team
	lda.w pfteam,x					; team of X
	bne .t2							; visitors: .t2
	lda.w sflags					; team 0: flags
	and.w #sf2pwrtm					; sf2pwrtm
	eor.w #sf2pwrtm					; Z if the sf2pwrtm bit is set
	rtl

.t2:								; team 1
	lda.w sflags					; team 1 flags
	and.w #sf2pwrtm					; Z if the sf2pwrtm bit is clear
	rtl
