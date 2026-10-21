; Shootout shooters: the shooters' names
PrintShooterNames:					;print the goalie and shooter rows, the row at the cursor (curitem) in
									;another palette
	lda.b a1+2						;save a1
	pha
	lda.b a1						;save a1
	pha
	lda.w #PrintShooterNamesPos>>16	;header position
	sta.b a1+2
	lda.w #PrintShooterNamesPos
	sta.b a1
	jsl.l print						;print the header position
	pla								;restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020					;$20 columns
	sta.b d0						;$20 columns
	lda.w #$0013					;$13 rows
	sta.b d1						;$13 rows
	lda.l blankchar					;blank tile
	sta.b d2						;blank tile
	jsl.l eraser					;clear the list area
	lda.b a1+2						;save a1
	pha
	lda.b a1
	pha
	lda.w #PrintShooterNamesPos2>>16	;second header position
	sta.b a1+2
	lda.w #PrintShooterNamesPos2
	sta.b a1
	jsl.l print						;print the second header
	pla								;restore a1
	sta.b a1
	pla
	sta.b a1+2
	jsl.l GoalieCount				;count the goalies
	lda.b d0						;goalie count
	dec a							;minus 1
	sta.b d1						;rows - 1
	lda.w #.7>>16					;G slot text
	sta.b a5+2
	lda.w #.7						;G slot text
	sta.b a5
	lda.w #.6>>16					;default shooter list
	sta.b a3+2
	lda.w #.6						;default shooter list
	sta.b a3
	lda.w SelectedPlayerIdx			;picked row
	dec a							;0-based
	sta.b d0						;picked row - 1
	bmi .2							;no row picked: default list
	asl a							;times 8
	asl a
	asl a
	sta.b d0						;8 bytes per entry
	lda.w #homeshooters>>16			;home shooters
	sta.b a3+2
	lda.w #homeshooters				;home shooters
	sta.b a3
	lda.b a2						;which team?
	beq .1							;home team
	lda.w #awayshooters>>16			;away shooters
	sta.b a3+2
	lda.w #awayshooters				;away shooters
	sta.b a3
.1:									;a row is picked: numbered slot text
	lda.w #.8>>16					;slot text with the numbers
	sta.b a5+2
	lda.w #.8						;slot text with the numbers
	sta.b a5
	lda.w #$0005					;6 rows
	sta.b d1						;6 rows
.2:									;each row
	lda.w #$3800					;palette $3800
	sta.w printa					;normal palette
	lda.w #$0005					;5 minus the rows left
	sec
	sbc.b d1						;row number 0-5
	cmp.w curitem					;cursor row?
	bne .5							;not the cursor row
	lda.w #$2000					;palette for the cursor row
	sta.w printa					;cursor row: palette $2000
	lda.b [a3]						;player of this slot
	and.w #$00FF					;slot byte
	dec a							;roster index
	sta.l matchuphome				;matchuphome = that player
	phx								;save x
	ldx.b a2						;team offset
	lda.w HomeTeam,x				;the team
	cmp.w #$0018					;team $18 or above?
	bcc .4							;teams below $18 keep their picture
.3:									;free the old picture
	ldx.w #$0000					;x 0
	lda.l matchuphome
	lda.b p1+2
	sta.b p0+2						;frame to free
	lda.b p1
	sta.b p0						;frame to free
	jsl.l FreeFrameTiles			;free its tiles
.4:									;picture done
	plx								;restore x
.5:									;print the row
	lda.w #$0005					;slot column
	sta.w printx					;slot column
	lda.b a5+2						;slot text
	sta.b a1+2
	lda.b a5						;slot text
	sta.b a1
	jsl.l print						;print the slot text
	lda.b a1+2
	sta.b a5+2						;keep the slot text pointer
	lda.b a1
	sta.b a5						;keep the slot text pointer
	lda.w #$0008
	sta.w printx					;name column
	lda.b [a3]						;player of this slot
	and.w #$00FF					;slot byte
	dec a							;roster index
	sta.b d0
	jsl.l PlayerNumName				;number and name
	jsl.l print						;print it
	inc.b a3						;next slot
	inc.w printy
	inc.w printy					;two text rows down
	dec.b d1						;one row less
	bmi .t1							;past the last row?
	jmp.w .2						;next row

.t1:								;all 6 rows printed
	jsl.l ShootersBackground		;the background, title and team block
	rtl
.6:									;default shooter list: slots 1-4
	db $01,$02,$03,$04
.7:									;slot text when no row is picked: "G" on every row
	db $03,$00,$47,$03,$00,$47,$03,$00,$47,$03,$00,$47
.8:									;shooter slot text: "G", then "1"-"5"
	db $03,$00,$47,$03,$00,$31,$03,$00,$32,$03,$00,$33,$03,$00,$34,$03,$00,$35
