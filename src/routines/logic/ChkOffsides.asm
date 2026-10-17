; Clear each team's offsides flag once it is back onside; when the puck crosses a blue line into the zone with an attacker past it, flag that team offsides
ChkOffsides:
	stz.b a1
	lda.w #$0002
	sta.b a2
	jsl.l ClearOffsidesIfAllPlayers
	stz.b a2
	lda.w #$0002
	sta.b a1
	jsl.l ClearOffsidesIfAllPlayers
	lda.w #$0054
	sta.b d0
	lda.w pucky
	bpl .t2
	jmp.w ChkOffsides_other

.t2:
	lda.b d0
	sec
	sbc.w pucky
	bmi .t1
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bpl ChkOffsides_rtl
	bra ChkOffsides_blue

.t1:
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bmi ChkOffsides_rtl
ChkOffsides_blue:
	jsl.l StartBreakaway
	lda.w gmode
	bit.w #gmoffs
	bne .t2
	jmp.w ChkOffsides_rtl

.t2:
	lda.w #$005E
	sta.b d0
	lda.w gmode
	bit.w #gmdir
	beq .1
	lda.b a2
	ldy.b a1
	sty.b a2
	sta.b a1
.1:
	lda.w puckc
	bpl .2
	lda.w lastplayer
	asl a
.2:
	cmp.w #$000C
	bpl .t1
	lda.b a2
	beq ChkOffsides_team
	bra ChkOffsides_rtl

.t1:
	lda.b a2
	beq ChkOffsides_rtl
ChkOffsides_team:
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
ChkOffsides_loop:
	ldy.b a0
	lda.w position,y
	bmi ChkOffsides_next
	lda.b d0
	sec
	sbc.w Ypos,y
	bpl ChkOffsides_next
	ldy.b a2
	lda.w tmflags,y
	ora.w #tmfoside
	sta.w tmflags,y
ChkOffsides_rtl:
	rtl
ChkOffsides_next:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl ChkOffsides_loop
	rtl
ChkOffsides_other:
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
	lda.b d0
	sec
	sbc.w pucky
	bmi .t1
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bpl ChkOffsides_rtl
	bra .3

.t1:
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bmi ChkOffsides_rtl
.3:
	jsl.l StartBreakaway
	lda.w gmode
	bit.w #gmoffs
	bne .t1x
	jmp.w ChkOffsides_rtl

.t1x:
	lda.b d0
	sec
	sbc.w #$000A
	sta.b d0
	lda.w gmode
	bit.w #gmdir
	bne .1
	lda.b a2
	ldy.b a1
	sty.b a2
	sta.b a1
.1:
	lda.w puckc
	bpl .2
	lda.w lastplayer
	asl a
.2:
	cmp.w #$000C
	bpl .t2
	lda.b a2
	beq .4
	bra ChkOffsides_rtl

.t2:
	lda.b a2
	beq ChkOffsides_rtl
.4:
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.5:
	ldy.b a0
	lda.w position,y
	bmi .t1xx
	lda.b d0
	sec
	sbc.w Ypos,y
	bmi .t1xx
	ldy.b a2
	lda.w tmflags,y
	ora.w #tmfoside
	sta.w tmflags,y
	rtl

.t1xx:
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .5
	rtl
