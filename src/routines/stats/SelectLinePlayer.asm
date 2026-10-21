; Line editor: pick a player for the cursor slot from the list (attribute pages, up / down); A = the player,
; negative when cancelled
; Takes SelectedPlayerIdx = line, lineslots and linecursor = the slot to fill. Draws the pick screen and
; lists the defensemen (cursor in the last rows) or the forwards, 9 rows at a time (pickfirst, picktop,
; pickrows, listcount), starting at the player already in the slot. Returns A = chosen player
; (roster index), or $FFFF when start cancels. Left/right change the attribute column (DispAttribCtr).
;
; Called from EditLinesScreen.
SelectLinePlayer:					; pick a player for a line slot
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #SelectLinePlayerPos>>16
	sta.b a1+2
	lda.w #SelectLinePlayerPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l SpriteFrameStart
	lda.w #$0020
	sta.b d0
	lda.w #$000D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.w #PlayerListMap>>16
	sta.b p0+2
	lda.w #PlayerListMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	ldx.w #$0001
	ldy.w #$0001
	lda.l charofs2
	clc
	adc.w #$0C00
	jsl.l WaitFrame
	jsl.l PasteMap
	jsl.l SendTextMapRows
	jsl.l SendTextMap2Rows
	jsl.l SpriteFrameEnd
	jsl.l WaitFrame
	lda.w #$0007
	sta.w irqline2
	lda.w lineslots
	sec
	sbc.w linecursor
	cmp.w #$0003
	bpl .t1
	jsl.l GetDefenseCount
	lda.b d0
	sta.w listcount
	jsl.l GoalieCount
	lda.b d0
	sta.w pickfirst
	jsl.l GetForwardCount
	lda.w pickfirst
	clc
	adc.b d0
	sta.w pickfirst
	bra .3

.t1:								; forwards are listed
	jsl.l GetForwardCount
	lda.b d0
	sta.w listcount
	jsl.l GoalieCount
	lda.b d0
	sta.w pickfirst
.3:									; first player of the list
	sta.w picktop
	lda.w #$0009
	cmp.w listcount
	beq .1
	bmi .1
	lda.w listcount
.1:									; rows shown = min(9, listcount)
	sta.w pickrows
	lda.w SelectedPlayerIdx
	dec a
	asl a
	asl a
	asl a
	sta.b d0
	jsl.l GetTeamLines
	lda.b a3
	clc
	adc.b d0
	clc
	adc.w lineslots
	sec
	sbc.w linecursor
	sta.b a3
	jsr.w ReadLineSlot
	sta.w curplayer
	lda.w pickrows
	clc
	adc.w picktop
	sec
	sbc.w curplayer
	bpl .t1x
	lda.w curplayer
	sec
	sbc.w pickrows
	sec
	sbc.w picktop
	bmi .2
	clc
	adc.w picktop
	sta.w picktop
.2:									; cursor row 0
	lda.w #$0000
	bra .4

.t1x:								; cursor row from the top of the visible list
	lda.w picktop
	clc
	adc.w pickrows
	sec
	sbc.w curplayer
.4:									; set the cursor row
	sta.w curplayer
	jsl.l .10
.5:									; pick loop: send the text maps and read the pads
	jsl.l SendTextMap
	jsl.l SendTextMap2
	jsl.l WaitFrame
	jsl.l ReadPads
	jsl.l ReadPausePad
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	beq .t2
	lda.w #$FFFF
	jmp.w SelectLinePlayerRtl

.t2:								; not start
	bit.w #$8080
	beq .t1xx
	lda.w picktop
	clc
	adc.w pickrows
	sec
	sbc.w curplayer
	jmp.w SelectLinePlayerRtl

.t1xx:								; left / right / up / down
	stz.b d0
	inc.b d0
	bit.w #$0100
	bne .7
	dec.b d0
	dec.b d0
	bit.w #$0200
	bne .7
	bit.w #$0400
	bne .1x
	inc.b d0
	inc.b d0
	bit.w #$0800
	beq .6
.1x:								; up / down: move the cursor row
	lda.b d0
	clc
	adc.w curplayer
	bmi .8
	cmp.w pickrows
	bpl .9
	sta.w curplayer
	jsl.l .10
.6:									; back to the pick loop
	jmp.w .5
.7:									; left / right: change the attribute column
	lda.b d0
	clc
	adc.w DispAttribCtr
	sta.b d0
	bmi .6
	sta.w DispAttribCtr
	jsl.l .10
	bra .6
.8:									; scroll the list down one row
	lda.w picktop
	sec
	sbc.w pickfirst
	clc
	adc.w pickrows
	cmp.w listcount
	bpl .6
	inc.w picktop
	jsl.l .10
	lda.w #$FFFF
	sta.w BG3VScroll
	bra .6
.9:									; scroll the list up one row
	lda.w picktop
	cmp.w pickfirst
	beq .6
	dec.w picktop
	jsl.l .10
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
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$000D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.w #$0011
	sta.w printx
	lda.w #$0002
	sta.w printy
.1xx:								; find the attribute entry of the current column
	lda.w #SkaterAttribColumns
	sta.b a1
	lda.w #SkaterAttribColumns>>16
	sta.b a1+2
	lda.w DispAttribCtr
	sta.b d0
	lda.w SelectedPlayerIdx
	bne .3x
	lda.w #AttribMenuGoalie
	sta.b a1
	lda.w #AttribMenuGoalie>>16
	sta.b a1+2
	bra .3x
.2x:								; next entry of the menu
	lda.b a1
	clc
	adc.b [a1]
	adc.w #$0004
	sta.b a1
.3x:								; end of the menu?
	lda.b [a1]
	bmi .1xxx
	dec.b d0
	bpl .2x
.1xxx:								; past the last column: wrap back
	lda.b [a1]
	bpl .t1xxx
	dec.w DispAttribCtr
	bra .1xx

.t1xxx:								; print the column title
	lda.w #$3800
	sta.w printa
	jsl.l print
	lda.b [a1]
	sta.b d4+2
	ldy.w #$0002
org $9B9001
	lda.b [a1],y
	sta.b d4
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PlayerTxt>>16
	sta.b a1+2
	lda.w #PlayerTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w picktop
	cmp.w pickfirst
	beq .1xxxx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #LeftArrowTxt>>16
	sta.b a1+2
	lda.w #LeftArrowTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.1xxxx:								; right arrow when more players follow
	lda.w picktop
	sec
	sbc.w pickfirst
	clc
	adc.w pickrows
	cmp.w listcount
	bpl .2xx
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RightArrowTxt>>16
	sta.b a1+2
	lda.w #RightArrowTxt
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
.2xx:								; print the player list
	jsr.w PrintLinePlayerList
	rtl
