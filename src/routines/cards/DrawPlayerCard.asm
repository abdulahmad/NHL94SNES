; Draw the current player card, including strengths and ratings.
; Takes: a2 = team, curitem = what the card shows (0 = the team card, 1-6 = a line slot, 7 and up = roster
; player curitem - 7). A player card shows the number and name, the position group, the strengths (up to
; three, from FindGoalieStrengths / FindSkaterStrengths) and the overall rating; the team card shows the
; team name, the six line slots and the team rating. Ends with the picture and the card colours.
DrawPlayerCard:						; draw the player card (or the team card)
	jsl.l SpriteFrameStart			; start the sprite frame
	lda.b a1+2						; save a1
	pha
	lda.b a1
	pha
	lda.w #DrawPlayerCardPos>>16	; a1 = card layout
	sta.b a1+2
	lda.w #DrawPlayerCardPos
	sta.b a1
	jsl.l print						; print the card frame
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020					; erase a 32 x 20 block
	sta.b d0
	lda.w #$0014
	sta.b d1
	lda.l blankchar					; with the blank character
	sta.b d2
	jsl.l eraser
	ldy.b a2						; team logo sprite
	lda.w HomeTeam,y
	ldx.w #$00C8
	ldy.w #$0010
	jsl.l DrawLogoSprite			; draw it
	ldy.b a2						; a3 = list of players of the team
	lda.w #$009C
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #$000C					; offset 12 in the team data
	clc
	adc.b [a3],y
	sta.b a3
	ldy.w curitem					; team card item?
	bne .t2							; player card
	jmp.w .5						; team card

.t2:								; player card: which player?
	lda.w curitem					; item 7 and up: roster player item - 7
	sec
	sbc.w #$0007
	bmi .t1							; items 1-6: a line slot
	sta.w curplayer					; player number in the roster
	bra .2							; on to the name

.t1:								; line slot: map the slot with the table at the end of the file
	clc
	adc.w #$0006
	tay
	lda.w #$009D					; bank of the slot table
	sta.b a1+2
	lda.w #.8
	sta.b a1
	lda.b [a1],y					; slot to roster index
	and.w #$00FF
	tay
	lda.b [a3],y					; roster index of the line slot
	and.w #$00FF
	dec a							; roster index - 1
	sta.w curplayer
.2:									; print the name and the position group
	lda.w curplayer					; current player
	sta.b d0
	jsl.l PlayerNumName				; number and name
	lda.b [a1]						; centre the name on column 16
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx
	lda.w #$000C					; row 12
	sta.w printy
	jsl.l print						; print them
	jsl.l GoalieCount				; number of goalies
	lda.w curplayer
	cmp.b d0						; goalie?
	bmi .t2x						; skater: .t4
	jmp.w .t4						; skater

.t2x:								; goalie: print the group name
	lda.w #RosterGroups>>16			; bank of RosterGroups
	sta.b a1+2
	lda.w #RosterGroups+18			; "Goalie" group name
	sta.b a1
	lda.b [a1]						; centre the name
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx
	lda.w #$000D					; row 13
	sta.w printy
	jsl.l print						; print it
	jsl.l FindGoalieStrengths		; find the goalie strengths
	ldx.w #$0038					; label sprite position
	ldy.w #$007A
	lda.w #StrengthsLabel>>16		; StrengthsLabel
	sta.b a1+2
	lda.w #StrengthsLabel
	sta.b a1
	jsl.l PrintSmallLetterSprites	; print the label
	lda.w #RatingNames>>16			; names of the ratings
	sta.b a1+2
	lda.w #RatingNames+178			; strength name 1
	sta.b a1
	lda.w strengths					; first strength
	sta.b d0
	bpl .t1x						; none: no strengths
.1:									; no more strengths
	jmp.w .4						; go print the overall rating

.t1x:								; print the strength 1 name
	jsl.l AdvanceStringPtr			; next name in the list
	ldx.w #$0040					; print it
	ldy.w #$0084
	jsl.l PrintSmallLetterSprites
	lda.w #RatingNames>>16			; names of the ratings
	sta.b a1+2
	lda.w #RatingNames+178
	sta.b a1
	lda.w strengths+4				; second strength
	sta.b d0
	bpl .t3							; none: stop
.1x:								; no more strengths
	jmp.w .4						; go print the overall rating

