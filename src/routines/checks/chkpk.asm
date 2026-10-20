; Z set if player X is killing a penalty
;
; Takes player X. Returns Z set if X is on the team killing a power play,
; Z clear when there is no power play (falls into chkpk2 otherwise).
;
; Called from chk4shot and assdefd.
chkpk:								; Z if X is killing a penalty
	lda.w sflags					; power play flags
	and.w #sf2pwrplay				; sf2pwrplay
	bne chkpk2						; power play: test X's team there
	inc a							; no power play: A = 1, Z clear
	rtl
