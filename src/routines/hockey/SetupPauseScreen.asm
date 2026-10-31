; Draw the pause menu: five items of the current list (by pmenulist) from item psfirst, the selected one
; (psitem) highlighted, each with its value
SetupPauseScreen:					; called from PauseMenuPoll, SelectPauseController, ShowMP5Warning, Sta...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PmenuPos>>16
	sta.b a1+2
	lda.w #PmenuPos
	sta.b a1
	jsl.l print						; print PmenuPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w psfirst					;first item shown
	sta.b d0						;d0 = item number
	lda.w pmenulist					;which list
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

.t1:								;list 0: main pause menu
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems
	sta.b a0
	bra .t7

.t2:								;list 5 and up
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+210
	sta.b a0
	bra .t7

.t3:								;list 1
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+429
	sta.b a0
	bra .t7

.t4:								;list 2
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+626
	sta.b a0
	bra .t7

.t5:								;list 3
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+732
	sta.b a0
	bra .t7

.t6:								;list 4
	lda.w #PauseMenuItems>>16
	sta.b a0+2
	lda.w #PauseMenuItems+808
	sta.b a0
	bra .t7

.t7:								;a0 = first item of the list
	lda.b a0
	ldx.b d0						;item number
.loop:								;skip to item psfirst: each starts with its length
	dex
	bmi .2
	clc
	adc.b [a0]						;plus its length
	sta.b a0						;next item
	bra .loop
.2:									;each shown item: normal palette
	lda.w #$2400					; normal item palette
	sta.w printa
	lda.b d0						;item
	cmp.w psitem					;the selected one?
	bne .1							;no
	lda.w #$2000					;highlight palette
	sta.w printa
.1:									; printx = $0006, a1 = PmenuPos2, call print, ...
	lda.w #$0006					;column 6
	sta.w printx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PmenuPos2>>16
	sta.b a1+2
	lda.w #PmenuPos2
	sta.b a1
	jsl.l print						; print PmenuPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #mesarea>>16				;text buffer
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	ldy.w #$001E					;32 bytes
.loopx:								;copy the item text
	lda.b [a0],y
	sta.b [a1],y
	dey
	dey
	bpl .loopx
	jsl.l .t3x						;append the goalie name if this is the goalie item
	jsl.l PmenuGoalieValue			;or the goalie mode
	jsl.l PmenuDefValue				;or the defence control
	lda.b [a1]						;text length
	lsr a							;half
	eor.w #$FFFF					; negate: two's complement
	inc a							;minus half
	clc
	adc.w #$0011					;centred on column 17
	sta.w printx
	jsl.l print						;print the item
	inc.w printy					;next row
	lda.b a0						;item
	clc
	adc.b [a0]						;plus its length
	sta.b a0						;next item
	inc.b d0						;item number
	lda.b d0
	sec
	sbc.w psfirst
	cmp.w #$0005					;5 shown?
	bne .2							;no
	rtl

.t3x:								;append the goalie's name if item d0 is this list's goalie item
	lda.w #PmenuValueItems>>16		;goalie item numbers per list
	sta.b a3+2
	lda.w #PmenuValueItems
	sta.b a3
	lda.w pmenulist					;list
	asl a							;x2
	clc
	adc.b a3
	sta.b a3						;entry
	lda.b [a3]						;goalie item of the list
	cmp.b d0						;this item?
	beq .t1x						;yes
	jmp.w PmenuRtl					;no

.t1x:								; [a3] = d0: call GetPadTeam, if tmgoalie,y >= 0 go to .t2x, ...
	jsl.l GetPadTeam				; a2 = the team of the controller that paused, from its side
	ldy.b a2						;team
	lda.w tmgoalie,y				;goalie in net
	bpl .t2x						;one
	jmp.w PmenuNone					;pulled