.t3:								; second strength value
	lda.w strengths+6
	cmp.w #$0050					; needs 80 or more
	bpl .t1xx
	jmp.w .4						; too low: stop

.t1xx:								; print the strength 2 name
	jsl.l AdvanceStringPtr			; next name in the list
	ldx.w #$0040
	ldy.w #$008E
	jsl.l PrintSmallLetterSprites	; print it
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames+178
	sta.b a1
	lda.w strengths+8				; third strength
	sta.b d0
	bpl .t2xx						; none: stop
.1x2:								; no more strengths
	jmp.w .4						; go print the overall rating

.t2xx:								; third strength value
	lda.w strengths+$A
	cmp.w #$0050					; needs 80 or more
	bpl .t1xxx
.1xx:								; too low: stop
	jmp.w .4

.t1xxx:								; print the strength 3 name
	jsl.l AdvanceStringPtr			; next name in the list
	ldx.w #$0040
	ldy.w #$0098
	jsl.l PrintSmallLetterSprites	; print it
	jmp.w .4						; go print the overall rating

.t4:								; skater: forward or defenseman?
	jsl.l GoalieCount				; number of goalies
	lda.b d0
	sta.b d1
	jsl.l GetForwardCount			; number of forwards
	lda.b d0
	clc								; goalies + forwards
	adc.b d1
	cmp.w curplayer					; current player within them?
org $9DC002
	beq .t1x2						; yes: forward group
	bmi .t1x2						; yes: forward group
	lda.w #RosterGroups>>16			; bank of RosterGroups
	sta.b a1+2
	lda.w #RosterGroups
	sta.b a1						; "Forward" group name
	bra .3							; print it

.t1x2:								; defenseman group name
	lda.w #RosterGroups>>16
	sta.b a1+2
	lda.w #RosterGroups+9
	sta.b a1
.3:									; centre the group name
	lda.b [a1]
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx					; row 13
	lda.w #$000D
	sta.w printy
	jsl.l print						; print it
	jsl.l FindSkaterStrengths		; find the skater strengths
	ldx.w #$0038					; label sprite position
	ldy.w #$007A
	lda.w #StrengthsLabelB>>16		; StrengthsLabelB
	sta.b a1+2
	lda.w #StrengthsLabelB
	sta.b a1
	jsl.l PrintSmallLetterSprites	; print the label
	lda.w #RatingNames>>16			; names of the ratings
	sta.b a1+2
	lda.w #RatingNames
	sta.b a1
	lda.w strengths					; first strength
	sta.b d0
	bmi .4							; none: stop
	jsl.l AdvanceStringPtr			; next name in the list
	ldx.w #$0040
	ldy.w #$0084
	jsl.l PrintSmallLetterSprites	; print it
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames
	sta.b a1
	lda.w strengths+4				; second strength
	sta.b d0
	bmi .4							; none: stop
	lda.w strengths+6				; second strength value
	cmp.w #$0050
	bmi .4							; needs 80 or more
	jsl.l AdvanceStringPtr			; next name in the list
	ldx.w #$0040
	ldy.w #$008E
	jsl.l PrintSmallLetterSprites	; print it
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames
	sta.b a1
	lda.w strengths+8				; third strength
	sta.b d0
	bmi .4							; none: stop
	lda.w strengths+$A
	cmp.w #$0050					; needs 80 or more
	bmi .4
	jsl.l AdvanceStringPtr			; next name in the list
	ldx.w #$0040
	ldy.w #$0098
	jsl.l PrintSmallLetterSprites	; print it
.4:									; print the overall rating
	ldx.w #$0098
	ldy.w #$007A
	lda.w #OverallRating>>16		; OverallRating label
	sta.b a1+2
	lda.w #OverallRating
	sta.b a1
	jsl.l PrintSmallLetterSprites	; print it
	lda.w #$0001					; rating column 1 (overall)
	sta.b d1
	jsl.l GetPlayerRating			; rating of the player
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap			; push the number, 4 wide
	ldx.w #$00A0
	ldy.w #$0084
	jsl.l PrintSmallLetterSprites	; print it
	jmp.w .6						; go to the picture
