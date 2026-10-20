; Each frame: step the cheering bench through its frames (benchframe), and end it ($FFFF) after its rounds
UpdateBenchCheer:					; called from DoGameFrame
	lda.w benchcheer
	beq .5
	lda.w benchframe
	and.w #$0007
	sta.w benchframe
	lda.w benchtimer
	sec
	sbc.w timestep
org $9CA002
	bpl .t1
	clc
	adc.w #$000B
	sta.w benchtimer
	lda.w benchrounds
	cmp.w #$0004
	beq .2
	lda.w benchframe
	inc a
	cmp.w #$0006
	bne .3
	lda.w benchrounds
	inc a
	sta.w benchrounds
	cmp.w #$0004
	beq .4
	lda.w #$0002
	bra .3

.t1:								; benchtimer = A, go to .4
	sta.w benchtimer
	bra .4
.1:									; a counted below 0: benchcheer = 0, go to .5
	stz.w benchcheer
	bra .5
.2:									; benchrounds = $0004: if a counted below 0 go to .1
	lda.w benchframe
	dec a
	bmi .1
.3:									; benchframe = A
	sta.w benchframe
.4:									; benchframe = benchcheer * 2 * 2 * 2 + benchframe, return
	lda.w benchcheer
	asl a
	asl a
	asl a
	adc.w benchframe
	sta.w benchframe
	rtl
.5:									; benchframe = $FFFF, return
	lda.w #$FFFF
	sta.w benchframe
	rtl
