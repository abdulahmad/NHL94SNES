; The scouting report screen: both teams, the matchups and the scrolling commentary until Start
ScoutingReport:						; called from StartGame_scout
	lda.w #$0001					;show the matchup photos
	sta.l matchupphotos
	stz.w matchuphold				;auto-advance the matchups
	jsl.l clearTeamStats			; clear the team stats and set up the teams
	jsl.l LoadScoutingScreen		; set up the scouting screen graphics and palettes
	ldx.w #$0000					;home team
	jsl.l LoadMatchupPhotos			; unpack the matchup player photos of team x
	ldx.w #$0002					;visiting team
	jsl.l LoadMatchupPhotos			; unpack the matchup player photos of team x
	lda.w #$0008					;band IRQ lines
	ldx.w #$003E
	jsl.l SetupBandIRQ				; set up the band IRQ pair
	stz.w curitem					;first matchup
	stz.w matchuptimer				;matchup timer
	jsl.l .10						;find the hot / cold players
	jsl.l .12						;queue the report sentences
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoutingReportPos>>16
	sta.b a1+2
	lda.w #ScoutingReportPos
	sta.b a1
	jsl.l print						; print ScoutingReportPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016					;22 wide
	sta.b d0
	lda.w #$000B					;11 high
	sta.b d1
	jsl.l FramerOutline				;report box outline
	jsl.l ShowMatchups				; matchups screen
	jsl.l ScoutingHDMA				; scouting screen windows and colour tint
	jsl.l ScreenOn
.3:									;each frame
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	ldx.w #$0002					;from pad 2
	lda.w padnew1					;pad 1 presses
	sta.b r3						;r3 = presses of all team pads
.loop:								; loop: if cont1team,x = 0 go to .1, ...
	lda.w cont1team,x				;pad has a team?
	beq .1							;no
	lda.w padnew1,x					;its presses
	ora.b r3						;merged
	sta.b r3
.1:									; X + 1, X + 1, if carry clear go to .loop, ...
	inx
	inx
	cpx.w #$000A					;5 pads?
	bcc .loop
	lda.b r3						;presses
	bit.w #$1000					;Start?
	bne .5							;yes: leave
	bit.w #$0800					;Up?
	beq .2							;no
	jsl.l WaitSidePadsRelease		;wait for release
.2:									; if not zero go to .6, ...
	bit.w #$4000					;Y?
	bne .6							;previous matchup
	bit.w #$8080					;A or B?
	bne .7							;next matchup
	bit.w #$0040					;X?
	beq .t1
	jmp.w .9						;restart the report

.t1:								;no button
	lda.w matchuphold				;held on one matchup?
	bne .1x							;yes
	lda.w matchuptimer				;matchup timer
	inc a							;+1
	cmp.w #$012C					;300 frames?
	bcs .8							;yes: next matchup
	sta.w matchuptimer				;timer
.1x:								; asv = 0, ora PadRaw2, if zero go to .2x, ...
	stz.w asv						;normal scroll speed
	lda.w PadRaw1					;pads 1
	ora.w PadRaw2					;and 2
	bit.w #$0400					;Down held?
	beq .2x							;no
	lda.w #$FFFF					;fast scroll
	sta.w asv
.2x:								; call UpdateScoutingDisplay, if matchuphold != 0 go to .4, ...
	jsl.l UpdateScoutingDisplay		; print the next word of the scouting report when the timer is up
	lda.w matchuphold				;held on a matchup?
	bne .4							;yes: no time-out
	lda.l notdemo					;demo?
	bne .4							;no: wait for the user
	dec.w screentimer				;demo time left
	bmi .5							;out: leave
.4:									; go to .3
	jmp.w .3
.5:									; matchupphotos = $0000, return
	lda.w #$0000					;photos off
	sta.l matchupphotos
	rtl
.6:									; matchuphold = $FFFF, if a still >= 0 go to .1xx, ...
	lda.w #$FFFF					;hold the matchups (user picked)
	sta.w matchuphold
	lda.w curitem					;matchup
	dec a							;previous
	bpl .1xx						;still >= 0
	lda.w #$0006					;wrap to the last (6)
	sta.w curitem
