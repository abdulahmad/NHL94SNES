; Player stats for the team in a2.
PlayerStatsScreen:					; called from PausePlayerStats
	jsl.l GetPauseTeam				; team of the pause controller
	lda.b a2
	pha
	ldx.b a2
	lda.w HomeTeam,x
	sta.l setupvis
	lda.w #$001D
	sta.l setuphome
	jsl.l SetupScreen				; common setup of the stats screens
	ldx.w #$0049
	ldy.w #$0018
	lda.w #PlayerStatsTitle>>16
	sta.b a1+2
	lda.w #PlayerStatsTitle
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites PlayerStatsTitle
	jsl.l SpriteFrameEnd
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayerStatsScreenPos>>16
	sta.b a1+2
	lda.w #PlayerStatsScreenPos
	sta.b a1
	jsl.l print						; print PlayerStatsScreenPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0800
	sta.w printa
	lda.w #$000E
	sta.b d0
	lda.w #$0003
	sta.b d1
	jsl.l FramerOutline
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #YSwitchTeamsTxt>>16
	sta.b a1+2
	lda.w #YSwitchTeamsTxt
	sta.b a1
	jsl.l print						; print YSwitchTeamsTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0001
	sta.w statcolumn
	jsl.l SetPlayerStatsRange		; set the row range of the player stats list
	lda.w #$0007
	sta.w listrows
	jsl.l InitStatsOrder			; statsorder[i] = i for the rows of the list
	jsl.l SortPlayerStats			; player stats: print the column name
	lda.w #$0058
	ldx.w #$00C0
	ldy.w #$00D0
	jsl.l SetupScrollIRQ			; set up the three-way scroll IRQ
	lda.w #$0018
	sta.w irqvscroll2
	lda.w #$0001
	sta.l playerstatson
	jsl.l SendTextMap
	jsl.l DrawPlayerStatsPage		; player stats
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
PlayerStatsScreen_loop:				; called from PlayerStatsScreen_down, PlayerStatsScreen_redraw...
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l getpzjoy					; ReadjoyA for the controller that owns the pause menu
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d3
	bit.w #$1000
	beq .t2
	jmp.w PlayerStatsScreen_exit

.t2:								; d3 bits $1000 clear: if zero go to .t1
	bit.w #$0800
	beq .t1
.1:									; go to PlayerStatsScreen_up
	jmp.w PlayerStatsScreen_up

.t1:								; if zero go to .t3, ...
	bit.w #$0400
	beq .t3
	jmp.w PlayerStatsScreen_down

.t3:								; if d1 bits $0200 clear go to .t1x
	lda.b d1
	bit.w #$0200
	beq .t1x
.1x:								; go to PlayerStatsScreen_left
	jmp.w PlayerStatsScreen_left

.t1x:								; d1 bits $0200 clear: if zero go to .t2x
	bit.w #$0100
	beq .t2x
.1xx:								; go to PlayerStatsScreen_right
	jmp.w PlayerStatsScreen_right

.t2x:								; if zero go to PlayerStatsScreen_redraw
	bit.w #$4000
	beq PlayerStatsScreen_redraw
.1x2:								; go to SwapPlayerStatsTeam
	jmp.w SwapPlayerStatsTeam		; switch player stats to the other team and redraw the heading

PlayerStatsScreen_redraw:			; called from PlayerStatsScreen_column, PlayerStatsScreen_down...
	lda.w statcolumn
	cmp.w #$0000
	beq .4
	lda.w curitem
	cmp.w listtop
	beq .1xxx
	lda.w #$0001
	sta.w printx
	lda.w curitem
	asl a
	sta.w printy
	lda.w #$2000
	sta.w printa
	lda.w #LineBraces>>16
	sta.b a1+2
	lda.w #LineBraces
	sta.b a1
	jsl.l PrintToStatsPage
.1xxx:								; if zero go to .3
	lda.w curitem
	clc
	adc.w listrows
	dec a
	cmp.w listend
	beq .3
.2:									; printx = $0001, printy = curitem + listrows - 1 * 2, printa = $2000, ...
	lda.w #$0001
	sta.w printx
	lda.w curitem
	clc
	adc.w listrows
	dec a
	asl a
	sta.w printy
	lda.w #$2000
	sta.w printa
	lda.w #LineBraces>>16
	sta.b a1+2
	lda.w #LineBraces+3
	sta.b a1
	jsl.l PrintToStatsPage
