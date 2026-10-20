; The scouting report screen: both teams, the matchups and the scrolling commentary until Start
ScoutingReport:						; called from StartGame_scout
	lda.w #$0001
	sta.l matchupphotos
	stz.w matchuphold
	jsl.l ClearTeamStats
	jsl.l LoadScoutingScreen
	ldx.w #$0000
	jsl.l LoadMatchupPhotos
	ldx.w #$0002
	jsl.l LoadMatchupPhotos
	lda.w #$0008
	ldx.w #$003E
	jsl.l SetupBandIRQ
	stz.w curitem
	stz.w matchuptimer
	jsl.l .10
	jsl.l .12
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoutingReportPos>>16
	sta.b a1+2
	lda.w #ScoutingReportPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0016
	sta.b d0
	lda.w #$000B
	sta.b d1
	jsl.l FramerOutline
	jsl.l ShowMatchups
	jsl.l ScoutingHDMA
	jsl.l ScreenOn
.3:									; call SendTextMap, call WaitFrame, call ReadPads, ...
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads
	ldx.w #$0002
	lda.w padnew
	sta.b r3
.loop:								; loop: if cont1team,x = 0 go to .1, ...
	lda.w cont1team,x
	beq .1
	lda.w padnew,x
	ora.b r3
	sta.b r3
.1:									; X + 1, X + 1, if carry clear go to .loop, ...
	inx
	inx
	cpx.w #$000A
	bcc .loop
	lda.b r3
	bit.w #$1000
	bne .5
	bit.w #$0800
	beq .2
	jsl.l WaitSidePadsRelease
.2:									; if not zero go to .6, ...
	bit.w #$4000
	bne .6
	bit.w #$8080
	bne .7
	bit.w #$0040
	beq .t1
	jmp.w .9

.t1:								; if matchuphold != 0 go to .1x, ...
	lda.w matchuphold
	bne .1x
	lda.w matchuptimer
	inc a
	cmp.w #$012C
	bcs .8
	sta.w matchuptimer
.1x:								; asv = 0, ora JoyPad+2, if zero go to .2x, ...
	stz.w asv
	lda.w JoyPad
	ora.w JoyPad+2
	bit.w #$0400
	beq .2x
	lda.w #$FFFF
	sta.w asv
.2x:								; call UpdateScoutingDisplay, if matchuphold != 0 go to .4, ...
	jsl.l UpdateScoutingDisplay
	lda.w matchuphold
	bne .4
	lda.l notdemo
	bne .4
	dec.w screentimer
	bmi .5
.4:									; go to .3
	jmp.w .3
.5:									; matchupphotos = $0000, return
	lda.w #$0000
	sta.l matchupphotos
	rtl
.6:									; matchuphold = $FFFF, if a still >= 0 go to .1xx, ...
	lda.w #$FFFF
	sta.w matchuphold
	lda.w curitem
	dec a
	bpl .1xx
	lda.w #$0006
	sta.w curitem
.1xx:								; curitem = A, call ShowMatchups, matchuptimer = 0, ...
	sta.w curitem
	jsl.l ShowMatchups
	stz.w matchuptimer
	bra .4
.7:									; matchuphold = $FFFF
	lda.w #$FFFF
	sta.w matchuphold
.8:									; if carry clear go to .1xxx, ...
	lda.w curitem
	inc a
	cmp.w #$0007
	bcc .1xxx
	lda.w #$0000
.1xxx:								; curitem = A, call ShowMatchups, matchuptimer = 0, ...
	sta.w curitem
	jsl.l ShowMatchups
	stz.w matchuptimer
	bra .4
.9:									; a1 = ScoutingReportPos2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ScoutingReportPos2>>16
	sta.b a1+2
	lda.w #ScoutingReportPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0014
	sta.b d0
	lda.w #$0009
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	jsl.l .12
	bra .4
.10:								; subroutine: hotplayer1 = $FFFF, hotplayer1+2 = $FFFF, hotplayer2 = $F...
	lda.w #$FFFF
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
	lda.w #$FF06
	sta.w hotvalue1
	sta.w hotvalue2
	sta.w hotvalue3
	sta.w hotvalue1+2
	sta.w hotvalue2+2
	sta.w hotvalue3+2
	lda.w #$00FA
	sta.w coldvalue1
	sta.w coldvalue2
	sta.w coldvalue3
	sta.w coldvalue1+2
	sta.w coldvalue2+2
	sta.w coldvalue3+2
	stz.w hotcoldsum
	stz.w hotcoldsum+2
	stz.b a2
	jsl.l .11
	lda.w #$0002
	sta.b a2
	jsl.l .11
	lda.w HomeTeam
	sta.w hotterteam
	lda.w #$0001
	sta.w hotextreme
	lda.w hotcoldsum
	sec
	sbc.w hotcoldsum+2
	bmi .t1x
	bra .1xxxx

