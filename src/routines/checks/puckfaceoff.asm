; Assignment: the puck at the start of play
puckfaceoff:						; called from asstab
	stz.w CrowdLoud
	lda.w shootoutmode
	beq .t4
	lda.w shootoutstop
	beq .t4
	inc.w shootoutturnover
	rtl

.t4:								; puckc = $FFFF, call pucknorm_move, if pflags,x bit pfna set go to .t1x
	lda.w #$FFFF
	sta.w puckc
	jsl.l pucknorm_move
	lda.w pflags,x
	bit.w #pfna
	bne .t1x
.1x:								; go to .9
	jmp.w .9

.t1x:								; pflags,x bit pfna set: and #$FFFD, pflags,x = A, if gameclock != 0 go...
	and.w #$FFFD
	sta.w pflags,x
	lda.w gameclock					; clock out: PeriodOver
	bne .t2x
.1xx:								; go to PeriodOver
	jml.l PeriodOver				; end of a period

.t2x:								; end of the period
	lda.w gmode
	bit.w #$0040
	beq .t1xx
.1x2:								; go to PeriodOver
	jml.l PeriodOver				; end of a period

.t1xx:								; overtime and not tied: clock control
	lda.w gsp						; overtime and not tied: clockcont_0
	cmp.w #$0003
	bne .t3
.1xxx:								; if tmscore = tmscore+2 go to .t3, ...
	lda.w tmscore
	cmp.w tmscore+2
	beq .t3
	jml.l clockcont_0				; period over: end of period scene, then the period or game over message

.t3:								; no period over: check for a penalty delay
	lda.w gmode
	bit.w #$0008
	beq .t1x2
.1x3:								; go to Stop4Pen
	jml.l Stop4Pen					; stop play for a penalty: stop the clock

.t1x2:								; computer may put the goalie back / pull it
	jsl.l ReturnGoalies				; ReturnGoalies
	lda.w #$FFFF					; temp1/temp2 = -1: no lc box timers
	sta.w temp1,x
	sta.w temp2,x
	lda.l OptLine
	bne .t2xx
	jmp.w .9

.t2xx:								; OptLine != 0: ora penshotlive, if zero go to .t1xxx, ...
	lda.w penshot
	ora.w penshotlive
	beq .t1xxx
	jmp.w .9

.t1xxx:								; lcpad = $FFFF, lcpad+2 = $FFFF, trb tmflags, ...
	lda.w #$FFFF
	sta.w lcpad
	sta.w lcpad+2
	lda.w #$0008
	trb.w tmflags
	trb.w tmflags+2
	lda.w cont1team
	ora.w cont2team
	ora.w cont3team
	ora.w cont4team
	ora.w cont5team
	beq .1xx2
	lda.w sfhormode
	beq .1xx2
	lda.w #$0040
	tsb.w sflags
	jsl.l ClrHor					; switch back from the horizontal rink to the vertical ice rink
.1xx2:								; if newperiod != 0 go to .2, ...
	lda.l newperiod
	bne .2
	lda.w teampads
	beq .2
	jsl.l .11
	lsr a
	sta.b d0
	jsl.l .5
.2:									; if newperiod != 0 go to .3, ...
	lda.l newperiod
	bne .3
	lda.w teampads+2
	beq .3
	jsl.l .12
	lsr a
	sta.b d0
	jsl.l .6
.3:									; newperiod = $0000, a1 = 0, a2 = $0002, ...
	lda.w #$0000
	sta.l newperiod
	stz.b a1						; a1 = home, a2 = away
	lda.w #$0002
	sta.b a2
	sta.b d0
	jsl.l .1
	jmp.w .9
.1:									; subroutine: if OptLine != 0 go to .t1, ...
	lda.l OptLine
	bne .t1
	jmp.w .8

.t1:								; OptLine != 0: if d0 != cont1team go to .t3x, ...
	lda.b d0
	cmp.w cont1team
	bne .t3x
	jmp.w .8

.t3x:								; d0 != cont1team: if not zero go to .t1xxxx, ...
	cmp.w cont2team
	bne .t1xxxx
	jmp.w .8

.t1xxxx:							; if not zero go to .t2, ...
	cmp.w cont3team
	bne .t2
	jmp.w .8

.t2:								; if not zero go to .t1xxxxx, ...
	cmp.w cont4team
	bne .t1xxxxx
	jmp.w .8

.t1xxxxx:							; if not zero go to .4, ...
	cmp.w cont5team
	bne .4
	jmp.w .8
.4:									; call CompLine, call setpersonel, go to printscores1
	jsl.l CompLine					; the computer team picks a line by the man advantage
	jsl.l setpersonel				; update the players on the ice
	jml.l printscores1				; draw the scoreboard: the period and score boxes on the vertical rink
