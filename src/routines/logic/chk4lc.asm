; Should the computer call a line change? Then shoot the puck in
chk4lc:								; called from asspuckc
	lda.l OptLine
	cmp.w #$0002
	beq .t1
	lda.w pucky						; puck y
	sta.b d0
	lda.w pfgoal,x					; goal end
	bne .1							; top end
	lda.w #$0000
	sec
	sbc.b d0
	sta.b d0
.1:									; if d0 negative go to .t1, ...
	lda.b d0
	bmi .t1							; puck is on the far side
	sec
	sbc.w #$0058
	bpl .t1
	lda.w seed
	and.w #$0003
	bne .t1
	phy
	ldy.w #$0000
	lda.w pfteam,x
	beq .2
	ldy.w #$0002
.2:									; if not zero go to .t1, ...
	lda.w tmflags,y
	ply
	bit.w #$0008
	bne .t1							; already in line change mode
	stz.b a2						; a2 = 0
	lda.w #$0002
	sta.b a1						; a1 = 2
	lda.w pfteam,x					; team
	beq .3
	stz.b a1
	lda.w #$0002
	sta.b a2
.3:									; call AvgCline, if d0 >= $0C01 go to .t1, ...
	jsl.l AvgCline					; d0 = the average energy of team a2's current line
	lda.b d0						; d0
	cmp.w #$0C01					; average energy of the line still above $C00: no change
	bcs .t1
	lda.w PenShotActive
	bne .t1
	lda.l OptLine
	beq .t1
	jsl.l CompLine					; the computer team picks a line by the man advantage
	jsl.l setpersonel				; put the wanted players of team a2 on the ice
	jsl.l printscores1				; draw the scoreboard: the period and score boxes on the vertical rink
	jml.l CompShoot					; computer player X shoots

.t1:								; return
	rtl
