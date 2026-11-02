; Assignment: players wait until the face off is over
; Takes: X = player object. Called through asstab (assignment $16). Players not involved in the face off
; wait here; when the face off flag in sflags goes ($0100) the assignment ends.
assfaceoff:							; assignment: wait for the face off to be over
	lda.w pfalock,x
	bne .t4							; animation locked: just return
	lda.w sflags
	bit.w #sf2faceoff				; bit $0100 of sflags: face off in progress
	bne .t4
	jml.l assexit					; face off over: assignment over
.t4:								; return
	rtl
