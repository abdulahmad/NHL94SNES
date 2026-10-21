; Line editor: pick a player for the cursor slot from the list (attribute pages, up / down); A = the player,
; negative when cancelled
; Takes SelectedPlayerIdx = line, lineslots and linecursor = the slot to fill. Draws the pick screen and
; lists the defensemen (cursor in the last rows) or the forwards, 9 rows at a time (pickfirst, picktop,
; pickrows, listcount), starting at the player already in the slot. Returns A = chosen player
; (roster index), or $FFFF when start cancels. Left/right change the attribute column (DispAttribCtr).
;
; Called from EditLinesScreen.
SelectLinePlayer:					; pick a player for a line slot
	lda.b a1+2						;keep a1
	pha
	lda.b a1
	pha
	lda.w #SelectLinePlayerPos>>16
	sta.b a1+2
	lda.w #SelectLinePlayerPos
	sta.b a1
	jsl.l print						; print SelectLinePlayerPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l SpriteFrameStart
	lda.w #$0020					;32 columns
	sta.b d0
	lda.w #$000D					;13 rows
	sta.b d1
	lda.l blankchar					;of blanks
	sta.b d2
	jsl.l eraser					;clear the list area
	lda.w #PlayerListMap>>16
	sta.b p0+2
	lda.w #PlayerListMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				; unpack PlayerListMap
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	ldx.w #$0001					;column 1
	ldy.w #$0001					;row 1
	lda.l charofs2
	clc
	adc.w #$0C00					;palette 3
	jsl.l WaitFrame
	jsl.l PasteMap					; copy map [p0] into the map at [p1], column X, row Y
	jsl.l SendTextMapRows
	jsl.l SendTextMap2Rows
	jsl.l SpriteFrameEnd			;end the sprite frame
	jsl.l WaitFrame
	lda.w #$0007					;split at line 7
	sta.w irqline2					;second IRQ line
	lda.w lineslots					;slots of the line
	sec
	sbc.w linecursor				;minus the cursor slot
	cmp.w #$0003					;one of the last 3 (defense)?
	bpl .t1							;no: forwards
	jsl.l GetDefenseCount			; count the defensemen of the team
	lda.b d0
	sta.w listcount					;list length = defensemen
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.b d0
	sta.w pickfirst					;skip the goalies
	jsl.l GetForwardCount			; count the forwards of the team
	lda.w pickfirst
	clc
	adc.b d0						;and the forwards
	sta.w pickfirst					;first defenseman
	bra .3

.t1:								; forwards are listed
	jsl.l GetForwardCount			; count the forwards of the team
	lda.b d0
	sta.w listcount					;list length = forwards
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	lda.b d0
	sta.w pickfirst					;first forward follows the goalies
.3:									; first player of the list
	sta.w picktop
	lda.w #$0009					;9 rows at most
	cmp.w listcount					;list longer?
	beq .1
	bmi .1
	lda.w listcount					;fewer: show them all
.1:									; rows shown = min(9, listcount)
	sta.w pickrows
	lda.w SelectedPlayerIdx			;line number
	dec a							;from 0
	asl a
	asl a
	asl a							;8 bytes per line
	sta.b d0
	jsl.l GetTeamLines				;lines of team a2
	lda.b a3
	clc
	adc.b d0						;plus the line
	clc
	adc.w lineslots					;plus the slot
	sec
	sbc.w linecursor				;minus the cursor
	sta.b a3
	jsr.w ReadLineSlot				; returns A = the byte at [a3]
	sta.w curplayer					;player in the slot
	lda.w pickrows
	clc
	adc.w picktop
	sec
	sbc.w curplayer					;minus the player
	bpl .t1x						;visible: cursor on him
	lda.w curplayer
	sec
	sbc.w pickrows
	sec
	sbc.w picktop					;minus the top
	bmi .2							;above the list: top row
	clc
	adc.w picktop
	sta.w picktop					;scroll so he is visible
.2:									; cursor row 0
	lda.w #$0000					;top row
	bra .4

.t1x:								; cursor row from the top of the visible list
	lda.w picktop
	clc
	adc.w pickrows
	sec
	sbc.w curplayer
.4:									; set the cursor row
	sta.w curplayer
	jsl.l .10						;draw the list
.5:									; pick loop: send the text maps and read the pads
	jsl.l SendTextMap
	jsl.l SendTextMap2
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadPausePad				; ReadjoyA for the controller that owns the pause menu
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1						;new presses
	bit.w #$1000					;start?
	beq .t2							;no
	lda.w #$FFFF					;cancelled
	jmp.w SelectLinePlayerRtl		; jumped to from SelectLinePlayer

.t2:								;A, B or Y / X?
	bit.w #$8080
	beq .t1xx						;no: directions
	lda.w picktop
	clc
	adc.w pickrows					;plus the rows
	sec
	sbc.w curplayer					;minus the cursor row
	jmp.w SelectLinePlayerRtl		;return the chosen player

