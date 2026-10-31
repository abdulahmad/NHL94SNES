; Assignment: computer shooting: wind up, then shoot
assshoot:							; X = shooter; asstab entry (SetShotMode / ShotMode are its parts)
	lda.w pflags,x
	bit.w #pfna
	beq .t2
	and.w #$FFFD
	sta.w pflags,x
	bra SetShotMode					; set the shot mode

.t2:								; assignment not new: if sflags bit $0008 is clear, assexit
	lda.w sflags
	bit.w #$0008
	bne .t1
	jmp.w assexit					; no: assignment over

.t1:								; sflags bit $0008 set: count down the swing timer temp2b
	lda.w temp1,x
	sta.b d0						; d0 = shot direction
	stz.b d2						; no buttons
	lda.w temp2b,x
	sec
	sbc.b d7						; minus d7
	sta.w temp2b,x
	bpl ShotMode					; swing not over: no button
	lda.w #$0080
	tsb.b d2
	bra ShotMode
