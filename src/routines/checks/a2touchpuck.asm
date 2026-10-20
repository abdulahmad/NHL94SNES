; A player touches the puck: remember the last touches (for assists), then the offsides and icing checks
a2touchpuck:						; takes a2 = player; called when a player touches the puck
	ldy.b a2
	cpy.w #$0018
	bcc .t2
	jmp.w .6

.t2:								; player object: save his x / y / index as the last toucher
	lda.w Xpos,y
	sta.l ltx
	lda.w Ypos,y
	sta.l lty
	tya
	lsr a
	sta.l ltplayer
	stz.b a0
	lda.w pfteam,y
	beq .1
	inc.b a0
	inc.b a0
.1:									; d0 = pnum,y, if a0 = tmtouch1,y go to .4, ...
	lda.w pnum,y
	sta.b d0
	ldy.b a0
	cmp.w tmtouch1,y
	beq .4
	lda.w tmflags,y
	bit.w #$0004
	beq .t1
	and.w #$FFFB
	sta.w tmflags,y
	cpy.w #$0000
	bne .3
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .2
	sta.w CwdExciteLvl
.2:									; go to .3
	bra .3

.t1:								; team flag $0004 clear: shift the touch history down by one
	lda.w tmtouch2,y
	sta.w tmtouch3,y
	lda.w tmtouch1,y
	sta.w tmtouch2,y
.3:									; tmtouch1,y = d0, if not zero go to .4, ...
	lda.b d0
	sta.w tmtouch1,y
	cmp.w tmtouch3,y
	bne .4
	lda.w #$FFFF
	sta.w tmtouch3,y
.4:									; trb sflags, call a2offsides, if iflags bits $0004 clear go to .8, ...
	lda.w #$1000
	trb.w sflags
	jsl.l a2offsides
	ldy.b a2
	lda.w iflags
	bit.w #$0004
	beq .8
	bit.w #$0001
	beq .8
	lda.w position,y
	beq .8
	lda.w iflags
	bit.w #$0002
	bne .7
	lda.w pfgoal,y
	beq .8
.5:									; a3 = iflags+1 & $00FF * 2, d0 = PenIcing, call AddPenalty, ...
	phx
	lda.w iflags+1
	and.w #$00FF
	asl a
	sta.b a3
	tax
	lda.w #PenIcing
	sta.b d0
	jsl.l AddPenalty
	plx
	stx.b a3
.6:									; return
	rtl
.7:									; iflags bit $0002 set: if pfgoal,y = 0 go to .5
	lda.w pfgoal,y
	beq .5
.8:									; xba, iflags = A, d0 = pucky, ...
	tya
	lsr a
	xba
	sta.w iflags
	lda.w pucky
	sta.b d0
	lda.w pfgoal,y
	beq .1x
	lda.w #$0002
	tsb.w iflags
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1x:								; if d0 negative go to .6, ...
	lda.b d0
	bmi .6
	lda.w tmap
	sec
	sbc.w tmap+2
	sta.b d0
	lda.w pfteam,y
	beq .2x
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.2x:								; if d0 negative go to .6, ...
	lda.b d0
	bmi .6
	lda.w #$0004
	tsb.w iflags
	rtl
