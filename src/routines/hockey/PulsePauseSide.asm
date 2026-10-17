; Pulse the palette colour of the pausing pad's side ($7F76DE or $7F76FE, PulseColour), the other side white;
; both white with no side
PulsePauseSide:
	lda.l notdemo
	beq .2
	ldx.w pausepad
	bmi .2
	lda.w cont1team,x
	beq .2
	dec a
	beq .t1
	ldx.w #$76DE
	ldy.w #$007F
	lda.w #$FFFF
	sta.l colourbuf+$1FE
	bra .1

.t1:
	ldx.w #$76FE
	ldy.w #$007F
	lda.w #$FFFF
	sta.l colourbuf+$1DE
.1:
	jsl.l PulseColour
	bra .3
.2:
	lda.w #$FFFF
	sta.l colourbuf+$1DE
	sta.l colourbuf+$1FE
.3:
	rts
