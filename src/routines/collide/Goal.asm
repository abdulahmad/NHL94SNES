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
	lda.w PenShotActive				;penalty shot?
	beq .6							;no: count the goal
	lda.w pucky						; puck at the far or near end, with gmdir this says which team shot at
									; which net
	bpl .t1							;top end
	lda.w gmode						;game mode
	bit.w #gmdir					;ends swapped?
	beq .in							;no: the right net
	bra .t2

.t1:								; same test with the ends swapped
	lda.w gmode
	bit.w #gmdir					;ends swapped?
	beq .t2							;no: the wrong net
	bra .in

.t2:								; shot at the wrong net: BA_Team 0 goes on to count the goal
	lda.w BA_Team					;shooter's team
	beq .6							;home: count it
.1:									; penalty shot ends without a goal
	jsl.l EndPenaltyShot			; end the penalty shot or shootout attempt in progress: clear it
	jmp.w .16
.in:								; shot at the right net
	lda.w BA_Team
	beq .1							;home: no goal
.6:									; count the goal. Log the shot, freeze the window, replay delay 30
									; frames
	jsl.l ChkShotStat				; if a shot was taken, add it to the shooting team's shots
	jsl.l freezewindow				; lock the view at its current position
	lda.w #$001E					;30 frames
	sta.w replaydelay				;before a replay
	stz.b a2						;home scored
	lda.w #$0002
	sta.b a1						;visitors the other
	lda.w pucky						;puck end
	bpl .1x							;top: home
	stz.b a1						;home the other
	lda.w #$0002
	sta.b a2						;visitors scored
.1x:								; gmdir set (ends swapped in this period): swap scorer and other
	lda.w gmode						; gmdir: swap
	bit.w #gmdir					;ends swapped?
	beq .2x							;no
	lda.b a1						;the other team
	sta.b a2						;scored
	eor.w #$0002					;and the one before
	sta.b a1						;is the other
.2x:								; scoring team's score +1
	ldy.b a2						;scorer
	lda.w tmscore,y
	inc a							;one more
	sta.w tmscore,y
	lda.w tmap						;home formation
	sec
	sbc.w tmap+2					;minus visitors'
	beq .4							;even: no
	bmi .t1x						;visitors short
	ldy.b a2						;home short:
	beq .4							;home goal? no
	bra .3							;visitors goal: short handed

.t1x:								; visitors have fewer skaters: only a visitor goal counts
	ldy.b a2						;visitors goal?
	bne .4							;no
.3:									; short handed goal +1
	lda.w tmSHGoals,y				;short handed goals
	inc a
	sta.w tmSHGoals,y
.4:									; penalty shot goal or breakaway goal counters
	lda.w penshot					;penalty shot?
	bne .t1xx						;yes
	lda.w breakaway					;breakaway?
	beq .5							;no
	ldy.b a2
	lda.w tmBreakawayGoals,y		;breakaway goals
	inc a
	sta.w tmBreakawayGoals,y
	bra .5

.t1xx:								; penalty shot goal +1
	ldy.b a2
	lda.w tmPenShotGoals,y			;penalty shot goals
	inc a
	sta.w tmPenShotGoals,y
.5:									; one timer goal +1
	lda.w onetimer					;one-timer?
	beq .1xx						;no
	ldy.b a2
	lda.w tmOneTimerGoals,y			;one-timer goals
	inc a
	sta.w tmOneTimerGoals,y
.1xx:								; music off, siren sound, bench cheer
	jsl.l MusicStop					; stop the song: release its voices and clear its tracks
	lda.w #$0002					;siren
	jsl.l StreamSfx					;stream it
	stz.w benchcheer				;no bench cheer
	ldy.b a2						;home scored?
	beq .t1xxx						;yes
	lda.w #$0004					;visitors' bench
	jsl.l StartBenchCheer			; start bench A cheering, unless one already is: benchcheer = A
	lda.l Crowdlevel				;crowd level
	sec
	sbc.w #$0300					;minus $300
	bpl .2xx						;not below 0
	lda.w #$0000					;floor at 0
