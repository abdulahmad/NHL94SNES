; Assignment: the puck at the start of play
puckfaceoff:						; called from asstab
	stz.w CrowdLoud					;crowd quiet
	lda.w shootoutmode				;shootout?
	beq .t4							;no
	lda.w shootoutstop				;attempt stopped?
	beq .t4							;no
	inc.w shootoutturnover			;next turn
	rtl

.t4:								; puckc = $FFFF, call pucknorm_move, if pflags,x bit pfna set go to .t1x
	lda.w #$FFFF
	sta.w puckc						;no puck carrier
	jsl.l pucknorm_move				;move the puck
	lda.w pflags,x
	bit.w #pfna						;new assignment?
	bne .t1x						;yes: set up
.1x:								; go to .9
	jmp.w .9

.t1x:								; pflags,x bit pfna set: and #$FFFD, pflags,x = A, if gameclock != 0 go...
	and.w #$FFFD					;clear the new flag
	sta.w pflags,x
	lda.w gameclock					; clock out: PeriodOver
	bne .t2x
.1xx:								; go to PeriodOver
	jml.l PeriodOver				; end of a period

.t2x:								; end of the period
	lda.w gmode
	bit.w #gmeog					;game over flag?
	beq .t1xx
.1x2:								; go to PeriodOver
	jml.l PeriodOver				; end of a period

.t1xx:								; overtime and not tied: clock control
	lda.w gsp						; overtime and not tied: clockcont_0
	cmp.w #$0003					;overtime?
	bne .t3							;no
.1xxx:								; if tmscore = tmscore+2 go to .t3, ...
	lda.w tmscore
	cmp.w tmscore+2					;tied?
	beq .t3							;yes: play on
	jml.l clockcont_0				; period over: end of period scene, then the period or game over message

.t3:								; no period over: check for a penalty delay
	lda.w gmode
	bit.w #gmpendel					;penalty pending?
	beq .t1x2						;no
.1x3:								; go to Stop4Pen
	jml.l Stop4Pen					; stop play for a penalty: stop the clock

.t1x2:								; computer may put the goalie back / pull it
	jsl.l ReturnGoalies				; ReturnGoalies
	lda.w #$FFFF					; temp1/temp2 = -1: no lc box timers
	sta.w temp1,x
	sta.w temp2,x
	lda.l OptLine					;line changes option
	bne .t2xx						;on
	jmp.w .9						;off: wait

.t2xx:								; OptLine != 0: ora penshotlive, if zero go to .t1xxx, ...
	lda.w penshot
	ora.w penshotlive				;or a live penalty shot
	beq .t1xxx						;neither
	jmp.w .9						;penalty shot: no line change

.t1xxx:								; lcpad = $FFFF, lcpad+2 = $FFFF, trb tmflags, ...
	lda.w #$FFFF
	sta.w lcpad						;no line change pads
	sta.w lcpad+2
	lda.w #$0008					;line box flag
	trb.w tmflags					;home
	trb.w tmflags+2					;visitors
	lda.w cont1team					;any human pads?
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	beq .1xx2						;no
	lda.w sfhormode					;horizontal rink?
	beq .1xx2						;no
	lda.w #sfslock					;scroll lock
	tsb.w sflags
	jsl.l ClrHor					;back to the vertical rink
.1xx2:								; if newperiod != 0 go to .2, ...
	lda.l newperiod					;new period?
	bne .2							;yes: no box
	lda.w teampads					;home pads?
	beq .2							;no
	jsl.l .11						;home's controlled player
	lsr a							;/2
	sta.b d0						;d0
	jsl.l .5						;open home's box
.2:									; if newperiod != 0 go to .3, ...
	lda.l newperiod
	bne .3							;new period?
	lda.w teampads+2				;yes
	beq .3							;visitors' pads?
	jsl.l .12						;no
	lsr a							;visitors' controlled player
	sta.b d0						;/2
	jsl.l .6						;d0
