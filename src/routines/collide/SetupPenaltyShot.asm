; Penalty shot set up: the puck at centre ice, every player reassigned, the defending goalie to his pad, the
; shooter ($1E8D) gets the puck, $163A = 1, timer $1E9F = 1000, ClearPenaltyBuffer
SetupPenaltyShot:
	stz.w puckx
	stz.w pucky
	stz.w puckz
	stz.w puckvx
	stz.w puckvy
	stz.w puckvz
	phx
	ldx.w #$0000
	lda.w #$0002
	sta.b d4
	lda.w BA_Team
	beq .1
	ldx.w #$000C
	lda.w #$0000
	sta.b d4
.1:
	lda.w #$0010
	sta.b d0
	jsl.l .4
	jsl.l .4
	jsl.l .4
	jsl.l .4
	jsl.l .4
	jsl.l .4
org $9FB003
	ldx.b d4
	lda.w teampads,x
	beq .3
	lda.w goaliemode1,x
	beq .3
	ldy.w #$0000
.loop:
	lda.w padside,y
	bmi .2
	cmp.b d4
	beq .t1
.2:
	iny
	iny
	cpy.w #$000A
	bcc .loop
	bra .3

.t1:
	sty.b d4
	jsl.l PadTakeGoalie
.3:
	plx
	ldy.w BA_Team
	lda.w #$FFFF
	sta.w tmtouch1,y
	sta.w tmtouch2,y
	sta.w tmtouch3,y
	lda.w CwdExciteLvl
	clc
	adc.w #$0014
	bmi .1x
	sta.w CwdExciteLvl
.1x:
	lda.w BA_Sktr_SCnum
	sta.w puckc
	tay
	lda.w pspad
	bmi .2x
	sta.w playerpad,y
.2x:
	stz.w PenShotActive
	inc.w PenShotActive
	lda.w #$0001
	sta.w penshotlive
	lda.w #$03E8
	sta.w pstimer
	jsl.l ClearPenaltyBuffer
	rtl
.4:
	stx.w puckc
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	inx
	inx
	rtl
