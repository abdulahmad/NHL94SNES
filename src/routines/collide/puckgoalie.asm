; The puck hits goalie a2: a save or not, by his save ratings
puckgoalie:							; called from checkpuckcoll_ccx
	lda.w gmode						; game mode
	bit.w #gmhl						; gmhl
	beq .t1
	jmp.w .7

.t1:								; gmode bits gmhl clear: d2 = 0, if puckz - $0008 >= 0 go to .1, ...
	stz.b d2
	lda.w puckz
	cmp.w #$0008
	bpl .1
	inc.b d2
	inc.b d2
.1:									; d0 = $0000 - d0, d1 = $0000 - d1, call vtoa, ...
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
	lda.w seed						; straight in front or behind: random side
	sta.b d0
.2:									; eor #$0001, adc d2, asl a, ...
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
	lda.w endurance,y				; endurance
	sta.b d1
.3:									; d1 = d1 + $000F, if attribute,y bits $0800 clear go to .4, ...
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
.4:									; if carry set go to .t2, ...
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
	jsl.l PuckSfx					; play sound A with half the puck velocity
	lda.w puckvy
	cmp.w #$3000
	bpl .1x
	cmp.w #$D000
	bpl .5
.1x:								; if minus go to .2x, ...
	lda.w CwdExciteLvl
	clc
	adc.w #$000A
	bmi .2x
	sta.w CwdExciteLvl
.2x:								; if pfteam,y = 0 go to .t1x, ...
	ldy.b a2
	lda.w pfteam,y
	beq .t1x
	lda.w #$0004
	jsl.l StreamSfx					; request streamed sound A
	bra .5

.t1x:								; pfteam,y = 0: Crowdlevel = Crowdlevel + $0258, crowdhold = $003C
	lda.l Crowdlevel
	clc
	adc.w #$0258
	sta.l Crowdlevel
	lda.w #$003C
	sta.b crowdhold
.5:									; if puckc negative go to .1xx, ...
	lda.w puckc
	bmi .1xx
	lsr a
.1xx:								; d2 = A, if plus go to .t2x, ...
	sta.b d2
	bpl .t2x
	jmp.w .9

.t2x:								; if not zero go to .t1xx, ...
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
.6:									; puckvz = 0, nopuck,y = $000A, temp4,y = $0004, ...
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
	lda.b a2						; goalie player number
	jsl.l GetHot					; hot spot offset
.1xxx:								; if zero go to .2xx, ...
	lda.b d1
	and.w #$00FF					; low byte
	bit.w #$0080
	beq .2xx
	ora.w #$FF00
.2xx:								; d1 = A, if d1 = 0 go to .3x, ...
	sta.b d1						; sign extend
	lda.b d1
	beq .3x
	inc.b d1
.3x:								; eor d1, if minus go to .4x, ...
	ldy.b a2						; goalie
	lda.w Yvel,y					; goalie y velocity
	eor.b d1						; compared with the direction
	bmi .4x
	lda.w #$0000
	sec
	sbc.b d1
	sta.b d1
.4x:								; Xvel+1,x = d0, Yvel+1,x = d1, go to puckflip
	sep #$20						; 8-bit A
	lda.b d0						; x velocity high byte
	sta.w Xvel+1,x
	lda.b d1						; y velocity high byte
	sta.w Yvel+1,x
	rep #$20						; 16-bit A
	jmp.w puckflip					; flip the puck
.7:									; return
	rtl
.8:									; go to .6
	jmp.w .6
.9:									; xba, and #$FF00, asl a, ...
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
	jmp.w puckglue					; player a2 takes the puck