.1xx:								; curitem = A, call ShowMatchups, matchuptimer = 0, ...
	sta.w curitem
	jsl.l ShowMatchups				; matchups screen
	stz.w matchuptimer				;timer restarted
	bra .4
.7:									; matchuphold = $FFFF
	lda.w #$FFFF					;hold the matchups
	sta.w matchuphold
.8:									; if carry clear go to .1xxx, ...
	lda.w curitem					;matchup
	inc a							;next
	cmp.w #$0007					;past 6?
	bcc .1xxx						;no
	lda.w #$0000					;wrap to 0
.1xxx:								; curitem = A, call ShowMatchups, matchuptimer = 0, ...
	sta.w curitem
	jsl.l ShowMatchups				; matchups screen
	stz.w matchuptimer				;timer restarted
	bra .4
.9:									;restart: clear the report text
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoutingReportPos2>>16
	sta.b a1+2
	lda.w #ScoutingReportPos2
	sta.b a1
	jsl.l print						; print ScoutingReportPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0014					;20 wide
	sta.b d0
	lda.w #$0009					;9 high
	sta.b d1
	lda.l blankchar					;blank tile
	sta.b d2
	jsl.l eraser					;clear the box
	jsl.l .12						;queue the sentences again
	bra .4							;continue
.10:								;reset the three hottest and coldest players of both teams
	lda.w #$FFFF					;no player
	sta.w hotplayer1
	sta.w hotplayer1+2
	sta.w hotplayer2
	sta.w hotplayer2+2
	sta.w hotplayer3
	sta.w hotplayer3+2
	sta.w coldplayer1
	sta.w coldplayer1+2
	sta.w coldplayer2
	sta.w coldplayer2+2
	sta.w coldplayer3
	sta.w coldplayer3+2
	lda.w #$FF06					;hottest values start very low
	sta.w hotvalue1
	sta.w hotvalue2
	sta.w hotvalue3
	sta.w hotvalue1+2
	sta.w hotvalue2+2
	sta.w hotvalue3+2
	lda.w #$00FA					;coldest values start high (250)
	sta.w coldvalue1
	sta.w coldvalue2
	sta.w coldvalue3
	sta.w coldvalue1+2
	sta.w coldvalue2+2
	sta.w coldvalue3+2
	stz.w hotcoldsum				;hot / cold sums of both teams
	stz.w hotcoldsum+2
	stz.b a2						;home team
	jsl.l .11						;rank its players
	lda.w #$0002					;visiting team
	sta.b a2
	jsl.l .11						;rank its players
	lda.w HomeTeam					;assume home is hotter
	sta.w hotterteam
	lda.w #$0001
	sta.w hotextreme				;strongly
	lda.w hotcoldsum				;home sum
	sec
	sbc.w hotcoldsum+2				;minus visitors'
	bmi .t1x						;visitors hotter
	bra .1xxxx						;home: difference in A

.t1x:								; hotterteam = VisTeam
	lda.w VisTeam					;visitors
	sta.w hotterteam
	lda.w hotcoldsum+2				;visitors' sum
	sec
	sbc.w hotcoldsum				;minus home's
.1xxxx:								;difference
	cmp.w #$0008					;8 or more?
	bcs .rtl						;yes: strongly hotter
	stz.w hotextreme				;moderately
	cmp.w #$0004					;4 or more?
	bcs .rtl						;yes
	lda.w #$FFFF					;close: no hotter team
	sta.w hotterteam
.rtl:								; return
	rtl
.11:								;team a2: sum the hot / cold effect of its players and rank them
	jsl.l GetPlayerCount			;d0 = players
	lda.b d0
	sta.b d4						;count
	ldx.w #$0000					;first player
.loopx:								; loop: curplayer = X, d1 = $0001, call GetPlayerBaseRating, ...
	stx.w curplayer					;player
	lda.w #$0001					;scale 1
	sta.b d1
	jsl.l GetPlayerBaseRating		;base rating d0
	lda.b d0
	sta.b d2						;d2
	lda.w #$0001					;scale 1
	sta.b d1
	jsl.l GetPlayerRating			;actual rating d0
	lda.b d0
	sec
	sbc.b d2
	sta.b d0						;d0 = hot / cold effect
	ldy.b a2						;team
	lda.w hotcoldsum,y				;team sum
	clc
	adc.b d0						;plus the effect
	sta.w hotcoldsum,y				;sum
	stx.b d3						;player
	jsl.l .t1xx						;rank it
	inx
	cpx.b d4						;all?
	bmi .loopx
	rtl

