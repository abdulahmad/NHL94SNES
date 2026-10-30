; Stop play for a penalty: stop the clock, set the face off spot and blow the whistle
Stop4Pen:							; called from FallDown, checkfornewpen, puckfaceoff
	lda.w #$FFFF					; clock already stopped: skip the face off spot
	tsb.w gmclock					; stop the clock (all bits)
	beq .t1
	jmp.w .6

.t1:								; d0 = 0, d1 = 0, decrement a0, ...
	stz.b d0						; default spot: center
	stz.b d1
	dec.b a0						; penalty type is before a0
	dec.b a0
	lda.b (a0)						; read it
	inc.b a0
	inc.b a0
	and.w #$00FF					; type byte
	cmp.w #PenGoal					; goal: center ice
	beq .1
	pha
	lda.l ltx
	sta.b d0
	lda.l lty
	sta.b d1
	pla
	cmp.w #PenOOP					; OOP: last touch
	beq .1
	ldy.w puckx						; puck x
	sty.b d0
	ldy.w pucky						; puck y
	sty.b d1
	cmp.w #PenIcing					; icing: +-600 by pfgoal of the icing player
	bne .1
	dec.b a0						; icing player number
	lda.b (a0)
	inc.b a0
	and.w #$00FF
	asl a							; times 2
	tay
	lda.w #$0258					; spot y +600
	sta.b d1
	lda.w pfgoal,y					; his goal
	beq .1
	lda.w #$FDA8					; spot y -600
	sta.b d1
.1:									; tmp0 = d0, if minus go to .2, ...
	lda.b d0						; x within +-70; y near the ends: end face off spots (+-206, x +-70)
	sta.b tmp0
	sec
	sbc.w #$0046					; limit x to +70
	bmi .2
	lda.w #$0046					; x limit 70
	sta.b d0
.2:									; if plus go to .3, ...
	lda.b d0
	sec
	sbc.w #$FFBA					; and to -70
	bpl .3
	lda.w #$FFBA					; -70
	sta.b d0
.3:									; if minus go to .4, ...
	lda.b d1						; y
	sec
	sbc.w #$00A6					; beyond the end of +166?
	bmi .4
	lda.w #$00CE					; end spot y 206
	sta.b d1
	lda.w #$0046					; x 70
	sta.b d0
	lda.b tmp0						; sign of the original x
	bpl .4
	lda.w #$FFBA					; x -70
	sta.b d0
.4:									; if plus go to .5, ...
	lda.b d1
	sec
	sbc.w #$FF5A					; beyond -166?
	bpl .5
	lda.w #$FF32					; end spot y -206
	sta.b d1
	lda.w #$0046					; x 70
	sta.b d0
	lda.b tmp0						; sign of the original x
	bpl .5
	lda.w #$FFBA					; x -70
	sta.b d0
.5:									; fox = d0, foy = d1, call limitfo
	lda.b d0
	sta.l fox
	lda.b d1
	sta.l foy
	jsl.l limitfo					; limit the spot
.6:									; if carry clear go to .1x
	lda.b Vcount					; sound cut off within 60 frames: reset the queue
	sec
	sbc.w sfxmutetime
	cmp.w #$003C					; within 60 frames?
	bcc .1x
.1x:								; if replaydelay != 0 go to .2x, ...
	lda.w replaydelay
	bne .2x
	lda.w #$001E
	sta.w replaydelay
.2x:								; SfxVelocity = $7000, call QueueSound, PenCntDwn = 0, ...
	lda.w #$7000
	sta.b SfxVelocity
	lda.w #$0015
	jsl.l QueueSound				; queue sound A
	stz.w PenCntDwn
	lda.w #$0004
	tsb.w gmode
	lda.w #$000A
	sta.b d0
	jml.l SetPA						; starts the referee animation for penalty d0
