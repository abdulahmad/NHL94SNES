; Shootout shooters: the select-player list
ShooterSelectList:					; called from PickShooterRow
	jsl.l SpriteFrameStart			;start the sprite frame
	lda.b a1+2						;save a1
	pha
	lda.b a1
	pha
	lda.w #ShooterSelectListPos>>16	;header position
	sta.b a1+2
	lda.w #ShooterSelectListPos
	sta.b a1
	jsl.l print						;print the header position
	pla								;restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020					;$20 columns
	sta.b d0
	lda.w #$000D					;$D rows
	sta.b d1
	lda.l blankchar					;blank tile
	sta.b d2
	jsl.l eraser					;clear the list area
	lda.w #PlayerListMap>>16		;list frame map
	sta.b p0+2
	lda.w #PlayerListMap
	sta.b p0
	lda.w #unpackbuf>>16			;into the unpack buffer
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress				;unpack it
	lda.w #unpackbuf>>16			;from the unpack buffer
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #textmap2>>16				;into text map 2
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	ldx.w #$0001					;column 1
	ldy.w #$0001					;row 1
	lda.l charofs2					;tile base
	clc
	adc.w #$0C00					;tile base
	jsl.l PasteMap					;paste the list frame
	jsl.l SendTextMapRows			;send the rows
	jsl.l SendTextMap2Rows			;send the rows
	jsl.l SpriteFrameEnd			;end the sprite frame
	jsl.l WaitFrame					;wait for the frame
	lda.w #$0007					;line 7
	sta.w irqline2					;split line 7
	jsl.l GetPlayerCount			;count the players
	lda.b d0
	sta.w listcount					;players
	jsl.l GetGoalieCount			;count the goalies
	lda.w listcount					;players
	sec
	sbc.b d0						;minus the goalies
	sta.w listcount					;skaters
	lda.b d0						;goalies come first
	sta.w pickfirst					;first skater
	lda.b d0
	sta.w picktop					;first player shown
	lda.w #$0000					;bank 0
	sta.b a3+2
	lda.w #homeshooters				;home shooters
	sta.b a3
	lda.b a2						;which team?
	beq .list						;home team
	lda.w #$0000					;bank 0
	sta.b a3+2
	lda.w #awayshooters				;away shooters
	sta.b a3
.list:								;the slot's player
	lda.b a3						;shooter list
	clc
	adc.w curitem					;plus the cursor row
	sta.b a3						;slot of the cursor row
	lda.b [a3]						;slot byte
	and.w #$00FF					;roster number
	dec a							;0-based
	sta.w curplayer					;current player of the slot
	lda.w #$0008					;8 rows shown
	clc
	adc.w picktop					;plus the first shown
	sec
	sbc.w curplayer					;minus the player
	bpl .t1							;inside the first page
	lda.w curplayer					;the player
	sec
	sbc.w #$0008					;minus 8
	sec
	sbc.w picktop					;minus the first shown
	bmi .zero						;inside: no scroll
	clc
	adc.w picktop					;plus the first shown
	sta.w picktop					;start the page here
.zero:								;cursor on the top row
	lda.w #$0000					;cursor on row 0
	bra .1							;draw the list

.t1:								;the player is on the first page
	lda.w picktop					;first player shown
	clc
	adc.w #$0008					;plus 8
	sec								;minus the player
	sbc.w curplayer					;row of the player
.1:									;draw the list
	sta.w curplayer					;cursor row
	jsl.l PrintShooterList			;draw the list
.2:									;input loop
	jsl.l SendTextMap				;send the text maps
	jsl.l SendTextMap2				;send the text maps
	jsl.l WaitFrame					;wait for the frame
	jsl.l ReadPads					;read the pads
	jsl.l getpzjoy					;the pause pad
	jsl.l ProcessInputWithRepeat	;presses with repeat
	lda.b d1						;new presses
	bit.w #$1000					;start?
	bne .1x							;start: leave
	bit.w #$0800					;up?
	bne .t4							;up
	bit.w #$0400					;down?
	bne .t3							;down
	bit.w #$0100					;right?
	bne .t1x						;right: next page
	bit.w #$0200					;left?
	bne .t2							;left: previous page
	bit.w #$8080					;A or B?
	beq .2							;nothing: next frame
	jsl.l SetShooter				;A or B: set the shooter
.1x:								;leave the list
	lda.w #$0001					;background needed
	sta.l drawlinesback				;redraw the shooter screen background
	rtl								;done

.t1x:								;right: next rating page
	lda.w DispAttribCtr				;rating page
	inc a							;next page
	cmp.w #$0010					;16 pages
	bpl .2							;at the last page: stay
	sta.w DispAttribCtr				;next page
	jsl.l PrintShooterList			;redraw the list
	bra .2							;back to the loop

.t2:								;left: previous rating page
	lda.w DispAttribCtr				;rating page
	dec a							;previous page
	bmi .2							;at the first page: stay
	sta.w DispAttribCtr				;previous page
	jsl.l PrintShooterList			;redraw the list
	jmp.w .2						;back to the loop

.t3:								;down
	lda.w curplayer					;cursor row
	dec a							;one row down
	bmi .t5							;at the bottom row: scroll
	sta.w curplayer					;new cursor row
	jsl.l PrintShooterList			;redraw the list
	jmp.w .2						;back to the loop

.t4:								;up
	lda.w curplayer					;cursor row
	inc a							;one row up
	cmp.w #$0009					;past row 8?
	bpl .t6							;at the top row: scroll
	sta.w curplayer					;new cursor row
	jsl.l PrintShooterList			;redraw the list
	jmp.w .2						;back to the loop

.t5:								;down at the bottom row: scroll on
	lda.w picktop					;first player shown
	sec
	sbc.w pickfirst					;minus the first player
	clc
	adc.w #$0009					;plus 9 rows
	cmp.w listcount					;past the list?
	bmi .t1xx						;more players below?
	jmp.w .2						;at the end: stay

.t1xx:								;scroll on
	inc.w picktop					;scroll on one player
	jsl.l PrintShooterList			;redraw the list
	jmp.w .2						;back to the loop

.t6:								;up at the top row: scroll back
	lda.w picktop					;first player shown
	dec a							;one back
	cmp.w pickfirst					;before the first?
	bpl .t1x2						;room to scroll back?
	jmp.w .2						;at the first: stay

.t1x2:								;scroll back
	dec.w picktop					;scroll back one player
	jsl.l PrintShooterList			;redraw the list
org $80D001
	jmp.w .2						;back to the loop
