; "<team> Wins!" once the shootout is decided
ShootoutWonBy:						; "<team> Wins!" once the shootout is decided
	lda.w shootoutmode				;shootout mode
	bne .t1							;shootout?
	jmp.w .3						;not a shootout: just the penalty

.t1:								;in a shootout
	lda.w #$000A					;penalty $A
	sta.b d0						;d0 = $A for the penalty
	lda.w shootoutdecider			;shootout decided?
	bne .t3							;decided?
	jmp.w .3						;no decider: just the penalty

.t3:								;the shootout has a decider
	lda.w tmscore					;home score
	sec
	sbc.w tmscore+2					;minus the visitors score
	bne .t1x						;scores differ?
	jmp.w .3						;tied: no winner yet

.t1x:								;the shootout is decided
	phx								;save x
	phy								;save y
	lda.b d1						;save d1
	pha								;save d1
	lda.b a1						;save a1
	pha								;save a1
	lda.w tmscore					;home score
	sec
	sbc.w tmscore+2					;home minus visitors
	bmi .t2							;visitors ahead?
	ldy.w #$0000					;home won: offset 0
	bra .1							;print it

.t2:								;visitors won
	ldy.w #$0002					;visitors won (offset 2)
.1:									;print the winner
	phy								;save the team offset
	lda.w HomeTeam,y				;winning team
	jsl.l GetTeamLongName			;a1 = long name
	lda.b [a1]						;length byte
	and.w #$00FF					;string length
	dec a
	dec a							;minus the two pad bytes
	asl a							;two columns per letter
	tax
	txa								;frame width
	clc
	adc.w #$0002
	sta.b d0						;width = 2 * (length - 2) + 2
	lda.w #$0020					;screen width
	sec
	sbc.b d0						;32 minus the width
	lsr a							;half the margin
	sta.w printx					;centered column
	sta.b r0						;keep the frame column
	lda.w #$000D
	sta.w printy					;row $D
	lda.w #$0006					;width in d0
	sta.b d1						;6 rows high
	jsl.l Framer					;draw the frame
	lda.b r0						;frame column
	inc a
	sta.w printx					;inside the frame
	lda.w #$000E
	sta.w printy					;row $E
	jsl.l printbig					;print the team name
	lda.w #$000C
	sta.w printx					;column $C
	lda.w #$0010
	sta.w printy					;row $10
	ply								;team offset
	lda.w HomeTeam,y				;the winning team
	cmp.w #$000E
	beq .t1xx						;team 14: "WIN"
	cmp.w #$000D
	beq .t1xx						;team 13?
	lda.w #WinsMark>>16				;"WINS"
	sta.b a1+2
	lda.w #WinsMark
	sta.b a1
	jsl.l printbig					;print it
	bra .2

.t1xx:								;"WIN" for teams 13 and 14 (plural names)
	lda.w #WinMark>>16
	sta.b a1+2
	lda.w #WinMark
	sta.b a1
	jsl.l printbig					;print it
.2:									;restore the registers
	pla
	sta.b a1
	pla
	sta.b d1
	ply
	plx								;restore the registers
	lda.w #PenNoText				;no penalty text
	sta.b d0						;the penalty number
.3:									;not a decided shootout: AddPenalty2
	jsl.l AddPenalty2				;not a shootout win: the penalty
	rtl
; PlayShootout still calls this; emptied in 94
PlayShootout_ret:					; emptied in 94
	rtl