.5:									; team card
	ldx.w #$000D					; clear the picture box
	ldy.w #$0004
	jsl.l ClearPictureBox
	lda.w #$0001
	sta.l cardblock					; card block mode on
	lda.b a1+2						; save a1
	pha
	lda.b a1
	pha
	lda.w #DrawPlayerCardPos2>>16	; a1 = team card layout
	sta.b a1+2
	lda.w #DrawPlayerCardPos2
	sta.b a1
	jsl.l print						; print it
	pla								; restore a1
	sta.b a1
	pla
	sta.b a1+2
	ldy.b a2						; team number of the card team
	lda.w HomeTeam,y
	sta.b d1
	jsl.l DrawTeamBlocks			; draw the team blocks
	lda.w #$0000					; card block mode off
	sta.l cardblock
	ldy.b a2						; team data
	lda.w #$009C
	sta.b a1+2
	lda.w tmdata,y
	sta.b a1
	ldy.w #$0004					; offset 4: team name strings
	clc
	adc.b [a1],y					; city string
	sta.b a1
	clc
	adc.b [a1]						; nickname string
	sta.b a1
	clc
	adc.b [a1]
	sta.b a1
	lda.b [a1]						; centre the city
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx
	lda.w #$0007
	sta.w printy
	jsl.l print						; print it
	lda.b [a1]						; centre the nickname
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx
	lda.w #$0009
	sta.w printy
	jsl.l print						; print it
	lda.w #$0060					; line slots: y 96
	sta.w printy
	ldx.w #$0080					; centre forward slot
	ldy.w #$0004
	jsl.l PrintLineSlotName			; print its name
	lda.w printy					; next row
	clc
	adc.w #$0008
	sta.w printy
	ldx.w #$0040					; left wing slot
	ldy.w #$0003
	jsl.l PrintLineSlotName
	ldx.w #$00C0					; right wing slot
	ldy.w #$0005
	jsl.l PrintLineSlotName
	lda.w printy					; next row
	clc
	adc.w #$000E
	sta.w printy
	ldx.w #$0058					; left defenseman slot
	ldy.w #$0001
	jsl.l PrintLineSlotName
	ldx.w #$00A8					; right defenseman slot
	ldy.w #$0002
	jsl.l PrintLineSlotName
	lda.w printy					; next row
	clc
	adc.w #$000E
	sta.w printy
	ldx.w #$0080					; goalie slot
	ldy.w #$0000
	jsl.l PrintLineSlotName
	ldx.w #$0066					; team rating label
	ldy.w #$0098
	lda.w #TeamRating>>16
	sta.b a1+2
	lda.w #TeamRating
	sta.b a1
	jsl.l PrintSmallLetterSprites	; print the label
	jsl.l GetTeamRating				; team rating
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap			; push it, 4 wide
	ldx.w #$0070
	ldy.w #$00A2
	jsl.l PrintSmallLetterSprites	; print it
.6:									; the picture
	lda.w curitem					; team card?
	beq .t1xxxx						; yes: no picture
	lda.w curplayer
	ldx.w #$000D					; player picture
	ldy.w #$0004
	jsl.l DrawPlayerPicture			; draw it
	lda.w #$007F					; DMA the home picture
	sta.b p0+2
	lda.l homepicaddr
	sta.b p0
	lda.l picchars					; picchars * 16 bytes
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$2000
	tay
	ldx.w #$0600
	jsl.l WaitFrame					; wait for the frame
	jsl.l DMAToVRAM					; send to VRAM
	lda.w #$007F					; DMA the visitors picture
	sta.b p0+2
	lda.l vispicaddr
	sta.b p0
	lda.l picchars
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$2300
	tay
	ldx.w #$0600
	jsl.l DMAToVRAM					; send to VRAM
	jsl.l SendTextMap				; send the text map
	lda.w #$007F					; DMA the card to the map
	sta.b p0+2
	lda.w #$7780
	sta.b p0
	lda.w #$0400
	sta.w MapVRAM
	ldx.w #$000C
	ldy.w #$0004
	jsl.l MapToVRAM					; map it into VRAM
	bra .7							; done

.t1xxxx:							; team card: the text map without a picture
	jsl.l SendTextMap2				; send the text map
.7:									; set the colours
	jsl.l SetCardTeamColours		; card team colours
	jsl.l WaitFrame					; wait a frame
	jsl.l SpriteFrameEnd			; end the sprite frame
	lda.w #$3568					; card background colour
	sta.l colourbuf
	jsl.l SendColours				; send the colours
	rtl								; return
.8:									; slot to line table: the six line slot indexes
	db $00,$04,$03,$05,$01,$02
