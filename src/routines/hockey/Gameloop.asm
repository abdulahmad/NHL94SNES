; Main game loop: wait for a frame, the clock, the music, one frame of game logic, the pause
; Runs once per frame until the period ends (or a shootout turnover). Called from StartPer and PlayShootout.
Gameloop:
	lda.b vcount					; wait until vcount has advanced
	sec
	sbc.w oldvcount
	beq Gameloop
	inc.w gameframes				; count the frame, gamefps = 60 * gameframes / FrameCount
	lda.w #$003C
	ldx.w gameframes
	jsl.l Mul16x8U
	lda.w FrameCount
	sta.b r1
	jsl.l Div32U
	lda.b r0
	sta.w gamefps
	lda.w gsp						; game mode 2 with the music off: 1 in $1000 frames starts a team song
	cmp.w #$0002
	bne .1
	lda.w MusicOn
	bne .1
	jsl.l RandomWord
	and.w #$0FFF
	bne .1
	lda.w #$0005
	jsl.l PlayTeamSong
.1:									; step sizes from the frames elapsed (d7): timestep, impactstep (x2),
									; velstep (x16), gravstep (x96)
	jsl.l RandomWord
	lda.b vcount
	tax
	sec
	sbc.w oldvcount
	sta.b d7
	sta.w timestep
	asl a
	sta.w impactstep
	asl a
	asl a
	asl a
	sta.w velstep
	asl a
	sta.w gravstep
	asl a
	adc.w gravstep
	sta.w gravstep
	stx.w lastframevc
	stx.w oldvcount
	jsl.l ReadPads					; read the pads
	lda.w sflags					; clock and penalty shot timer stop in pause mode and while the clock is
									; held (gmclock nonzero)
	bit.w #sfpz
	bne .4
	lda.w gmclock
	bne .4
	lda.w shootoutmode				; normal play unless a penalty shot is on
	bne .t1
	lda.w PenShotActive
	beq .t1
	ldx.b d7						; penalty shot timer counts down by the frames elapsed
	lda.w pstimer
	sec
	sbc.b d7
	sta.w pstimer
	bne .2
	jsl.l EndPenaltyShot			; timer ran out: end the penalty shot
.2:									; skip the game clock this frame
	bra .4

.t1:								; tick the game clock once per elapsed frame (d7 frames)
	ldx.b d7
.loop:								; one frame tick: fraction part drops by $0AAA, a borrow takes one from
									; the clock
	lda.w gameclock
	beq .2x
	lda.w gameclock+2
	sec
	sbc.w #$0AAA
	sta.w gameclock+2
	bcs .2x
	dec.w gameclock
	lda.w CwdExciteLvl				; crowd excitement drops by 3 each second
	clc
	adc.w #$FFFD
	bmi .1x
	sta.w CwdExciteLvl
.1x:								; update the crowd meter
	jsl.l CheckCrowdMeter
.2x:								; next tick
	dex
	bne .loop
.4:									; cheer counter runs down once per $96 frames
	lda.w cheercnt
	beq .1xx
	lda.b vcount
	sec
	sbc.w cheervc
	cmp.w #$0096
	bcc .1xx
	dec.w cheercnt
	lda.w cheervc
	clc
	adc.w #$0096
	sta.w cheervc
.1xx:								; one frame of game logic and demo input
	jsl.l DoGameFrame
	jsl.l demoread
	lda.w sflags
	bit.w #sfpz
	bne .2xx
	lda.w mp5warning				; mp5warning set and gmode bit $0010 clear: force pause mode
	beq .3
	lda.w gmode
	bit.w #$0010
	bne .3
	lda.w #sfpz
	tsb.w sflags
.2xx:								; enter pause mode
	jsl.l Pausemode
.3:									; in a shootout end after a turnover, else loop
	lda.w shootoutmode
	beq .t1x
	lda.w shootoutturnover
	beq .t1x
	rtl

.t1x:								; next frame
	jmp.w Gameloop