.2xx:								; Crowdlevel = A, go to .score
	sta.l Crowdlevel
	bra .score

.t1xxx:								;home bench (A = 0 + 2)
	inc a
	inc a							;bench 2
	jsl.l StartBenchCheer			;home bench cheers
	lda.l Crowdlevel
	clc
	adc.w #$01F4					;plus $1F4
	sta.l Crowdlevel
	lda.w #$0078					;2 seconds
	sta.b crowdhold					;crowd holds
	lda.w #$0003					;goal song
	jsl.l PlayTeamSong				; play song slot A of the home team
.score:								; remember the frame of the goal (sfx mute time), end the penalty
									; shot, clear breakaway and one timer
	lda.b Vcount
	sta.w sfxmutetime				;goal time
	jsl.l EndPenaltyShot			; end the penalty shot or shootout attempt in progress: clear it
	stz.w breakaway					;no breakaway
	stz.w onetimer					;no one-timer
	phx
	lda.w gsp						;period
	asl a
	asl a							;x4: period stats row
	tax
	lda.w CwdExciteLvl
	clc
	adc.w #$001E					;excitement
	bmi .1xxx						;overflow: keep
	sta.w CwdExciteLvl
.1xxx:								; crowd excitement +30, -50 more if the visitors scored
	lda.b a2						;scorer
	beq .2xxx						;home: done
	inx
	inx
	lda.w CwdExciteLvl
	clc
	adc.w #$FFCE					;minus 50
	bmi .2xxx						;underflow: keep
	sta.w CwdExciteLvl
.2xxx:								; goals this period +1 for the scoring team
	lda.w tmPerGoals,x
	inc a							;plus one
	sta.w tmPerGoals,x
	plx
	lda.l ScoreSumbytes				;summary size
	cmp.w #$0258					;full (100 goals)?
	bne .3x							;no
	sec
	sbc.w #$0006					;drop the last
	sta.l ScoreSumbytes
.3x:								; append to the score summary (6 bytes per goal, 100 goals at most)
	lda.w #ScoreSum>>16				;summary
	sta.b a0+2
	lda.w #ScoreSum
	clc
	adc.l ScoreSumbytes				;plus its size
	sta.b a0						;new entry
	lda.l ScoreSumbytes
	adc.w #$0006					;plus 6
	sta.l ScoreSumbytes				;new size
	jsl.l GetPeriodTimeRemaining	; entry word 0 = time left in the period
	lda.b d0
	sta.b [a0]						;time
	inc.b a0						;next word
	inc.b a0
	lda.w #$0002					; entry word 1 = 2 + tmap difference, bit 7 set for a visitor goal
	clc
	ldy.b a2
	adc.w tmap,y					;plus the scorer's formation
	ldy.b a1
	sec
	sbc.w tmap,y					;minus the other's
	ldy.b a2						;scorer
	beq .4x							;home: no flag
	ora.w #$0080					;visitor goal
.4x:								; entry word 2 = scorer, then $FFFF end marker
	sta.b [a0]						;strength byte
	inc.b a0						;next byte
	lda.w tmtouch1,y				;last to touch it
	sta.b d0						;scorer
	sta.b [a0]						;scorer byte
	inc.b a0						;next byte
	lda.w #$FFFF					;end marker
	sta.b [a0]
	ldx.b a2						;scorer's team
	lda.w tmgoalie,x				;its goalie
	cmp.b d0						;the goalie scored?
	beq .6x							;yes: not counted
	lda.b a2						;team
	beq .5x							;home
	lda.w #$001A					;visitors' slots
.5x:								; index the scorer in the team stat table (visitors +$1A)
	clc
	adc.b d0						;plus the scorer
	tax
	sep #$20
	inc.w tmgoals,x					;goals +1
	rep #$20						; 16-bit A
.6x:								; first assist
	ldy.b a2						; assists
	lda.w tmtouch2,y				;second to touch it
	sta.b d0						;first assist
	bmi .9							;none: done
	sep #$20						; 8-bit A
	sta.b [a0]						;assist byte
	rep #$20						; 16-bit A
	lda.b a2						;team
	beq .7							;home
	lda.w #$001A					;visitors' slots
