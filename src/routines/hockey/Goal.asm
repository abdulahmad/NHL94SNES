; The puck is in the goal: the siren, the score, the log, the scoreboard and the celebration (shootout goals
; through EndPenaltyShot)
;
; Takes no registers; the puck position and gmdir decide which team scored. Called from checkgoal.
Goal:								; the puck is in the net: score, log, scoreboard, celebration
	lda.w gmclock					; game clock stopped: no goal, just kill the puck velocity
	beq .t3
	stz.w puckvz
	stz.w puckvx
	stz.w puckvy
	rtl

.t3:								; penalty shot in progress?
	lda.w PenShotActive
	beq .6
	lda.w pucky						; puck at the far or near end, with gmdir this says which team shot at
									; which net
	bpl .t1
	lda.w gmode
	bit.w #gmdir
	beq .in
	bra .t2

.t1:								; same test with the ends swapped
	lda.w gmode
	bit.w #gmdir
	beq .t2
	bra .in

.t2:								; shot at the wrong net: BA_Team 0 goes on to count the goal
	lda.w BA_Team
	beq .6
.1:									; penalty shot ends without a goal
	jsl.l EndPenaltyShot
	jmp.w .16
.in:								; shot at the right net
	lda.w BA_Team
	beq .1
.6:									; count the goal. Log the shot, freeze the window, replay delay 30
									; frames
	jsl.l ChkShotStat
	jsl.l freezewindow
	lda.w #$001E
	sta.w replaydelay
	stz.b a2						; a2 = scoring team (0 home, 2 visitors), a1 = the other
	lda.w #$0002
	sta.b a1
	lda.w pucky
	bpl .1x
	stz.b a1
	lda.w #$0002
	sta.b a2
.1x:								; gmdir set (ends swapped in this period): swap scorer and other
	lda.w gmode
	bit.w #gmdir
	beq .2x
	lda.b a1
	sta.b a2
	eor.w #$0002
	sta.b a1
.2x:								; scoring team's score +1
	ldy.b a2
	lda.w tmscore,y
	inc a
	sta.w tmscore,y
	lda.w tmap						; short handed? compare tmap of the two teams (home - visitors, probably
									; skaters on ice)
	sec
	sbc.w tmap+2
	beq .4
	bmi .t1x
	ldy.b a2
	beq .4
	bra .3

.t1x:								; visitors have fewer skaters: only a visitor goal counts
	ldy.b a2
	bne .4
.3:									; short handed goal +1
	lda.w tmSHGoals,y
	inc a
	sta.w tmSHGoals,y
.4:									; penalty shot goal or breakaway goal counters
	lda.w penshot
	bne .t1xx
	lda.w breakaway
	beq .5
	ldy.b a2
	lda.w tmBreakawayGoals,y
	inc a
	sta.w tmBreakawayGoals,y
	bra .5

.t1xx:								; penalty shot goal +1
	ldy.b a2
	lda.w tmPenShotGoals,y
	inc a
	sta.w tmPenShotGoals,y
.5:									; one timer goal +1
	lda.w onetimer
	beq .1xx
	ldy.b a2
	lda.w tmOneTimerGoals,y
	inc a
	sta.w tmOneTimerGoals,y
.1xx:								; music off, siren sound, bench cheer
	jsl.l MusicStop
	lda.w #$0002
	jsl.l StreamSfx
	stz.w benchcheer
	ldy.b a2
	beq .t1xxx
	lda.w #$0004
	jsl.l StartBenchCheer
	lda.l Crowdlevel
	sec
	sbc.w #$0300
	bpl .2xx
	lda.w #$0000
.2xx:								; Crowdlevel = A, go to .score
	sta.l Crowdlevel
	bra .score

.t1xxx:								; home scored: crowd +$1F4, hold, play the goal song
	inc a
	inc a
	jsl.l StartBenchCheer
	lda.l Crowdlevel
	clc
	adc.w #$01F4
	sta.l Crowdlevel
	lda.w #$0078
	sta.b crowdhold
	lda.w #$0003
	jsl.l PlayTeamSong
.score:								; remember the frame of the goal (sfx mute time), end the penalty
									; shot, clear breakaway and one timer
	lda.b vcount
	sta.w sfxmutetime
	jsl.l EndPenaltyShot
	stz.w breakaway
	stz.w onetimer
	phx
	lda.w gsp
	asl a
	asl a
	tax
	lda.w CwdExciteLvl
	clc
	adc.w #$001E
	bmi .1xxx
	sta.w CwdExciteLvl
.1xxx:								; crowd excitement +30, -50 more if the visitors scored
	lda.b a2
	beq .2xxx
	inx
	inx
	lda.w CwdExciteLvl
	clc
	adc.w #$FFCE
	bmi .2xxx
	sta.w CwdExciteLvl