.t1x:								; hotterteam = VisTeam
	lda.w VisTeam
	sta.w hotterteam
	lda.w hotcoldsum+2
	sec
	sbc.w hotcoldsum
.1xxxx:								; if carry set go to .rtl, ...
	cmp.w #$0008
	bcs .rtl
	stz.w hotextreme
	cmp.w #$0004
	bcs .rtl
	lda.w #$FFFF
	sta.w hotterteam
.rtl:								; return
	rtl
.11:								; subroutine: call GetPlayerCount, d4 = d0
	jsl.l GetPlayerCount
	lda.b d0
	sta.b d4
	ldx.w #$0000
.loopx:								; loop: curplayer = X, d1 = $0001, call GetPlayerBaseRating, ...
	stx.w curplayer
	lda.w #$0001
	sta.b d1
	jsl.l GetPlayerBaseRating
	lda.b d0
	sta.b d2
	lda.w #$0001
	sta.b d1
	jsl.l GetPlayerRating
	lda.b d0
	sec
	sbc.b d2
	sta.b d0
	ldy.b a2
	lda.w hotcoldsum,y
	clc
	adc.b d0
	sta.w hotcoldsum,y
	stx.b d3
	jsl.l .t1xx
	inx
	cpx.b d4
	bmi .loopx
	rtl

.t1xx:								; subroutine: d1 = d3, r2 = d0, if zero go to .1xxxxx, ...
	lda.b d3
	sta.b d1
	lda.b d0
	sta.b r2
	cmp.w hotvalue1,y
	beq .1xxxxx
	bpl .t2
.1xxxxx:							; if zero go to .2xx, ...
	cmp.w hotvalue2,y
	beq .2xx
	bpl .3x
.2xx:								; if zero go to .5x, ...
	cmp.w hotvalue3,y
	beq .5x
	bpl .4x
	bra .5x

.t2:								; r0 = hotvalue1,y, r1 = hotplayer1,y, hotvalue1,y = d0, ...
	lda.w hotvalue1,y
	sta.b r0
	lda.w hotplayer1,y
	sta.b r1
	lda.b d0
	sta.w hotvalue1,y
	lda.b d1
	sta.w hotplayer1,y
	lda.b r0
	sta.b d0
	lda.b r1
	sta.b d1
.3x:								; r0 = hotvalue2,y, r1 = hotplayer2,y, hotvalue2,y = d0, ...
	lda.w hotvalue2,y
	sta.b r0
	lda.w hotplayer2,y
	sta.b r1
	lda.b d0
	sta.w hotvalue2,y
	lda.b d1
	sta.w hotplayer2,y
	lda.b r0
	sta.b d0
	lda.b r1
	sta.b d1
.4x:								; hotvalue3,y = d0, hotplayer3,y = d1
	lda.b d0
	sta.w hotvalue3,y
	lda.b d1
	sta.w hotplayer3,y
.5x:								; d1 = d3, d0 = r2, if minus go to .t1xxx, ...
	lda.b d3
	sta.b d1
	lda.b r2
	sta.b d0
	cmp.w coldvalue1,y
	bmi .t1xxx
	cmp.w coldvalue2,y
	bmi .6x
	cmp.w coldvalue3,y
	bmi .7x
	bra .8x

.t1xxx:								; r0 = coldvalue1,y, r1 = coldplayer1,y, coldvalue1,y = d0, ...
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
.6x:								; r0 = coldvalue2,y, r1 = coldplayer2,y, coldvalue2,y = d0, ...
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
.7x:								; coldvalue3,y = d0, coldplayer3,y = d1
	lda.b d0
	sta.w coldvalue3,y
	lda.b d1
	sta.w coldplayer3,y
.8x:								; return
	rtl
.12:								; subroutine: call InitScoutDisplay, [a0] = $001D, increment a0, ...
	jsl.l InitScoutDisplay
	lda.w #$001D
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$001C
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w hotterteam
	bmi .1xxxxxx
	lda.w #$001E
	sta.b [a0]
	inc.b a0
	inc.b a0
.1xxxxxx:							; d0 = HomeTeam, [a0] = $001F, increment a0, ...
	lda.w HomeTeam
	sta.b d0
	lda.w #$001F
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w VisTeam
	cmp.b d0
	beq .2xxx
	lda.w #$0020
	sta.b [a0]
	inc.b a0
	inc.b a0
.2xxx:								; [a0] = $0021, increment a0, increment a0, ...
	lda.w #$0021
	sta.b [a0]
	inc.b a0
	inc.b a0
	lda.w #$FFFF
	sta.b [a0]
	stz.w asv
	lda.w #$7FFF
	sta.w screentimer
	rtl