.t1xx:								; left / right / up / down
	stz.b d0						;d0 = +1
	inc.b d0
	bit.w #$0100					;right?
	bne .7
	dec.b d0
	dec.b d0						;d0 = -1
	bit.w #$0200					;left?
	bne .7
	bit.w #$0400					;up?
	bne .1x							;up: -1
	inc.b d0
	inc.b d0						;d0 = +1
	bit.w #$0800					;down?
	beq .6							;no direction
.1x:								; up / down: move the cursor row
	lda.b d0
	clc
	adc.w curplayer					;plus the cursor row
	bmi .8							;off the top: scroll
	cmp.w pickrows					;past the last row?
	bpl .9							;yes: scroll the other way
	sta.w curplayer					;new cursor row
	jsl.l .10						;redraw
.6:									; back to the pick loop
	jmp.w .5
.7:									; left / right: change the attribute column
	lda.b d0
	clc
	adc.w DispAttribCtr				;plus the column
	sta.b d0
	bmi .6							;before the first: ignore
	sta.w DispAttribCtr				;new column
	jsl.l .10						;redraw
	bra .6
.8:									; scroll the list down one row
	lda.w picktop
	sec
	sbc.w pickfirst					;minus the first player
	clc
	adc.w pickrows					;plus the rows
	cmp.w listcount					;at the end of the list?
	bpl .6							;yes: no scroll
	inc.w picktop					;scroll one
	jsl.l .10						;redraw
	lda.w #$FFFF
	sta.w BG3VScroll				;nudge the scroll for the redraw
	bra .6
.9:									; scroll the list up one row
	lda.w picktop
	cmp.w pickfirst					;at the first player?
	beq .6							;yes: no scroll
	dec.w picktop					;scroll one
	jsl.l .10						;redraw
	lda.w #$FFFF
	sta.w BG3VScroll
	lda.w #$FFFF
	sta.w BG1VScroll
	jmp.w .6
.10:								; redraw the column title and the player list
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #SelectLinePlayerPos2>>16
	sta.b a1+2
	lda.w #SelectLinePlayerPos2
	sta.b a1
	jsl.l print						; print SelectLinePlayerPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020					;32 columns
	sta.b d0
	lda.w #$000D					;13 rows
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser					;clear the list
	lda.w #$0011
	sta.w printx					;column 17
	lda.w #$0002
	sta.w printy					;row 2
.1xx:								; find the attribute entry of the current column
	lda.w #SkaterAttribColumns
	sta.b a1
	lda.w #SkaterAttribColumns>>16
	sta.b a1+2
	lda.w DispAttribCtr				;column to find
	sta.b d0
	lda.w SelectedPlayerIdx			;goalie line?
	bne .3x							;no: skater columns
	lda.w #AttribMenuGoalie			;goalie columns
	sta.b a1
	lda.w #AttribMenuGoalie>>16
	sta.b a1+2
	bra .3x
.2x:								; next entry of the menu
	lda.b a1
	clc
	adc.b [a1]						;plus this entry's length
	adc.w #$0004					;plus the 4-byte header
	sta.b a1
.3x:								; end of the menu?
	lda.b [a1]						;entry length
	bmi .1xxx						;end marker: stop
	dec.b d0						;count down the column
	bpl .2x							;not there yet
.1xxx:								; past the last column: wrap back
	lda.b [a1]						;ran off the end?
	bpl .t1xxx						;no: print it
	dec.w DispAttribCtr				;back one column
	bra .1xx						;find it again

.t1xxx:								; print the column title
	lda.w #$3800					;palette and priority
	sta.w printa
	jsl.l print						;print the column title
	lda.b [a1]
	sta.b d4+2						;field width
	ldy.w #$0002
org $9B9001
	lda.b [a1],y					;field offset
	sta.b d4						;attribute field
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayerTxt>>16
	sta.b a1+2
	lda.w #PlayerTxt
	sta.b a1
	jsl.l print						; print PlayerTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w picktop
	cmp.w pickfirst					;at the first player?
	beq .1xxxx						;yes: no left arrow
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #LeftArrowTxt>>16
	sta.b a1+2
	lda.w #LeftArrowTxt
	sta.b a1
	jsl.l print						; print LeftArrowTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
.1xxxx:								; right arrow when more players follow
	lda.w picktop
	sec
	sbc.w pickfirst					;minus the first player
	clc
	adc.w pickrows					;plus the rows
	cmp.w listcount					;more below?
	bpl .2xx						;no: no right arrow
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RightArrowTxt>>16
	sta.b a1+2
	lda.w #RightArrowTxt
	sta.b a1
	jsl.l print						; print RightArrowTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
.2xx:								; print the player list
	jsr.w PrintLinePlayerList		; line editor player list: each row a player name and the attribute
	rtl
