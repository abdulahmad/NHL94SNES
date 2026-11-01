; Assignment: waiting for a pass
asspassrec:							; X = player; asstab entry, waits for the pass to arrive
	lda.w pflags,x
	bit.w #pfna
	beq .3
	and.w #$FFFD
	ora.w #pfdoff
	sta.w pflags,x
	stz.w temp2,x					; temp2 = 8
	lda.w #$0008					; temp2 = 8
	sta.w temp2b,x
.3:									; passwait,x = passwait,x - timestep, if minus go to .6, ...
	lda.w passwait,x
	sec
	sbc.w timestep
	sta.w passwait,x
	bmi .6
	lda.w puckc
	bpl .6
	lda.w onetimerreq
	bne .8
	ldy.w playerpad,x
	bmi .t2
	lda.w padnew1,y
	bit.w #$8000
	bne .6
	bit.w #$0080
	beq .t2
.4:									; increment onetimerreq, go to .8
	inc.w onetimerreq
	bra .8

.t1:								; bare return, not branched to in this file
	rtl

.t2:								; computer receiver or shoot not pressed: check the team's pads
	ldy.b a2
	lda.w teampads,y
	bne .5
	lda.w pfgoal,x
	bne .2
	lda.w Ypos,x
	cmp.w #$FFA8
	bpl .5
.1:									; call RandomWord, and #$0080, if not zero go to .5, ...
	jsl.l RandomWord
	and.w #$0080
	bne .5
	inc.w onetimerreq
	jmp.w .8
.2:									; pfgoal,x != 0: if Ypos,x - $0058 >= 0 go to .1
	lda.w Ypos,x
	cmp.w #$0058
	bpl .1
.5:									; if puckc negative go to .7
	lda.w puckc
	bmi .7
.6:									; passReceiverPlayerNum = $FFFF, pfalock,x = 0, onetimerreq = 0, ...
	lda.w #$FFFF
	sta.w passReceiverPlayerNum
	stz.w pfalock,x
	stz.w onetimerreq
	lda.w pflags,x
	and.w #(~pfdoff&$FFFF)
	sta.w pflags,x
	jmp.w assexit					; end the player's current assignment and go back to the one under it
.7:									; return
	rtl
.8:									; if SPA,x = SPAonetimerf go to .10, ...
	lda.w SPA,x
	cmp.w #SPAonetimerf
	beq .10
	cmp.w #SPAonetimerb
	beq .10
	phy
	ldy.w #$0000
	cpx.w #$000C
	bmi .1x
	ldy.w #$0002
.1x:								; tmOneTimerSwings,y = tmOneTimerSwings,y + 1, d0 = $0000 - passtargetx...
	lda.w tmOneTimerSwings,y
	inc a
	sta.w tmOneTimerSwings,y
	ply
	lda.w #$0000
	sec
	sbc.w passtargetx
	sta.b d0
	lda.w pfgoal,x
	bne .t1x
	lda.w #$FEF8
	sec
	sbc.w passtargety
	sta.b d1
	bra .2x

.t1x:								; pfgoal set: aim at y = $0108 - passtargety
	lda.w #$0108
	sec
	sbc.w passtargety
	sta.b d1
.2x:								; call vtoa, call Findhittype, if zero go to .t1xx, ...
	jsl.l vtoa						; direction of the vector d0 / d1
	jsl.l Findhittype				; swing type of player X for direction d0
	beq .t1xx
	lda.w #SPAonetimerb
	bra .3x

.t1xx:								; Findhittype gave 0: use SPAonetimerf instead of SPAonetimerb
	lda.w #SPAonetimerf
.3x:								; call SetSPAFromA, go to .7
	jsl.l SetSPAFromA				; start sprite animation A on object X
	jmp.w .7
.9:									; SPAnum,x >= $0010: go to .6
	jmp.w .6
.10:								; nopuck,x = $000A, if SPAnum,x >= $0010 go to .9, ...
	lda.w #$000A
	sta.w nopuck,x
	lda.w SPAnum,x
	cmp.w #$0010
	bcs .9
	txa
	jsl.l GetHot
	lda.w Xpos,x
	clc
	adc.b d0
	sec
	sbc.w puckx
	sta.b d0
	lda.w Ypos,x
	clc
	adc.b d1
	sec
	sbc.w pucky
	sta.b d1
	ldy.b d0
	jsl.l ApproxLength				; A = the approximate length of the vector
	cmp.w #$0008
	bcs .5x
	stz.w SPAcnt,x
	cmp.w #$000C
	bcs .5x
	stx.w puckc
	ldy.w playerpad,x
	bmi .t1xxx
.1xx:								; passdir = paddir,y, go to .4x
	lda.w paddir,y
	sta.w passdir
	bra .4x

.t1xxx:								; computer player (playerpad < 0): passdir = 8
	lda.w #$0008
	sta.w passdir
.4x:								; passspeed = $0024, pfalock,x = $0024, if gmclock != 0 go to .2xx, ...
	lda.w #$0024
	sta.w passspeed
	sta.w pfalock,x
	lda.w gmclock
	bne .2xx
	phy
	ldy.w #$0000
	cpx.w #$000C
	bmi .1xxx
	ldy.w #$0002
.1xxx:								; tmOneTimers,y = tmOneTimers,y + 1
	lda.w tmOneTimers,y
	inc a
	sta.w tmOneTimers,y
	ply
.2xx:								; onetimer = $0001, if minus go to .3xx, ...
	lda.w #$0001
	sta.w onetimer
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .3xx
	sta.w CwdExciteLvl
.3xx:								; a2 = X, call a2touchpuck, a2 = pulled value, ...
	lda.b a2
	pha
	stx.b a2
	jsl.l a2touchpuck
	pla
	sta.b a2
	jsl.l doshot					; the stick is at the puck: launch it toward the goal
	jmp.w .6
.5x:								; if puckc negative go to .t1xxxx
	lda.w puckc
	bmi .t1xxxx
.1xxxx:								; if zero go to .t1xxxx, ...
	cpx.w puckc
	beq .t1xxxx
	jmp.w .6

.t1xxxx:							; puck loose or X has it: return
	rtl
