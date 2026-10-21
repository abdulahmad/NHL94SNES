; If a shot was taken, add it to the shooting team's shots
ChkShotStat:						; called from Goal, checkgoal, puckglue, puckgoalie
	lda.w #$1000
	trb.w sflags
	bne .t1
	jmp.w .7

.t1:								; if gmclock = 0 go to .t3, ...
	lda.w gmclock
	beq .t3
	jmp.w .7

.t3:								; gmclock = 0: a3 = shotplayer, a2 = 0, a1 = $0002, ...
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.b a2
	pha
	lda.b a2+2
	pha
	lda.b a3
	pha
	lda.b a3+2
	pha
	lda.b d0
	pha
	lda.b d0+2
	pha
	phx
	ldx.w shotplayer
	stx.b a3
	stz.b a2
	lda.w #$0002
	sta.b a1
	txa
	cmp.w #$000C
	bmi .1
	lda.w #$0002
	sta.b a2
	stz.b a1
.1:									; if pfteam,x = 0 go to .2, ...
	ldy.w #tmshots
	lda.w pfteam,x
	beq .2
	iny
	iny
.2:									; $0000,y = $0000,y + 1, if a2 != 0 go to .t2, ...
	lda.w $0000,y
	inc a
	sta.w $0000,y
	ldy.b a2
	bne .t2
	lda.w tmap
	sec
	sbc.w tmap+2
	beq .6
	bmi .t1x
	lda.w tmPPShots
	inc a
	sta.w tmPPShots
	bra .6

.t1x:								; tmSHShots = tmSHShots + 1, go to .6
	lda.w tmSHShots
	inc a
	sta.w tmSHShots
	bra .6

.t2:								; a2 != 0: if zero go to .6, ...
	lda.w tmap+2
	sec
	sbc.w tmap
	beq .6
	bmi .t1xx
	lda.w tmPPShots+2
	inc a
	sta.w tmPPShots+2
	bra .6

.t1xx:								; tmSHShots+2 = tmSHShots+2 + 1
	lda.w tmSHShots+2
	inc a
	sta.w tmSHShots+2
.6:									; if a2 = 0 go to .1x, ...
	lda.w gsp
	asl a
	asl a
	tax
	lda.b a2
	beq .1x
	inx
	inx
.1x:								; tmPerShots,x = tmPerShots,x + 1, d0 = pnum,x, if a2 = 0 go to .2x, ...
	lda.w tmPerShots,x
	inc a
	sta.w tmPerShots,x
	ldx.b a3
	lda.w pnum,x
	sta.b d0
	lda.b a2
	beq .2x
	lda.w #$001A
.2x:								; adc d0, if a2 = tmgoalie,x go to .3, ...
	clc
	adc.b d0
	ldx.b a2
	cmp.w tmgoalie,x
	beq .3
	tax
	sep #$20
	inc.w tmpshots,x
	rep #$20
.3:									; d0 = tmgoalie,x, if minus go to .5, ...
	ldx.b a1
	lda.w tmgoalie,x
	sta.b d0
	bmi .5
	lda.b a1
	beq .4
	lda.w #$001A
.4:									; adc d0, increment tmpshots,x
	clc
	adc.b d0
	tax
	sep #$20
	inc.w tmpshots,x
	rep #$20
.5:									; d0+2 = pulled value, d0 = pulled value, a3+2 = pulled value, ...
	plx
	pla
	sta.b d0+2
	pla
	sta.b d0
	pla
	sta.b a3+2
	pla
	sta.b a3
	pla
	sta.b a2+2
	pla
	sta.b a2
	pla
	sta.b a1+2
	pla
	sta.b a1
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .7
	sta.w CwdExciteLvl
.7:									; return
	rtl
