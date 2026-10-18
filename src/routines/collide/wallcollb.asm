; wallcollb: not over the glass, bounce off the wall
wallcollb_bounce:
	jmp.w wallcoll
; wallcollb: over the glass, out of play
wallcollb_over:
	jmp.w wallcollb_out
; Object X hits a wall: the puck may go over the glass and out of play, else it bounces
wallcollb:
	cpx.w #$001C
	bne wallcollb_bounce
	lda.w puckz
	cmp.w #$0021
	bpl wallcollb_over
	lda.w puckz
	cmp.w #$0016
	bcc wallcollb_bounce
	lda.w pucky
	cmp.w #$0112
	bmi wallcollb_over
	lda.w puckx
	cmp.w #$000D
	bmi wallcollb_bounce
	lda.w puckx
	cmp.w #$0010
	bpl wallcollb_bounce
	lda.w puckvy
	cmp.w #$0FA0
	bmi wallcollb_bounce
	phx
	lda.w puckvy
	pha
	asl a
	pla
	ror a
	sta.w puckvy
	inx
	inx
	stx.b a3
	lda.w #SPAbglass
	sta.b d1
	jsl.l SetSPA
	plx
	stx.b a3
	lda.w #$0006
	jsl.l StreamSfx
	lda.l crowdlevel
	clc
	adc.w #$0258
	sta.l crowdlevel
	lda.w #$005A
	sta.b crowdhold
	lda.w CwdExciteLvl
	clc
	adc.w #$000F
	bmi wallcollb_out
	sta.w CwdExciteLvl
wallcollb_out:
	lda.w #$0040
	tsb.w sflags
	sta.w pfnc+puckobj
	lda.w pucky
	bpl .1
	lda.w #$8000
	tsb.w attribute+puckobj
.1:
	stz.w frame+$1E
	lda.w gmclock
	bne .2
	lda.l ltplayer
	asl a
	sta.b a3
	tax
	lda.w #$0006
	sta.b d0
	jsl.l ShootoutWonBy
	ldx.w #$001C
	stx.b a3
.2:
	jsl.l EndPenaltyShot
	stz.w breakaway
	stz.w onetimer
	rtl
