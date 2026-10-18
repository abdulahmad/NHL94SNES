; Assignment: celebrating a goal
assscore:
	lda.w gmode
	bit.w #$0040
	beq .1x
	lda.b a2
	inc a
	inc a
	jsl.l StartBenchCheer
.1x:
	ldy.w playerpad,x
	bmi .t2
	lda.w JoyPad,y
	and.w #$FFF0
	beq .t2
	rtl

.t2:
	lda.w Xvel,x
	tax
	lda.w #$00C0
	jsl.l Mul16x8XS
	ldx.b a3
	lda.b r2+1
	sta.w Xvel,x
	lda.w Yvel,x
	tax
	lda.w #$00C0
	jsl.l Mul16x8XS
	ldx.b a3
	lda.b r2+1
	sta.w Yvel,x
	txa
	lsr a
	cmp.w puckc
	bne .1x2
	lda.w #$FFFF
	sta.w puckc
	lda.w #$0708
	sta.w nopuck,x
.1x2:
	lda.w pflags,x
	bit.w #pfna
	beq .3
	and.w #$FFFD
	sta.w pflags,x
	jsl.l .6
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
	lda.w #$005A
	sta.w temp3,x
	lda.w Hpos
	bpl .2x
	lda.w #$FFA6
	sta.w temp3,x
.2x:
	lda.w Vpos
	sta.w temp4,x
.3:
	lda.w #rtss>>16
	sta.b a0+2
	lda.w #rtss
	sta.b a0
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .t1x
	lda.w #SPAcelebrate
	sta.b d1
	sta.w pfalock,x
	cpx.w shotplayer
	bne .5
.4:
	lda.w #SPApump2
	sta.b d1
	lda.w #$FFFF
	sta.w shotplayer
.5:
	jsl.l SetSPA
.6:
	lda.w #$0078
	jsl.l randoma8
	sta.w temp1,x
	rtl

.t1x:
	jmp.w skateto