.5:									; subroutine: if OptLine != $0002 go to .7, ...
	lda.l OptLine
	cmp.w #$0002
	bne .7
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w #$0001
	sta.b d0
	bra .4
.6:									; subroutine: if OptLine != $0002 go to .7, ...
	lda.l OptLine
	cmp.w #$0002
	bne .7
	stz.b a1
	lda.w #$0002
	sta.b a2
	sta.b d0
	bra .4
.7:									; a2 = a3, d0 = d0 * 2, a3 = d0 * 2, ...
	ldy.b a3
	sty.b a2
	lda.b d0
	asl a							; exg a2,a3: X = the controlled player
	sta.b d0
	sta.b a3
	tax
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .1xxxx
	ldy.w #$0002
.1xxxx:								; lcpad,y = $FFFF, call SetLCmode, a2 = Y, ...
	lda.w #$FFFF
	sta.w lcpad,y
	jsl.l SetLCmode					; open the line change box for the team of player X
	ply
	sty.b a2
	ldx.b a3
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .2x
	ldy.w #$0002
.2x:								; if zero go to .3x, ...
	lda.w tmflags,y
	ply
	bit.w #$0008
	beq .3x
	lda.w pfteam,x
	beq .t1xxxxxx
	lda.w #$0168					; visitors: temp2 = 6*60, temp4 = SCnum
	sta.w temp2,y
	txa
	lsr a
	sta.w temp4,y
	bra .3x

.t1xxxxxx:							; temp1 = 10*60 (92 5*60)
	lda.w #$0258					; home: temp1 = 10*60, temp3 = SCnum
	sta.w temp1,y
	txa
	lsr a
	sta.w temp3,y
.3x:								; a2 = a3, a3 = a2
	ldx.b a2
	ldy.b a3
	sty.b a2
	stx.b a3
.8:									; return
	rtl
.9:									; penshotlive = 0, d0 = 0, call .t1xxxxxxx, ...
	stz.w penshotlive
	stz.b d0
	jsl.l .t1xxxxxxx
	lda.w #$0020					; temp2/temp4
	sta.b d0
	jsl.l .t1xxxxxxx
	ldx.b a3
	lda.w temp1,x
	bpl .8
	lda.w temp2,x
	bpl .8
	stz.b a2						; a2 = home, a1 = away
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l .1
	lda.w #$001C
	sta.b d0
	ldx.b a3
	jml.l assreplace

.t1xxxxxxx:							;d0 = 0 (temp1/temp3) or $20 (temp2/temp4): update one lc box timer
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	bmi .8
.1xxxxx:							; d1 = temp3,y * 2, a0 = 0, a2 = 0, ...
	lda.w temp3,y					; temp3/temp4 = SCnum of the box owner
	asl a
	sta.b d1
	tay
	stz.b a0
	stz.b a2
	lda.w pfteam,y
	beq .2xx
	lda.w #$0002
	sta.b a2
.2xx:								; if not zero go to .t2xxx, ...
	phy
	ldy.b a2
	lda.w tmflags,y
	ply
	bit.w #$0008
	bne .t2xxx
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	ora.w #$FF00					; timer negative: box closed
	sta.w temp1,y
	ldx.b a3
	jmp.w SetLCmode2				; draw the line change box of team a2

.t2xxx:								; move to the next player slot
	lda.b a3
	clc
	adc.b d0
	tay
	lda.w temp1,y
	sec
	sbc.b d7						; count down
	sta.w temp1,y
	bmi .t1xxxxxxxx
	jmp.w .8

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
	lda.w tmflags,y
	ply
	bit.w #$0008
	beq .2xxx
	stz.b d2
	jsl.l lcfound					; switch team a2 to the line chosen by row d2
	jsl.l SetLCmode2				; draw the line change box of team a2
.2xxx:								; a3 = X, return
	plx
	stx.b a3
	rtl
.10:								; subroutine: falls through
	ldy.w #$0000
.loop:								; loop: if padside,y = a2 go to .t1xxxxxxxxx, ...
	lda.w padside,y
	cmp.b a2
	beq .t1xxxxxxxxx
	iny
	iny
	cpy.w #$000A
	bcc .loop
	lda.w #$FFFF
	bra .1xxxxxxx

.t1xxxxxxxxx:						; padside,y = a2: falls through
	tya
.1xxxxxxx:							; return
	rtl
.11:								; subroutine: a2 = $0000, call .10, return
	lda.w #$0000
	sta.b a2
	jsl.l .10
	tay
	lda.w c1playernum,y
	rtl
.12:								; subroutine: a2 = $0002, call .10, return
	lda.w #$0002
	sta.b a2
	jsl.l .10
	tay
	lda.w c1playernum,y
	rtl
