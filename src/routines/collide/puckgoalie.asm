; The puck hits goalie a2: a save or not, by his save ratings
puckgoalie:
	lda.w gmode						; game mode
	bit.w #gmhl						; gmhl
	beq .t1
	jmp.w .7

.t1:
	stz.b d2
	lda.w puckz
	cmp.w #$0008
	bpl .1
	inc.b d2
	inc.b d2
.1:
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
	jsl.l vtoa						; vector to direction
	ldy.b a2
	lda.b d0						; minus the facing
	sec
	sbc.w facedir,y
	and.w #$0007					; 0-7
	sta.b d0
	and.w #$0003					; front or back?
	sta.b d1
	bne .2
	lda.w seed
	sta.b d0
.2:
	lda.b d0						; side bit
	and.w #$0004
	lsr a
	lsr a
	eor.w #$0001
	clc
	adc.b d2
	asl a
	sta.b d2
	lda.w GGSleft,y					; save rating for the region: GGSleft, passacc, spodds, endurance
	sta.b d1
	lda.b d2
	beq .3
	lda.w passacc,y					; passacc
	sta.b d1
	lda.b d2
	cmp.w #$0002
	beq .3
	lda.w spodds,y					; spodds
	sta.b d1
	lda.b d2
	cmp.w #$0004
	beq .3
	lda.w endurance,y
	sta.b d1
.3:
	lda.b d1
	clc
	adc.w #$000F					; plus 15
	sta.b d1
	lda.w attribute,y				; attribute
	bit.w #$0800
	beq .4
	lda.b d2						; mirror the side
	eor.w #$0002
	sta.b d2
.4:
	lda.w frame,y					; goalie frame
	sec
	sbc.w #SPFgdive					; goalie dive frames SPFgdive..+15
	cmp.w #$0010
	bcs .t2
	lda.w puckz
	cmp.w #$0005
	bmi .t2
	jmp.w .7

.t2:								; save: count the shot, the goalie touches the puck
	jsl.l ChkShotStat				; ChkShotStat
	jsl.l a2touchpuck				; goalie touches the puck
	lda.w #$0006
	jsl.l PuckSfx
	lda.w puckvy
	cmp.w #$3000
	bpl .1x
	cmp.w #$D000
	bpl .5
.1x:
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .2x
	sta.w CwdExciteLvl
.2x:
	ldy.b a2
	lda.w pfteam,y
	beq .t1x
	lda.w #$0004
	jsl.l StreamSfx
	bra .5

.t1x:
	lda.l crowdlevel
	clc
	adc.w #$0258
	sta.l crowdlevel
	lda.w #$003C
	sta.b crowdhold
.5:
	lda.w puckc
	bmi .1xx
	lsr a
.1xx:
	sta.b d2
	bpl .t2x
	jmp.w .9

.t2x:
	cpx.w puckc
	bne .t1xx
	jmp.w .9

.t1xx:								;carrier loses the puck
	lda.w #$FF00					; puckc high byte = $FF: loose
	tsb.w puckc
	asl.b d2						; offset
	lda.b d2
	sta.b a0						; a0 = old carrier
	tay
	lda.w #$0014					; old carrier nopuck = 20
	sta.w nopuck,y					; nopuck 20
	tya
	lsr a
	sta.w lastplayer				; lastplayer
	lda.w #$000C
	trb.w sflags
.6:
	stz.w puckvz
	ldy.b a2
	lda.w #$000A					; nopuck 10 for the goalie
	sta.w nopuck,y
	lda.w #$0004
	sta.w temp4,y					; temp4 = 4
	lda.w Xpos,x					; puck x
	sec
	sbc.w Xpos,y					; minus the goalie x
	sta.b d0
	lda.w Ypos,x					; puck y
	sec
	sbc.w Ypos,y					; minus the goalie y
	sta.b d1
	bne .1xxx
	lda.b a2
	jsl.l GetHot
.1xxx:
	lda.b d1
	and.w #$00FF					; low byte
	bit.w #$0080
	beq .2xx
	ora.w #$FF00
.2xx:
	sta.b d1
	lda.b d1
	beq .3x
	inc.b d1
.3x:
	ldy.b a2						; goalie
	lda.w Yvel,y					; goalie y velocity
	eor.b d1						; compared with the direction
	bmi .4x
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.4x:
	sep #$20						; 8-bit A
	lda.b d0						; x velocity high byte
	sta.w Xvel+1,x
	lda.b d1						; y velocity high byte
	sta.w Yvel+1,x
	rep #$20						; 16-bit A
	jmp.w puckflip					; flip the puck
.7:
	rtl
.8:
	jmp.w .6
.9:
	lda.w #$0002					; catch speed limit = random((2+shotspd)*512) + $C00
	clc
	adc.w shotspd,y					; plus the shot speed
	xba
	and.w #$FF00
	asl a
	jsl.l randoma					; random number 0 to A-1
	adc.w #$2000
	sta.b d0
	cmp.w puckvx
	bmi .8
	lda.b d0
	cmp.w puckvy
	bmi .8
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	cmp.w puckvx
	bpl .8
	lda.b d0
	cmp.w puckvy
	bpl .8
	ldy.b a2
	lda.w pflags,y
	bit.w #$1000
	bne .8
	stz.w puckvz
	jmp.w puckglue