.3:									;open visitors' box
	lda.w #$0000
	sta.l newperiod
	stz.b a1						; a1 = home, a2 = away
	lda.w #$0002					;a1 = home
	sta.b a2						;a2 = visitors
	sta.b d0						;team visitors
	jsl.l .1						;computer line
	jmp.w .9
.1:									; subroutine: if OptLine != 0 go to .t1, ...
	lda.l OptLine					;line changes?
	bne .t1							;yes
	jmp.w .8						;no: done

.t1:								; OptLine != 0: if d0 != cont1team go to .t3x, ...
	lda.b d0						;team
	cmp.w cont1team					;pad 1 plays it?
	bne .t3x						;no
	jmp.w .8						;human: no computer line

.t3x:								; d0 != cont1team: if not zero go to .t1xxxx, ...
	cmp.w cont2team					;pad 2?
	bne .t1xxxx
	jmp.w .8

.t1xxxx:							; if not zero go to .t2, ...
	cmp.w cont3team					;pad 3?
	bne .t2
	jmp.w .8

.t2:								; if not zero go to .t1xxxxx, ...
	cmp.w cont4team					;pad 4?
	bne .t1xxxxx
	jmp.w .8

.t1xxxxx:							; if not zero go to .4, ...
	cmp.w cont5team					;pad 5?
	bne .4
	jmp.w .8
.4:									; call CompLine, call setpersonel, go to printscores1
	jsl.l CompLine					; the computer team picks a line by the man advantage
	jsl.l setpersonel				; update the players on the ice
	jml.l printscores1				; draw the scoreboard: the period and score boxes on the vertical rink
.5:									; subroutine: if OptLine != $0002 go to .7, ...
	lda.l OptLine					;line option
	cmp.w #$0002					;manual?
	bne .7							;no: computer line
	stz.b a2						;home
	lda.w #$0002					;opponent visitors
	sta.b a1
	lda.w #$0001					;player 1
	sta.b d0
	bra .4							;computer picks
.6:									; subroutine: if OptLine != $0002 go to .7, ...
	lda.l OptLine					;line option
	cmp.w #$0002					;manual?
	bne .7							;no: computer line
	stz.b a1						;home opponent
	lda.w #$0002					;visitors
	sta.b a2						;team visitors
	sta.b d0
	bra .4							;computer picks
.7:									; a2 = a3, d0 = d0 * 2, a3 = d0 * 2, ...
	ldy.b a3						;a3 = the controlled player
	sty.b a2
	lda.b d0
	asl a							;x2
	sta.b d0
	sta.b a3
	tax
	phy
	ldy.w #$0000
	lda.w pfteam,x					;his team
	beq .1xxxx						;home
	ldy.w #$0002					;visitors
.1xxxx:								; lcpad,y = $FFFF, call SetLCmode, a2 = Y, ...
	lda.w #$FFFF					;no pad yet
	sta.w lcpad,y					;line box pad
	jsl.l SetLCmode					;open the box
	ply
	sty.b a2						;restore a2
	ldx.b a3						;player
	phy
	ldy.w #$0000					;home
	lda.w pfteam,x					;team
	beq .2x
	ldy.w #$0002					;visitors
.2x:								; if zero go to .3x, ...
	lda.w tmflags,y					;line box flag
	ply
	bit.w #$0008					;box open?
	beq .3x							;no
	lda.w pfteam,x					;team
	beq .t1xxxxxx					;home
	lda.w #$0168					; visitors: temp2 = 6*60, temp4 = SCnum
	sta.w temp2,y
	txa								;visitors' timer
	lsr a							;object
	sta.w temp4,y					;/2
	bra .3x							;box owner

.t1xxxxxx:							; temp1 = 10*60 (92 5*60)
	lda.w #$0258					; home: temp1 = 10*60, temp3 = SCnum
	sta.w temp1,y					;home timer
	txa
	lsr a							;object
	sta.w temp3,y					;/2
.3x:								;box owner
	ldx.b a2
	ldy.b a3						;swap a2 and a3
	sty.b a2
	stx.b a3
