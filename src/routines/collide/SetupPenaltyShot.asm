; Penalty shot set up: the puck at centre ice, every player reassigned, the defending goalie to his pad, the
; shooter (BA_Sktr_SCnum) gets the puck, PenShotActive = 1, timer pstimer = 1000, ClearPenaltyBuffer
SetupPenaltyShot:					; called from puckfaceoff2
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
.1:									; d0 = $0010, call .4, call .4, ...
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
.loop:								; loop: if padside,y negative go to .2, ...
	lda.w padside,y
	bmi .2
	cmp.b d4
	beq .t1
.2:									; Y + 1, Y + 1, if carry clear go to .loop, ...
	iny
	iny
	cpy.w #$000A
	bcc .loop
	bra .3

.t1:								; d4 = Y, call PadTakeGoalie
	sty.b d4
	jsl.l PadTakeGoalie
.3:									; tmtouch1,y = $FFFF, tmtouch2,y = $FFFF, tmtouch3,y = $FFFF, ...
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
.1x:								; puckc = BA_Sktr_SCnum, if pspad negative go to .2x, ...
	lda.w BA_Sktr_SCnum
	sta.w puckc
	tay
	lda.w pspad
	bmi .2x
	sta.w playerpad,y
.2x:								; PenShotActive = 0, increment PenShotActive, penshotlive = $0001, ...
	stz.w PenShotActive
	inc.w PenShotActive
	lda.w #$0001
	sta.w penshotlive
	lda.w #$03E8
	sta.w pstimer
	jsl.l ClearPenaltyBuffer
	rtl
.4:									; subroutine: puckc = X, call assinsert, call assinsert, ...
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
