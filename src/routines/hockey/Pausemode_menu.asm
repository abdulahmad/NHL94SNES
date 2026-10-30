; Pick which pause menu is up, then read the pad and run the selected item.
Pausemode_menu:							; called from Intermission, Pausemode
	lda.w #$FFFF
	sta.l pausemenuon
	lda.w shootoutmode
	beq .t4
	lda.w pregamepause
	bne .t5
	bra .t6

.t4:								; shootoutmode = 0: if gsp = $0004 go to .t2, ...
	lda.w gsp
	cmp.w #$0004
	beq .t2
	lda.w pregamepause
	bne .t3
	bra .t1

.t1:								; call ChoosePauseMenu, go to .t7
	jsl.l ChoosePauseMenu			; use the longer pause menu when this side still has a timeout
	bra .t7

.t2:								; gsp = $0004: pmenucount = $000F, pmenulist = $0001, go to .t7
	lda.w #$000F
	sta.w pmenucount
	lda.w #$0001
	sta.w pmenulist
	bra .t7

.t3:								; pregamepause != 0: pmenucount = $0009, pmenulist = $0002, go to .t7
	lda.w #$0009
	sta.w pmenucount
	lda.w #$0002
	sta.w pmenulist
	bra .t7

.t5:								; pregamepause != 0: pmenucount = $0006, pmenulist = $0003, go to .t7
	lda.w #$0006
	sta.w pmenucount
	lda.w #$0003
	sta.w pmenulist
	bra .t7

.t6:								; pmenucount = $0006, pmenulist = $0004, go to .t7
	lda.w #$0006
	sta.w pmenucount
	lda.w #$0004
	sta.w pmenulist
	bra .t7

.t7:								; call SpriteFrameStart, call setvideo, call WaitFrame, ...
	jsl.l SpriteFrameStart
	jsl.l setvideo					; once per game frame: build the sprite table for the next vblank
	jsl.l WaitFrame
	jsl.l SpriteFrameEnd
	lda.w #$0002
	sta.w timestep
	lda.w #$FFFF
	sta.l colourbuf+$1DE
	sta.l colourbuf+$1FE
PauseMenuPoll:						; called from PauseCrowdLevel, PauseDefStore, PauseEditLines, PauseExit...
	jsl.l SetupPauseScreen						; draw the pause menu: five items of the current list from item psfirst
	jsl.l SelectPauseController		; pick the controller that owns the pause menu
	lda.b d3
	bit.w #$1000
	beq .t3
	jmp.w PauseResumeRtl

.t3:								; d3 bits $1000 clear: if d1 bit $8080 set go to .t7, ...
	lda.b d1
	bit.w #$8080
	bne .t7
	bit.w #$0400
	beq .t2
	inc.w psitem
	lda.w pmenucount
	cmp.w psitem
	beq .t1
	lda.w psitem
	sec
	sbc.w #$0005
	cmp.w psfirst
	bmi PauseMenuPoll
	inc.w psfirst
	bra PauseMenuPoll

.t1:								; pmenucount = psitem: decrement psitem, go to PauseMenuPoll
	dec.w psitem
	bra PauseMenuPoll

.t2:								; if zero go to .t7, ...
	bit.w #$0800
	beq .t7
	dec.w psitem
	lda.w psitem
	cmp.w psfirst
	bpl PauseMenuPoll
	dec.w psfirst
	bpl PauseMenuPoll
	stz.w psfirst
	stz.w psitem
	bra PauseMenuPoll

.t7:								; d0 = psitem * 2 * 2, if pmenulist = 0 go to .t1x, ...
	lda.w psitem
	asl a
	asl a
	sta.b d0
	tay
	lda.w pmenulist
	beq .t1x
	cmp.w #$0001
	beq .t3x
	cmp.w #$0002
	beq .t4
	cmp.w #$0003
	beq .t5
	cmp.w #$0004
	beq .t6
	bra .t2x

.t1x:								; pmenulist = 0: a0 = PauseMenuHandlers, go to .1
	lda.w #PauseMenuHandlers>>16
	sta.b a0+2
	lda.w #PauseMenuHandlers
	sta.b a0
	bra .1

.t2x:								; a0 = PauseMenuHandlers+64, go to .1
	lda.w #PauseMenuHandlers>>16
	sta.b a0+2
	lda.w #PauseMenuHandlers+64
	sta.b a0
	bra .1

.t3x:								; a0 = PauseMenuHandlers+132, go to .1
	lda.w #PauseMenuHandlers>>16
	sta.b a0+2
	lda.w #PauseMenuHandlers+132
	sta.b a0
	bra .1

.t4:								; a0 = PauseMenuHandlers+192, go to .1
	lda.w #PauseMenuHandlers>>16
	sta.b a0+2
	lda.w #PauseMenuHandlers+192
	sta.b a0
	bra .1

.t5:								; a0 = PauseMenuHandlers+228, go to .1
	lda.w #PauseMenuHandlers>>16
	sta.b a0+2
	lda.w #PauseMenuHandlers+228
	sta.b a0
	bra .1

.t6:								; a0 = PauseMenuHandlers+252
	lda.w #PauseMenuHandlers>>16
	sta.b a0+2
	lda.w #PauseMenuHandlers+252
	sta.b a0
.1:									; jmlvector+1 = [a0],y, Y + 1, jmlvector+2 = [a0],y, ...
	lda.b [a0],y
	sta.w jmlvector+1
	iny
	lda.b [a0],y
	sta.w jmlvector+2
	jml.l jmlvector