.2xxx:								; goals this period +1 for the scoring team
	lda.w tmPerGoals,x
	inc a
	sta.w tmPerGoals,x
	plx
	lda.l ScoreSumbytes
	cmp.w #$0258
	bne .3x
	sec
	sbc.w #$0006
	sta.l ScoreSumbytes
.3x:								; append to the score summary (6 bytes per goal, 100 goals at most)
	lda.w #$007E
	sta.b a0+2
	lda.w #ScoreSum
	clc
	adc.l ScoreSumbytes
	sta.b a0
	lda.l ScoreSumbytes
	adc.w #$0006
	sta.l ScoreSumbytes
	jsl.l GetPeriodTimeRemaining	; entry word 0 = time left in the period
	lda.b d0
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$0002					; entry word 1 = 2 + tmap difference, bit 7 set for a visitor goal
	clc
	ldy.b a2
	adc.w tmap,y
	ldy.b a1
	sec
	sbc.w tmap,y
	ldy.b a2
	beq .4x
	ora.w #$0080
.4x:								; entry word 2 = scorer, then $FFFF end marker
	sta.b [a0]
	inc.b a0
	lda.w tmtouch1,y
	sta.b d0
	sta.b [a0]
	inc.b a0
	lda.w #$FFFF
	sta.b [a0]
	ldx.b a2						; scorer (d0) is not the team goalie: count his goal
	lda.w tmgoalie,x
	cmp.b d0
	beq .6x
	lda.b a2
	beq .5x
	lda.w #$001A
.5x:								; index the scorer in the team stat table (visitors +$1A)
	clc
	adc.b d0
	tax
	sep #$20
	inc.w tmgoals,x
	rep #$20
.6x:								; first assist
	ldy.b a2
	lda.w tmtouch2,y
	sta.b d0
	bmi .9
	sep #$20
	sta.b [a0]
	rep #$20
	lda.b a2
	beq .7
	lda.w #$001A
.7:									; assists +1
	clc
	adc.b d0
	tax
	sep #$20
	inc.w tmassists,x
	rep #$20
	inc.b a0
	lda.w tmtouch3,y
	sta.b d0
	bmi .9
	sep #$20
	sta.b [a0]
	rep #$20
	lda.b a2
	beq .8
	lda.w #$001A
.8:									; second assist, same
	clc
	adc.b d0
	tax
	sep #$20
	inc.w tmassists,x
	rep #$20
.9:									; other team's goalie
	ldy.b a1
	lda.w tmgoalie,y
	sta.b d0
	bmi .11
	lda.b a1
	beq .10
	lda.w #$001A
.10:								; adc d0, increment tmgoals,x
	clc
	adc.b d0
	tax
	inc.w tmgoals,x
.11:								; penalty goal handling, redraw the score
	jsl.l PenGoalStuff
	jsl.l printscores1
	lda.w #$0008
	sta.b d0
	jsl.l .t1xxxx					; d0 = 8: give team a2's skaters assignment 8 (routine below)
	lda.b a2
	bne .12
	lda.w tmscore+2
	sec
	sbc.w tmscore
	bmi .12
	cmp.w #$0003
	bcs .12
.12:								; puck stops at the goal line and pops up
	stz.w collflag
	stz.w puckvx
	stz.w puckvy
	ldy.w #$0006
	lda.w puckx
	bpl .13
	ldy.w #$FFFA
.13:								; puck x +-6
	sty.w puckx
	ldy.w #$0110
	lda.w pucky
	bpl .14
	ldy.w #$FEF0
.14:								; puck y +-$110, z speed $600
	sty.w pucky
	lda.w #$0600
	sta.w puckvz
	stz.w puckz
	lda.w #$FFFF
	sta.w puckcross+2
	sta.w puckcross+6
	sta.w pfnc+puckobj
	lda.w #$001A
	sta.b d0
	jsl.l assreplace
	inx								; siren sprite animation
	inx
	lda.w #SPAsiren
	jsl.l SetSPAFromA
	ldy.b a2						; scoring team's first skater gets the penalty goal assignment
	ldx.w tmsort,y
	stx.b a3
	lda.w #PenGoal
	sta.b d0
	jsl.l AddPenalty2
	ldx.w #$001C
	stx.b a3
	rtl

.t1xxxx:							; give each non-absent skater of team a2 assignment d0 (6
									; players)
	phx
	ldy.b a2
	lda.w tmsort,y
	tax
	lda.w #$0005
	sta.b d3
.loop:								; loop: if position,x negative go to .1xxxx, ...
	lda.w position,x
	bmi .1xxxx
	beq .1xxxx
	stz.w pfnc,x
	jsl.l assinsert
.1xxxx:								; next skater
	inx
	inx
	dec.b d3
	bpl .loop
	plx
.16:								; return
	rtl
