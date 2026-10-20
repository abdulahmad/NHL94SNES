; Draw the pause menu: five items of the current list (by $1EB7) from item $0D13, the selected one (psitem)
; highlighted, each with its value
Pmenu:								; called from PauseMenuPoll, SelectPauseController, ShowMP5Warning, Sta...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PmenuPos>>16
	sta.b a1+2
	lda.w #PmenuPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w psfirst
	sta.b d0
	lda.w pmenulist
	beq .t1
	cmp.w #$0001
	beq .t3
	cmp.w #$0002
	beq .t4
	cmp.w #$0003
	beq .t5
	cmp.w #$0004
	beq .t6
	bra .t2

.t1:								; pmenulist = 0: a0 = PauseMenuItems, go to .t7
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems
	sta.b a0
	bra .t7

.t2:								; a0 = PauseMenuItems+210, go to .t7
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+210
	sta.b a0
	bra .t7

.t3:								; a0 = PauseMenuItems+429, go to .t7
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+429
	sta.b a0
	bra .t7

.t4:								; a0 = PauseMenuItems+626, go to .t7
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+626
	sta.b a0
	bra .t7

.t5:								; a0 = PauseMenuItems+732, go to .t7
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+732
	sta.b a0
	bra .t7

.t6:								; a0 = PauseMenuItems+808, go to .t7
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+808
	sta.b a0
	bra .t7

.t7:								; falls through
	lda.b a0
	ldx.b d0
.loop:								; loop: X - 1, if X counted below 0 go to .2, ...
	dex
	bmi .2
	clc
	adc.b [a0]
	sta.b a0
	bra .loop
.2:									; loop: printa = $2400, if d0 != psitem go to .1, ...
	lda.w #$2400
	sta.w printa
	lda.b d0
	cmp.w psitem
	bne .1
	lda.w #$2000
	sta.w printa
.1:									; printx = $0006, a1 = PmenuPos2, call print, ...
	lda.w #$0006
	sta.w printx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PmenuPos2>>16
	sta.b a1+2
	lda.w #PmenuPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	ldy.w #$001E
.loopx:								; loop: [a1],y = [a0],y, Y - 1, Y - 1, ...
	lda.b [a0],y
	sta.b [a1],y
	dey
	dey
	bpl .loopx
	jsl.l .t3x
	jsl.l PmenuGoalieValue
	jsl.l PmenuDefValue
	lda.b [a1]
	lsr a
	eor.w #$FFFF					; negate: two's complement
	inc a
	clc
	adc.w #$0011
	sta.w printx
	jsl.l print
	inc.w printy
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	inc.b d0
	lda.b d0
	sec
	sbc.w psfirst
	cmp.w #$0005
	bne .2
	rtl

.t3x:								; subroutine: a3 = PmenuValueItems, a3 = pmenulist * 2 + a3, if [a3] =...
	lda.w #PmenuValueItems>>16
	sta.b a3+2
	lda.w #PmenuValueItems
	sta.b a3
	lda.w pmenulist
	asl a
	clc
	adc.b a3
	sta.b a3
	lda.b [a3]
	cmp.b d0
	beq .t1x
	jmp.w PmenuRtl

.t1x:								; [a3] = d0: call GetPadTeam, if tmgoalie,y >= 0 go to .t2x, ...
	jsl.l GetPadTeam
	ldy.b a2
	lda.w tmgoalie,y
	bpl .t2x
	jmp.w PmenuNone

.t2x:								; tmgoalie,y >= 0: tmp0 = A, a4 = tmdata,y, a4+2 = $009C, ...
	sta.b tmp0
	lda.w tmdata,y
	sta.b a4
	lda.w #$009C
	sta.b a4+2
	ldy.w #$0000
	lda.b [a4],y
	clc
	adc.b a4
	sta.b a4
.loopxx:							; loop: decrement tmp0, if tmp0 counted below 0 go to .t1xx, ...
	dec.b tmp0
	bmi .t1xx
	lda.b [a4]
	clc
	adc.b a4
	adc.w #$0008
	sta.b a4
	bra .loopxx

.t1xx:								; tmp0 counted below 0: falls through
	ldy.w #$0001
.loopxxx:							; loop: Y + 1, if not zero go to .loopxxx
	iny
	lda.b [a4],y
	and.w #$00FF
	cmp.w #$0020
	bne .loopxxx
PmenuAppend:						; called from PmenuDefValue, PmenuGoalieValue, PmenuNone
	iny
	tya
	cmp.b [a4]
	beq PmenuRtl
	lda.b [a4],y
	phy
	ldy.w mesarea
	sta.w mesarea,y
	inc.w mesarea
	ply
	bra PmenuAppend
PmenuRtl:							; called from Pmenu, PmenuAppend, PmenuDefValue, PmenuGoalieValue
	rtl
PmenuGoalieValue:					; called from Pmenu
	lda.w #PmenuValueItems>>16
	sta.b a3+2
	lda.w #PmenuValueItems+12
	sta.b a3
	lda.w pmenulist
	asl a
	clc
	adc.b a3
	sta.b a3
	lda.b [a3]
	cmp.b d0
	beq .t2
	jmp.w PmenuRtl

.t2:								; [a3] = d0: call GetPadTeam, if goaliemode1,y = 0 go to .t1, ...
	jsl.l GetPadTeam
	ldy.b a2
	lda.w goaliemode1,y
	beq .t1
	lda.w #GoalieOptionText>>16
	sta.b a4+2
	lda.w #GoalieOptionText+18
	sta.b a4
	bra .1

.t1:								; goaliemode1,y = 0: a4 = GoalieOptionText
	lda.w #GoalieOptionText>>16
	sta.b a4+2
	lda.w #GoalieOptionText
	sta.b a4
.1:									; call PmenuAppend, return
	ldy.w #$0001
	jsl.l PmenuAppend
	rtl
PmenuDefValue:						; called from Pmenu
	lda.w #PmenuValueItems>>16
	sta.b a3+2
	lda.w #PmenuValueItems+24
	sta.b a3
	lda.w pmenulist
	asl a
	clc
	adc.b a3
	sta.b a3
	lda.b [a3]
	cmp.b d0
	beq .t2
	jmp.w PmenuRtl

.t2:								; [a3] = d0: call GetPadTeam, if defcontrol,y = 0 go to .t1, ...
	jsl.l GetPadTeam
	ldy.b a2
	lda.w defcontrol,y
	beq .t1
	lda.w #GoalieOptionText>>16
	sta.b a4+2
	lda.w #GoalieOptionText+39
	sta.b a4
	bra .1

.t1:								; defcontrol,y = 0: a4 = GoalieOptionText+43
	lda.w #GoalieOptionText>>16
	sta.b a4+2
	lda.w #GoalieOptionText+43
	sta.b a4
.1:									; call PmenuAppend, return
	ldy.w #$0001
	jsl.l PmenuAppend
	rtl
