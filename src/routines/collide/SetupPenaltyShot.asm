; Penalty shot set up: the puck at centre ice, every player reassigned, the defending goalie to his pad, the
; shooter (BA_Sktr_SCnum) gets the puck, PenShotActive = 1, timer pstimer = 1000, ClearPenaltyBuffer
SetupPenaltyShot:					; called from puckfaceoff2
	stz.w puckx						;puck at centre ice
	stz.w pucky						;puck at centre ice
	stz.w puckz						;puck at centre ice
	stz.w puckvx					;puck at rest
	stz.w puckvy					;puck at rest
	stz.w puckvz					;puck at rest
	phx								;save x
	ldx.w #$0000					;home's first player
	lda.w #$0002					;visitors defend
	sta.b d4						;visitors defend
	lda.w BA_Team					;shooting team
	beq .1							;home shoots
	ldx.w #$000C					;visitors' first player
	lda.w #$0000					;home defends
	sta.b d4						;home defends
.1:									;reassign every player
	lda.w #$0010					;assignment 16
	sta.b d0						;d0 = 16
	jsl.l .4						;reassign 6 players
	jsl.l .4
	jsl.l .4
	jsl.l .4
	jsl.l .4
	jsl.l .4
org $9FB003
	ldx.b d4						;defending team
	lda.w teampads,x				;pads on the team?
	beq .3							;no pad on the team: skip
	lda.w goaliemode1,x				;manual goalie?
	beq .3							;auto goalie: skip
	ldy.w #$0000					;first pad
.loop:								;each pad
	lda.w padside,y					;side of pad y
	bmi .2							;no side
	cmp.b d4						;defending side?
	beq .t1							;on the defending side?
.2:									;next pad
	iny
	iny								;next pad
	cpy.w #$000A					;5 pads
	bcc .loop						;next pad
	bra .3							;no pad on this side

.t1:								;this pad takes the goalie
	sty.b d4						;pad
	jsl.l PadTakeGoalie				;the pad takes the goalie
.3:									;clear the touches
	plx								;restore x
	ldy.w BA_Team					;shooting team
	lda.w #$FFFF					;none
	sta.w tmtouch1,y				;no last touch
	sta.w tmtouch2,y				;no assists
	sta.w tmtouch3,y				;no assists
	lda.w CwdExciteLvl				;crowd excitement
	clc
	adc.w #$0014					;plus 20
	bmi .1x							;overflow: keep it
	sta.w CwdExciteLvl				;crowd excitement +20
.1x:								;shooter takes the puck
	lda.w BA_Sktr_SCnum				;shooter
	sta.w puckc						;shooter has the puck
	tay								;shooter index
	lda.w pspad						;pad of the shooter
	bmi .2x							;no pad
	sta.w playerpad,y				;pad on the shooter
.2x:								;start the penalty shot
	stz.w PenShotActive				;penalty shot on
	inc.w PenShotActive				;penalty shot on
	lda.w #$0001					;live
	sta.w penshotlive				;penalty shot live
	lda.w #$03E8					;1000 frames
	sta.w pstimer					;shot timer
	jsl.l ClearPenaltyBuffer		;clear the penalty buffer
	rtl
.4:									;reassign one player
	stx.w puckc						;player
	jsl.l assinsert					;insert the assignments
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	jsl.l assinsert
	inx								;next player
	inx								;next player
	rtl