.3:									; call DrawPlayerStatsPage
	jsl.l DrawPlayerStatsPage		; player stats
.4:									; call WaitFrame, go to PlayerStatsScreen_loop
	jsl.l WaitFrame
	jmp.w PlayerStatsScreen_loop

PlayerStatsScreen_exit:				; called from PlayerStatsScreen_loop
	lda.w #$0000
	sta.l playerstatson
	pla
	sta.b a2
	rtl

PlayerStatsScreen_down:				; called from PlayerStatsScreen_loop
	jsl.l ClearPlayerStatBraces		; erase the braces around the visible player-stat rows
	lda.w curitem
	clc
	adc.w listrows
	dec a
	cmp.w listend
	bmi .t1x2
	jmp.w PlayerStatsScreen_redraw

.t1x2:								; increment listrows, call DrawPlayerStatsPage, decrement listrows, ...
	inc.w listrows
	jsl.l DrawPlayerStatsPage		; player stats
	dec.w listrows
	jsl.l WaitFrame
	inc.w curitem
	lda.w #$0001
	sta.w irqvscroll1
.loop:								; loop: call WaitFrame, increment irqvscroll1, increment irqvscroll1, ...
	jsl.l WaitFrame
	inc.w irqvscroll1
	inc.w irqvscroll1
	lda.w irqvscroll1
	cmp.w #$000D
	bne .loop
	jsl.l DrawPlayerStatsPage		; player stats
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	jmp.w PlayerStatsScreen_loop

PlayerStatsScreen_up:				; called from PlayerStatsScreen_loop
	jsl.l ClearPlayerStatBraces		; erase the braces around the visible player-stat rows
	lda.w curitem
	dec a
	cmp.w listtop
	bpl .t1x3
	jmp.w PlayerStatsScreen_redraw

.t1x3:								; curitem = A, increment listrows, call DrawPlayerStatsPage, ...
	sta.w curitem
	inc.w listrows
	jsl.l DrawPlayerStatsPage		; player stats
	dec.w listrows
	jsl.l WaitFrame
	lda.w #$000D
	sta.w irqvscroll1
.loopx:								; loop: call WaitFrame, decrement irqvscroll1, decrement irqvscroll1, ...
	jsl.l WaitFrame
	dec.w irqvscroll1
	dec.w irqvscroll1
	lda.w irqvscroll1
	cmp.w #$0001
	bne .loopx
	jsl.l DrawPlayerStatsPage		; player stats
	jsl.l WaitFrame
	lda.w #$FFFF
	sta.w irqvscroll1
	jmp.w PlayerStatsScreen_loop

PlayerStatsScreen_left:				; called from PlayerStatsScreen_loop
	lda.w statcolumn
	dec a
	bpl .t1x4
	jmp.w PlayerStatsScreen_redraw

.t1x4:								; a still >= 0: if zero go to PlayerStatsScreen_setrange, ...
	cmp.w #$0000
	beq PlayerStatsScreen_setrange
	bra PlayerStatsScreen_column

PlayerStatsScreen_right:			; called from PlayerStatsScreen_loop
	lda.w statcolumn
	cmp.w #$0005
	bmi .t1x5
	jmp.w PlayerStatsScreen_redraw

.t1x5:								; statcolumn - $0005 negative: increment a, if zero go to ShowPlayerSta...
	inc a
	cmp.w #$0001
	beq PlayerStatsScreen_setrange
PlayerStatsScreen_column:			; called from PlayerStatsScreen_left
	sta.w statcolumn
	jsl.l SortPlayerStats			; player stats: print the column name
	jsl.l DrawPlayerStatsPage		; player stats
	jmp.w PlayerStatsScreen_redraw
PlayerStatsScreen_setrange:			; called from PlayerStatsScreen_left, PlayerStatsScreen_right
	sta.w statcolumn
	jsl.l SetPlayerStatsRange		; set the row range of the player stats list
	jsl.l InitStatsOrder			; statsorder[i] = i for the rows of the list
	jsl.l SortPlayerStats			; player stats: print the column name
	jsl.l DrawPlayerStatsPage		; player stats
	jmp.w PlayerStatsScreen_redraw