.7:									; assists +1
	clc
	adc.b d0						;plus him
	tax
	sep #$20
	inc.w tmassists,x				;assists +1
	rep #$20
	inc.b a0						;next byte
	lda.w tmtouch3,y				;third to touch it
	sta.b d0						;second assist
	bmi .9							;none
	sep #$20						; 8-bit A
	sta.b [a0]						;assist byte
	rep #$20						; 16-bit A
	lda.b a2						;team
	beq .8							;home
	lda.w #$001A					;visitors' slots
.8:									; second assist, same
	clc
	adc.b d0						;plus him
	tax
	sep #$20
	inc.w tmassists,x				;assists +1
	rep #$20
.9:									; other team's goalie
	ldy.b a1						;other team
	lda.w tmgoalie,y				;its goalie
	sta.b d0						;d0
	bmi .11							;none
	lda.b a1						;team
	beq .10							;home
	lda.w #$001A					;visitors' slots
.10:								; adc d0, increment tmgoals,x
	clc
	adc.b d0						;plus him
	tax
	inc.w tmgoals,x					;goals against +1
.11:								; penalty goal handling, redraw the score
	jsl.l PenGoalStuff				; handles the penalties after a goal
	jsl.l printscores1				; draw the scoreboard: the period and score boxes on the vertical rink
	lda.w #$0008					;assignment 8: celebrate
	sta.b d0
	jsl.l .t1xxxx					; d0 = 8: give team a2's skaters assignment 8 (routine below)
	lda.b a2						;visitors scored?
	bne .12							;(the score test changes nothing)
	lda.w tmscore+2
	sec
	sbc.w tmscore
	bmi .12
	cmp.w #$0003
	bcs .12
.12:								; puck stops at the goal line and pops up
	stz.w collflag
	stz.w puckvx					;stop the puck
	stz.w puckvy
	ldy.w #$0006
	lda.w puckx						;puck x
	bpl .13							;right
	ldy.w #$FFFA					;left
.13:								; puck x +-6
	sty.w puckx
	ldy.w #$0110					;goal line y
	lda.w pucky						;puck y
	bpl .14							;bottom
	ldy.w #$FEF0					;top
.14:								; puck y +-$110, z speed $600
	sty.w pucky
	lda.w #$0600
	sta.w puckvz					;pops up
	stz.w puckz						;on the ice
	lda.w #$FFFF					;no line crossings
	sta.w puckcross+pcframes
	sta.w puckcross+pcsize+pcframes
	sta.w pfnc+puckscnum			;puck collides with no one
	lda.w #$001A					;assignment $1A: in the net
	sta.b d0
	jsl.l assreplace				;for the puck
	inx								; siren sprite animation
	inx
	lda.w #SPAsiren
	jsl.l SetSPAFromA				; start sprite animation A on object X
	ldy.b a2						; scoring team's first skater gets the penalty goal assignment
	ldx.w tmsort,y					;first skater
	stx.b a3
	lda.w #PenGoal					;the goal entry
	sta.b d0						;d0
	jsl.l AddPenalty2				; call penalty d0 on player X without the checks
	ldx.w #puckscnum				;puck object
	stx.b a3						;a3
	rtl

.t1xxxx:							; give each non-absent skater of team a2 assignment d0 (6
									; players)
	phx
	ldy.b a2
	lda.w tmsort,y					;first skater
	tax
	lda.w #$0005					;6 players
	sta.b d3
.loop:								; loop: if position,x negative go to .1xxxx, ...
	lda.w position,x				;on the ice?
	bmi .1xxxx						;no
	beq .1xxxx						;goalie: no
	stz.w pfnc,x					;collisions on
	jsl.l assinsert					; give player X assignment d0 on top of the current one
.1xxxx:								; next skater
	inx
	inx
	dec.b d3						;count
	bpl .loop						;all
	plx
.16:								; return
	rtl