.t2x:								; tmgoalie,y >= 0: tmp0 = A, a4 = long tmdata,y, ...
	sta.b tmp0						;goalie index
	lda.w tmdata,y					;team data
	sta.b a4						; team data
	lda.w #TeamList>>16
	sta.b a4+2
	ldy.w #$0000					;start
	lda.b [a4],y					;offset of the roster
	clc
	adc.b a4						;plus it
	sta.b a4						;a4 = first player
.loopxx:							; loop: decrement tmp0, if tmp0 counted below 0 go to .t1xx, ...
	dec.b tmp0						;count down to the goalie
	bmi .t1xx						;there
	lda.b [a4]						;entry length
	clc
	adc.b a4						;plus it
	adc.w #$0008					;plus 8
	sta.b a4						;next player
	bra .loopxx

.t1xx:								; tmp0 counted below 0: falls through
	ldy.w #$0001					;from the second byte
.loopxxx:							;skip the first name
	iny
	lda.b [a4],y					;char
	and.w #$00FF
	cmp.w #$0020					;space?
	bne .loopxxx					;no
PmenuAppend:						;append [a4] from Y+1 to its length onto mesarea
	iny
	tya
	cmp.b [a4]						;end of the string?
	beq PmenuRtl					;yes
	lda.b [a4],y					;char
	phy
	ldy.w mesarea					;length so far
	sta.w mesarea,y					;append
	inc.w mesarea					;longer
	ply
	bra PmenuAppend
PmenuRtl:							; called from SetupPauseScreen, PmenuAppend, PmenuDefValue, ...
	rtl
PmenuGoalieValue:					; called from SetupPauseScreen
	lda.w #PmenuValueItems>>16		;goalie mode item numbers per list
	sta.b a3+2
	lda.w #PmenuValueItems+12
	sta.b a3
	lda.w pmenulist					;list
	asl a							;x2
	clc
	adc.b a3
	sta.b a3						;entry
	lda.b [a3]						;goalie mode item
	cmp.b d0						;this item?
	beq .t2
	jmp.w PmenuRtl

.t2:								; [a3] = d0: call GetPadTeam, if goaliemode1,y = 0 go to .t1, ...
	jsl.l GetPadTeam				; a2 = the team of the controller that paused, from its side
	ldy.b a2						;team
	lda.w goaliemode1,y				;goalie control
	beq .t1							;off
	lda.w #GoalieOptionText>>16		;goalie mode text
	sta.b a4+2
	lda.w #GoalieOptionText+18
	sta.b a4
	bra .1

.t1:								; goaliemode1,y = 0: a4 = GoalieOptionText
	lda.w #GoalieOptionText>>16
	sta.b a4+2
	lda.w #GoalieOptionText			;other goalie mode text
	sta.b a4
.1:									; call PmenuAppend, return
	ldy.w #$0001					;from the second byte
	jsl.l PmenuAppend				;append it
	rtl
PmenuDefValue:						; called from SetupPauseScreen
	lda.w #PmenuValueItems>>16		;defence control item numbers per list
	sta.b a3+2
	lda.w #PmenuValueItems+24
	sta.b a3
	lda.w pmenulist					;list
	asl a							;x2
	clc
	adc.b a3
	sta.b a3						;entry
	lda.b [a3]						;defence item
	cmp.b d0						;this item?
	beq .t2
	jmp.w PmenuRtl

.t2:								; [a3] = d0: call GetPadTeam, if defcontrol,y = 0 go to .t1, ...
	jsl.l GetPadTeam				; a2 = the team of the controller that paused, from its side
	ldy.b a2						;team
	lda.w defcontrol,y				;defence control
	beq .t1							;off
	lda.w #GoalieOptionText>>16		;text for on
	sta.b a4+2
	lda.w #GoalieOptionText+39
	sta.b a4
	bra .1

.t1:								; defcontrol,y = 0: a4 = GoalieOptionText+43
	lda.w #GoalieOptionText>>16
	sta.b a4+2
	lda.w #GoalieOptionText+43		;text for off
	sta.b a4
.1:									; call PmenuAppend, return
	ldy.w #$0001					;from the second byte
	jsl.l PmenuAppend				;append it
	rtl
