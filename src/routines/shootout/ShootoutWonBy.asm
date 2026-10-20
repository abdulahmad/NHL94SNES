; "<team> Wins!" once the shootout is decided
ShootoutWonBy:						; "<team> Wins!" once the shootout is decided
	lda.w shootoutmode
	bne .t1
	jmp.w .3

.t1:								; shootoutmode != 0: d0 = $000A, if shootoutdecider != 0 go to .t3, ...
	lda.w #$000A
	sta.b d0
	lda.w shootoutdecider
	bne .t3
	jmp.w .3

.t3:								; shootoutdecider != 0: if not zero go to .t1x, ...
	lda.w tmscore
	sec
	sbc.w tmscore+2
	bne .t1x
	jmp.w .3

.t1x:								; if minus go to .t2, ...
	phx
	phy
	lda.b d1
	pha
	lda.b a1
	pha
	lda.w tmscore
	sec
	sbc.w tmscore+2
	bmi .t2
	ldy.w #$0000
	bra .1

.t2:								; falls through
	ldy.w #$0002
.1:									; call GetTeamLongName, d0 = [a1] & $00FF - 1 - 1 * 2 + $0002, ...
	phy
	lda.w HomeTeam,y
	jsl.l GetTeamLongName
	lda.b [a1]
	and.w #$00FF
	dec a
	dec a
	asl a
	tax
	txa
	clc
	adc.w #$0002
	sta.b d0
	lda.w #$0020
	sec
	sbc.b d0
	lsr a
	sta.w printx
	sta.b r0
	lda.w #$000D
	sta.w printy
	lda.w #$0006
	sta.b d1
	jsl.l Framer
	lda.b r0
	inc a
	sta.w printx
	lda.w #$000E
	sta.w printy
	jsl.l printbig
	lda.w #$000C
	sta.w printx
	lda.w #$0010
	sta.w printy
	ply
	lda.w HomeTeam,y
	cmp.w #$000E
	beq .t1xx
	cmp.w #$000D
	beq .t1xx
	lda.w #WinsMark>>16
	sta.b a1+2
	lda.w #WinsMark
	sta.b a1
	jsl.l printbig
	bra .2

.t1xx:								; a1 = WinMark, call printbig
	lda.w #WinMark>>16
	sta.b a1+2
	lda.w #WinMark
	sta.b a1
	jsl.l printbig
.2:									; a1 = pulled value, d1 = pulled value, d0 = PenNoText
	pla
	sta.b a1
	pla
	sta.b d1
	ply
	plx
	lda.w #PenNoText
	sta.b d0
.3:									; call AddPenalty2, return
	jsl.l AddPenalty2
	rtl
