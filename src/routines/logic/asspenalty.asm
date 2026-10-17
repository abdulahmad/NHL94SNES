; Assignment: the player skates to the penalty box
asspenalty:
	lda.w pflags,x
	bit.w #$0002
	bne .t1
	jmp.w .2

.t1:
	jsl.l .9
	lda.w pflags,x
	and.w #$FFF9
	ora.w #$1000
	sta.w pflags,x
	lda.w #$0000
	sta.b d4
	jsl.l setpads
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	jsl.l PenBoxSpot
	lda.b r2
	sta.b d1
	sta.w temp4,x
	lda.w #sideline
	sta.w temp3,x
	stz.w temp1,x
	lda.w pflags,x
	ora.w #$8000
	sta.w pflags,x
	stz.w Wallcos,x
	stz.w Wallsin,x
	lda.w #$0384
	sta.w temp5,x
.2:
	lda.w temp5,x
	sec
	sbc.w timestep
	sta.w temp5,x
	bpl .6
.1:
	jmp.w .7
.3:
	rtl
.4:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	jml.l skateto
.6:
	lda.w Ypos,x
	sec
	sbc.w temp4,x
	cmp.w #$FFF3
	bmi .4
	cmp.w #$000D
	bpl .4
	lda.w Xpos,x
	sec
	sbc.w temp3,x
	sta.b d0
	sec
	sbc.w #$FFE8
	bmi .4
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .3
	adc.w #$0008
	sta.w temp1,x
	cpx.w puckc
	bne .2x
.1x:
	lda.w #$FFFF
	sta.w puckc
	lda.w #$003C
	sta.w nopuck,x
.2x:
	lda.w #SPAglide
	sta.w pfnc,x
	jsl.l SetSPAFromA
	lda.w #$0006
	sta.b d2
	lda.w handed,x
	beq .3x
	lda.w #$0002
	sta.b d2
.3x:
	lda.w facedir,x
	cmp.b d2
	beq .5
.4x:
	inc a
	and.w #$0007
	sta.w facedir,x
.5:
	stz.w Yvel,x
	lda.w #$1000
	sta.w Xvel,x
	lda.b d0
	sec
	sbc.w #$FFF8
	bmi .8
	stz.w Xvel,x
	lda.w facedir,x
	cmp.b d2
	bne .8
.7:
	lda.w temp4,x
	sta.w Ypos,x
	lda.w #sideline
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallright
	jsl.l SetSPAFromA
	lda.w pflags,x
	and.w #$BFFF
	sta.w pflags,x
	lda.w #$000E
	sta.b d0
	jml.l assreplace
.8:
	rtl
.9:
	ldy.b a2
	lda.w teampads,y
	cmp.w #$0004
	bcc .3xx
.1xx:
	sta.b d1
	lda.w #$0006
	sta.b d0
	lda.w tmsort,y
	tax
	ldy.w #$0000
.loop:
	lda.w position,x
	bmi .2xx
	beq .2xx
	iny
.2xx:
	inx
	inx
	dec.b d0
	bne .loop
	cpy.b d1
	beq .4xx
	bcc .4xx
.3xx:
	ldx.b curobj
	lda.w playerpad,x
	bpl .t1x
	jmp.w .8

.t1x:
	sta.b d4
	jsl.l PassPadToTeammate
	rtl
.4xx:
	cpy.w #$0003
	bne .2xxx
	ldx.b a2
	ldy.w padsitnext,x
.loopx:
	iny
	iny
	cpy.w #$000A
	bne .1xxx
	ldy.w #$0000
.1xxx:
	lda.w padside,y
	bpl .loopx
	and.w #$00FF
	cmp.b a2
	bne .loopx
	sta.w padside,y
	inc a
	inc a
	lsr a
	sta.w cont1team,y
.2xxx:
	ldx.b a2
	ldy.w padsitnext,x
	bra .6x
.5x:
	iny
	iny
	cpy.w #$000A
	bne .6x
	ldy.w #$0000
.6x:
	lda.w padside,y
	cmp.b a2
	bne .5x
	ora.w #$FF00
	sta.w padside,y
	lda.w #$0000
	sta.w cont1team,y
	phy
	iny
	iny
	cpy.w #$000A
	bne .1xxxx
	ldy.w #$0000
.1xxxx:
	tya
	sta.w padsitnext,x
	ply
	ldx.w c1playernum,y
	lda.w #$FFFF
	sta.w c1playernum,y
	sta.w playerpad,x
	jmp.w .3xx
