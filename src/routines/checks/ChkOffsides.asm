; Clear each team's offsides flag once it is back onside; when the puck crosses a blue line into the zone with
; an attacker past it, flag that team offsides
ChkOffsides:						; check both teams for offsides; called from pucknorm, no inputs
	stz.b a1
	lda.w #$0002
	sta.b a2
	jsl.l ClearOffsidesIfAllPlayers	; clear the offsides flag when nobody is offside any more
	stz.b a2
	lda.w #$0002
	sta.b a1
	jsl.l ClearOffsidesIfAllPlayers	; clear the offsides flag when nobody is offside any more
	lda.w #$0054
	sta.b d0
	lda.w pucky
	bpl .t2
	jmp.w ChkOffsides_other			; puck in the negative half: same test with the line negated

.t2:								; puck not past the blue line y: flag only if it was past last frame
	lda.b d0
	sec
	sbc.w pucky
	bmi .t1
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bpl ChkOffsides_rtl
	bra ChkOffsides_blue

.t1:								; puck past the line: flag only if it was not past it last frame
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bmi ChkOffsides_rtl
ChkOffsides_blue:					; puck crossed the line: StartBreakaway, go on if gmoffs is set
	jsl.l StartBreakaway			; at the blue line: CheckBreakaway into breakaway
	lda.w gmode
	bit.w #gmoffs
	bne .t2
	jmp.w ChkOffsides_rtl			; return

.t2:								; offsides on: line = $5E (the blue line plus $0A)
	lda.w #$005E
	sta.b d0
	lda.w gmode
	bit.w #gmdir
	beq .1
	lda.b a2
	ldy.b a1
	sty.b a2
	sta.b a1
.1:									; if puckc >= 0 go to .2, ...
	lda.w puckc
	bpl .2
	lda.w lastplayer
	asl a
.2:									; if plus go to .t1, ...
	cmp.w #$000C
	bpl .t1
	lda.b a2
	beq ChkOffsides_team
	bra ChkOffsides_rtl

.t1:								; puck holder on the second team (index $0C+): go on if a2 != 0
	lda.b a2
	beq ChkOffsides_rtl
ChkOffsides_team:					; check the six skaters of team a2 against the line d0
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
ChkOffsides_loop:					; skater a0: skip empty spots, flag if his Ypos is past the line
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
ChkOffsides_rtl:					; return
	rtl
ChkOffsides_next:					; next skater (a0 += 2) until the six are done
	inc.b a0
	inc.b a0
	dec.b d2
	bpl ChkOffsides_loop
	rtl
ChkOffsides_other:					; puck in the negative half: same test with the line negated
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

.t1:								; puck past the line: flag only if it was not past it last frame
	lda.b d0
	sec
	sbc.w OldYpos+puckobj
	bmi ChkOffsides_rtl
.3:									; call StartBreakaway, if gmode bit gmoffs set go to .t1x, ...
	jsl.l StartBreakaway			; at the blue line: CheckBreakaway into breakaway
	lda.w gmode
	bit.w #gmoffs
	bne .t1x
	jmp.w ChkOffsides_rtl			; return

.t1x:								; offsides on: line = line - $0A
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
.1:									; if puckc >= 0 go to .2, ...
	lda.w puckc
	bpl .2
	lda.w lastplayer
	asl a
.2:									; if plus go to .t2, ...
	cmp.w #$000C
	bpl .t2
	lda.b a2
	beq .4
	bra ChkOffsides_rtl

.t2:								; puck holder on the second team (index $0C+): go on if a2 != 0
	lda.b a2
	beq ChkOffsides_rtl
.4:									; d2 = $0005, a0 = tmsort,y
	lda.w #$0005
	sta.b d2
	ldy.b a2
	lda.w tmsort,y
	sta.b a0
.5:									; if position,y negative go to .t1xx, ...
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

.t1xx:								; next skater (a0 += 2) until the six are done
	inc.b a0
	inc.b a0
	dec.b d2
	bpl .5
	rtl
