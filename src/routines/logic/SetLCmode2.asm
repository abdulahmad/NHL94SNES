; Draw the line change box for team a2, one row per line it can change to
;
; Takes a2 = team. Erases and frames the box (setlccords gives its position and size), then prints one
; row per line choice: button letter, line name and energy bar, then the team name below.
; Called from SetLCmode, lineinput and puckfaceoff.
SetLCmode2:							; draw the line change box of team a2
	jsl.l setlccords				; d0/d1 = box size and position
	inc.b d0						; size plus one in each direction
	inc.b d1
	lda.l blankchar					; d2 = the blank tile
	sta.b d2
	lda.l fobox						; faceoff box on screen?
	bne .1							; yes: do not erase it
	jsl.l eraser					; erase the area with the blank tile
.1:									; place the box
	jsl.l setlccords				; position again (the eraser changed it)
	lda.w printy					; box y
	sec
	sbc.w #$000F					; compare with 15
	bmi .t1							; upper half of the screen: draw a plain box
	lda.w #$0001					; lower half of the screen: flag it in sflags3
	tsb.w sflags3					; sf3llcs, lower line change box on screen
	bra .4							; go frame it

.t1:								; upper half
	jsl.l box						; draw the box
	jsl.l setlccords				; position again
.4:									; frame the box
	jsl.l Framer					; draw the frame
	dec.w printy					; back up two rows
	dec.w printy
	inc.w printx					; one column right
	lda.w #$0002					; three rows (2 down to 0)
	sta.b d4						; d4 = row counter
	lda.w printx					; keep the starting column
	pha								; 1,s = the starting column
.loop:								; one row per pass
	lda.b 1,s						; reload the column from the stack
	sta.w printx
	lda.b d4						; d0 = choice (row number)
	sta.b d0
	jsl.l getlchoice				; d0 = line for that choice
	lda.b d0						; negative: no such line
	bmi .3							; skip the row
	ldy.b a2						; Y = team offset
	lda.w tmflags,y					; team flags
	bit.w #$0008					; box open (bit 3)?
	bne .1x							; yes: show every row
	lda.b d4						; closing: only the chosen row
	cmp.w tmlcchoice,y				; box being closed: only the chosen row
	bne .2							; not the chosen one: next row
	lda.w tmline,y					; the chosen line
	sta.b d0
.1x:								; print the button letter
	lda.w #mesarea>>16				; message area (long pointer)
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$0004					; string length 4
	sta.b [a1]
	phx
	ldx.b d4
	lda.l LineChangeButtons,x		; button letter for the row
	plx
	and.w #$00FF					; low byte
	ora.w #$2000					; text attribute $20
	ldy.w #$0002
	sta.b [a1],y
	jsl.l print						; print it
	lda.b d0						; save the line number
	pha
	lda.w #linelist>>16				; line names list
	sta.b a1+2
	lda.w #linelist
	sta.b a1
	jsl.l PrintStringFromList		; print the line name
	pla								; restore the line number
	sta.b d0
	jsl.l linebar					; draw its energy bar
.2:									; one row up
	dec.w printy
.3:									; next row
	dec.b d4						; previous choice
	bpl .loop						; until all three rows are done
	pla								; starting column
	clc
	adc.w #$0005					; plus 5 columns
	sta.w printx
	ldy.b a2						; Y = team offset
	lda.w HomeTeam,y				; probably only reads the home team word (result unused)
	lda.w #TeamList>>16				; team data bank
	sta.b a1+2
	lda.w tmdata,y					; team record pointer
	sta.b a1
	ldy.w #$0004					; offset of the team name in the record
	clc
	adc.b [a1],y					; plus that offset
	sta.b a1						; a1 = team name offset
	clc
	adc.b [a1]
	sta.b a1						; a1 = team name string
	jml.l print						; print it
