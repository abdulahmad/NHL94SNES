; Assignment: the player comes onto the ice from the bench
asseben:
	lda.w pfalock,x
	bne .t1
	lda.w pflags,x
	bit.w #pfna
	beq .t2
	and.w #$FFFD
	sta.w pflags,x
	stz.w Xvel,x
	stz.w Yvel,x
	stz.w goalieflags,x
	txa
	lsr a
	sec
	sbc.w #$0006
	bmi .1
	inc a
.1:
	phx
	tax
	lda.w #$000E
	jsl.l Mul16x8XS
	plx
	lda.b r2
	sta.w Ypos,x
	lda.w #$FF78
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallright
	ldy.w position,x
	bne .3
.2:
	lda.w #SPAgwallright
.3:
	jml.l SetSPAUpdate

.t1:
	rtl

.t2:
	lda.w #$0004
	sta.w facedir,x
	lda.w pflags,x
	and.w #$6FFF
	sta.w pflags,x
	stz.w pfnc,x
	stz.w SPA,x
	lda.w #$1000
	sta.w Xvel,x
	jml.l assexit