.8:									; return
	rtl
.9:									; penshotlive = 0, d0 = 0, call .t1xxxxxxx, ...
	stz.w penshotlive				;no live penalty shot
	stz.b d0						;home timer
	jsl.l .t1xxxxxxx
	lda.w #$0020					;visitors' timer
	sta.b d0
	jsl.l .t1xxxxxxx
	ldx.b a3						;this player
	lda.w temp1,x					;home timer
	bpl .8							;running: wait
	lda.w temp2,x					;visitors' timer
	bpl .8							;running: wait
	stz.b a2						;home
	lda.w #$0001					;player 1
	sta.b d0
	inc a							;visitors
	sta.b a1
	jsl.l .1						;computer lines
	lda.w #$001C					;assignment $1C
	sta.b d0						;d0
	ldx.b a3						;this player
	jml.l assreplace				;replace the assignment

.t1xxxxxxx:							;d0 = 0 (temp1/temp3) or $20 (temp2/temp4): update one lc box timer
	lda.b a3
	clc
	adc.b d0
	tay								;timer index
	lda.w temp1,y					;timer
	bmi .8							;stopped: done
.1xxxxx:							; d1 = temp3,y * 2, a0 = 0, a2 = 0, ...
	lda.w temp3,y					; temp3/temp4 = SCnum of the box owner
	asl a							;x2
	sta.b d1						;d1 = owner
	tay								;owner index
	stz.b a0
	stz.b a2						;home
	lda.w pfteam,y					;owner's team
	beq .2xx						;home
	lda.w #$0002					;visitors
	sta.b a2
.2xx:								; if not zero go to .t2xxx, ...
	phy
	ldy.b a2
	lda.w tmflags,y					;team
	ply
	bit.w #$0008					;box still open?
	bne .t2xxx						;yes: count down
	lda.b a3
	clc
	adc.b d0						;plus the offset
	tay
	lda.w temp1,y					;timer
	ora.w #$FF00					; timer negative: box closed
	sta.w temp1,y					;timer
	ldx.b a3						;this player
	jmp.w SetLCmode2				;redraw the box

.t2xxx:								; move to the next player slot
	lda.b a3
	clc
	adc.b d0
	tay								;timer
	lda.w temp1,y
	sec
	sbc.b d7						;timer
	sta.w temp1,y					;ran out?
	bmi .t1xxxxxxxx					;yes
	jmp.w .8						;no: done

.t1xxxxxxxx:						; line change done
	ldx.b a3
	phx
	ldx.b d1
	stx.b a3
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .1xxxxxx
	ldy.w #$0002
.1xxxxxx:							; if zero go to .2xxx, ...
	lda.w tmflags,y					;line box flag
	ply
	bit.w #$0008					;box open?
	beq .2xxx						;no
	stz.b d2						;first row
	jsl.l lcfound					; switch team a2 to the line chosen by row d2
	jsl.l SetLCmode2				; draw the line change box of team a2
.2xxx:								; a3 = X, return
	plx								;restore a3
	stx.b a3
	rtl
.10:								;first pad on team a2: Y = pad, or $FFFF
	ldy.w #$0000
.loop:								; loop: if padside,y = a2 go to .t1xxxxxxxxx, ...
	lda.w padside,y					;pad side
	cmp.b a2						;team a2?
	beq .t1xxxxxxxxx				;yes
	iny
	iny
	cpy.w #$000A					;all 5 pads?
	bcc .loop
	lda.w #$FFFF					;none
	bra .1xxxxxxx

.t1xxxxxxxxx:						; padside,y = a2: falls through
	tya
.1xxxxxxx:							; return
	rtl
.11:								;home's first pad's player
	lda.w #$0000
	sta.b a2
	jsl.l .10
	tay
	lda.w c1playernum,y				;its player
	rtl
.12:								;visitors' first pad's player
	lda.w #$0002
	sta.b a2
	jsl.l .10
	tay
	lda.w c1playernum,y				;its player
	rtl