.t1xx:								;insert player d3 with effect d0 into the top three hottest and coldest
									;lists
	lda.b d3
	sta.b d1						;player
	lda.b d0
	sta.b r2						;r2 = effect
	cmp.w hotvalue1,y				;hottest?
	beq .1xxxxx
	bpl .t2							;above: insert at 1
.1xxxxx:							; if zero go to .2xx, ...
	cmp.w hotvalue2,y				;second?
	beq .2xx
	bpl .3x							;above: insert at 2
.2xx:								; if zero go to .5x, ...
	cmp.w hotvalue3,y				;third?
	beq .5x
	bpl .4x							;above: insert at 3
	bra .5x							;not hot

.t2:								;shift slot 1 down: save it
	lda.w hotvalue1,y
	sta.b r0
	lda.w hotplayer1,y
	sta.b r1
	lda.b d0						;new value
	sta.w hotvalue1,y
	lda.b d1
	sta.w hotplayer1,y				;new player
	lda.b r0
	sta.b d0						;old value moves down
	lda.b r1
	sta.b d1						;old player
.3x:								;insert at 2, old one moves down
	lda.w hotvalue2,y
	sta.b r0
	lda.w hotplayer2,y
	sta.b r1
	lda.b d0						;value
	sta.w hotvalue2,y
	lda.b d1						;player
	sta.w hotplayer2,y
	lda.b r0						;old value
	sta.b d0
	lda.b r1						;old player
	sta.b d1
.4x:								;insert at 3 (old third drops)
	lda.b d0
	sta.w hotvalue3,y
	lda.b d1
	sta.w hotplayer3,y
.5x:								;now the coldest lists
	lda.b d3
	sta.b d1
	lda.b r2						;effect
	sta.b d0
	cmp.w coldvalue1,y				;coldest?
	bmi .t1xxx
	cmp.w coldvalue2,y				;second?
	bmi .6x
	cmp.w coldvalue3,y				;third?
	bmi .7x							;not cold
	bra .8x

.t1xxx:								;insert at 1, old one moves down
	lda.w coldvalue1,y
	sta.b r0
	lda.w coldplayer1,y
	sta.b r1
	lda.b d0
	sta.w coldvalue1,y
	lda.b d1
	sta.w coldplayer1,y
	lda.b r0
	sta.b d0
	lda.b r1
	sta.b d1
.6x:								;insert at 2, old one moves down
	lda.w coldvalue2,y
	sta.b r0
	lda.w coldplayer2,y
	sta.b r1
	lda.b d0
	sta.w coldvalue2,y
	lda.b d1
	sta.w coldplayer2,y
	lda.b r0
	sta.b d0
	lda.b r1
	sta.b d1
.7x:								;insert at 3
	lda.b d0
	sta.w coldvalue3,y
	lda.b d1
	sta.w coldplayer3,y
.8x:								; return
	rtl
.12:								;queue the report sentences (word list at a0, $FFFF ends)
	jsl.l InitScoutingDisplay		; reset the scouting report scroll state
	lda.w #$001D					;sentence $1D
	sta.b [a0]						;queued
	inc.b a0
	inc.b a0
	lda.w #$001C					;sentence $1C
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w hotterteam				;hotter team?
	bmi .1xxxxxx					;none
	lda.w #$001E					;sentence $1E: hot / cold team
	sta.b [a0]
	inc.b a0
	inc.b a0
.1xxxxxx:							;home team
	lda.w HomeTeam					; home team
	sta.b d0
	lda.w #$001F					;sentence $1F
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w VisTeam					;visitors
	cmp.b d0						;same team?
	beq .2xxx						;yes: skip
	lda.w #$0020					;sentence $20
	sta.b [a0]						; append the away team
	inc.b a0
	inc.b a0
.2xxx:								; [a0] = $0021, increment a0, increment a0, ...
	lda.w #$0021					;sentence $21
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$FFFF					;end
	sta.b [a0]						;of the list
	stz.w asv						;normal speed
	lda.w #$7FFF					;no time-out
	sta.w screentimer				;screen timer
	rtl
