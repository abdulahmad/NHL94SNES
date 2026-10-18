; Draw the current player card, including strengths and ratings.
DrawPlayerCard:
	jsl.l SpriteFrameStart
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawPlayerCardPos>>16
	sta.b a1+2
	lda.w #DrawPlayerCardPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$0014
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	ldy.b a2
	lda.w HomeTeam,y
	ldx.w #$00C8
	ldy.w #$0010
	jsl.l DrawLogoSprite
	ldy.b a2
	lda.w #$009C
	sta.b a3+2
	lda.w tmdata,y
	sta.b a3
	ldy.w #$000C
	clc
	adc.b [a3],y
	sta.b a3
	ldy.w curitem
	bne .t2
	jmp.w .5

.t2:
	lda.w curitem
	sec
	sbc.w #$0007
	bmi .t1
	sta.w curplayer
	bra .2

.t1:
	clc
	adc.w #$0006
	tay
	lda.w #$009D
	sta.b a1+2
	lda.w #.8
	sta.b a1
	lda.b [a1],y
	and.w #$00FF
	tay
	lda.b [a3],y
	and.w #$00FF
	dec a
	sta.w curplayer
.2:
	lda.w curplayer
	sta.b d0
	jsl.l PlayerNumName
	lda.b [a1]
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx
	lda.w #$000C
	sta.w printy
	jsl.l print
	jsl.l GoalieCount
	lda.w curplayer
	cmp.b d0
	bmi .t2x
	jmp.w .t4

.t2x:
	lda.w #RosterGroups>>16
	sta.b a1+2
	lda.w #RosterGroups+18
	sta.b a1
	lda.b [a1]
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx
	lda.w #$000D
	sta.w printy
	jsl.l print
	jsl.l FindGoalieStrengths
	ldx.w #$0038
	ldy.w #$007A
	lda.w #StrengthsLabel>>16
	sta.b a1+2
	lda.w #StrengthsLabel
	sta.b a1
	jsl.l PrintSmallLetterSprites
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames+178
	sta.b a1
	lda.w strengths
	sta.b d0
	bpl .t1x
.1:
	jmp.w .4

.t1x:
	jsl.l AdvanceStringPtr
	ldx.w #$0040
	ldy.w #$0084
	jsl.l PrintSmallLetterSprites
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames+178
	sta.b a1
	lda.w strengths+4
	sta.b d0
	bpl .t3
.1x:
	jmp.w .4

.t3:
	lda.w strengths+6
	cmp.w #$0050
	bpl .t1xx
	jmp.w .4

.t1xx:
	jsl.l AdvanceStringPtr
	ldx.w #$0040
	ldy.w #$008E
	jsl.l PrintSmallLetterSprites
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames+178
	sta.b a1
	lda.w strengths+8
	sta.b d0
	bpl .t2xx
.1x2:
	jmp.w .4

.t2xx:
	lda.w strengths+$A
	cmp.w #$0050
	bpl .t1xxx
.1xx:
	jmp.w .4

.t1xxx:
	jsl.l AdvanceStringPtr
	ldx.w #$0040
	ldy.w #$0098
	jsl.l PrintSmallLetterSprites
	jmp.w .4

.t4:
	jsl.l GoalieCount
	lda.b d0
	sta.b d1
	jsl.l GetForwardCount
	lda.b d0
	clc
	adc.b d1
	cmp.w curplayer
org $9DC002
	beq .t1x2
	bmi .t1x2
	lda.w #RosterGroups>>16
	sta.b a1+2
	lda.w #RosterGroups
	sta.b a1
	bra .3

.t1x2:
	lda.w #RosterGroups>>16
	sta.b a1+2
	lda.w #RosterGroups+9
	sta.b a1
.3:
	lda.b [a1]
	dec a
	dec a
	lsr a
	eor.w #$FFFF
	inc a
	clc
	adc.w #$0010
	sta.w printx
	lda.w #$000D
	sta.w printy
	jsl.l print
	jsl.l FindSkaterStrengths
	ldx.w #$0038
	ldy.w #$007A
	lda.w #StrengthsLabelB>>16
	sta.b a1+2
	lda.w #StrengthsLabelB
	sta.b a1
	jsl.l PrintSmallLetterSprites
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames
	sta.b a1
	lda.w strengths
	sta.b d0
	bmi .4
	jsl.l AdvanceStringPtr
	ldx.w #$0040
	ldy.w #$0084
	jsl.l PrintSmallLetterSprites
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames
	sta.b a1
	lda.w strengths+4
	sta.b d0
	bmi .4
	lda.w strengths+6
	cmp.w #$0050
	bmi .4
	jsl.l AdvanceStringPtr
	ldx.w #$0040
	ldy.w #$008E
	jsl.l PrintSmallLetterSprites
	lda.w #RatingNames>>16
	sta.b a1+2
	lda.w #RatingNames
	sta.b a1
	lda.w strengths+8
	sta.b d0
	bmi .4
	lda.w strengths+$A
	cmp.w #$0050
	bmi .4
	jsl.l AdvanceStringPtr
	ldx.w #$0040
	ldy.w #$0098
	jsl.l PrintSmallLetterSprites
.4:
	ldx.w #$0098
	ldy.w #$007A
	lda.w #OverallRating>>16
	sta.b a1+2
	lda.w #OverallRating
	sta.b a1
	jsl.l PrintSmallLetterSprites
	lda.w #$0001
	sta.b d1
	jsl.l GetPlayerRating
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap
	ldx.w #$00A0
	ldy.w #$0084
	jsl.l PrintSmallLetterSprites
	jmp.w .6
.5:
	ldx.w #$000D
	ldy.w #$0004
	jsl.l ClearPictureBox
	lda.w #$0001
	sta.l cardblock
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #DrawPlayerCardPos2>>16
	sta.b a1+2
	lda.w #DrawPlayerCardPos2
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	ldy.b a2
	lda.w HomeTeam,y
	sta.b d1
	jsl.l DrawTeamBlocks
	lda.w #$0000
	sta.l cardblock
	ldy.b a2
	lda.w #$009C
	sta.b a1+2
	lda.w tmdata,y
	sta.b a1
	ldy.w #$0004
	clc
	adc.b [a1],y
	sta.b a1
	clc
	adc.b [a1]
	sta.b a1
	clc
	adc.b [a1]
	sta.b a1
	lda.b [a1]
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
	jsl.l print
	lda.b [a1]
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
	jsl.l print
	lda.w #$0060
	sta.w printy
	ldx.w #$0080
	ldy.w #$0004
	jsl.l PrintLineSlotName
	lda.w printy
	clc
	adc.w #$0008
	sta.w printy
	ldx.w #$0040
	ldy.w #$0003
	jsl.l PrintLineSlotName
	ldx.w #$00C0
	ldy.w #$0005
	jsl.l PrintLineSlotName
	lda.w printy
	clc
	adc.w #$000E
	sta.w printy
	ldx.w #$0058
	ldy.w #$0001
	jsl.l PrintLineSlotName
	ldx.w #$00A8
	ldy.w #$0002
	jsl.l PrintLineSlotName
	lda.w printy
	clc
	adc.w #$000E
	sta.w printy
	ldx.w #$0080
	ldy.w #$0000
	jsl.l PrintLineSlotName
	ldx.w #$0066
	ldy.w #$0098
	lda.w #TeamRating>>16
	sta.b a1+2
	lda.w #TeamRating
	sta.b a1
	jsl.l PrintSmallLetterSprites
	jsl.l GetTeamRating
	lda.w #$0004
	sta.b d1
	jsl.l PushNumberWrap
	ldx.w #$0070
	ldy.w #$00A2
	jsl.l PrintSmallLetterSprites
.6:
	lda.w curitem
	beq .t1xxxx
	lda.w curplayer
	ldx.w #$000D
	ldy.w #$0004
	jsl.l DrawPlayerPicture
	lda.w #$007F
	sta.b p0+2
	lda.l homepicaddr
	sta.b p0
	lda.l picchars
	asl a
	asl a
	asl a
	asl a
	clc
	adc.w #$2000
	tay
	ldx.w #$0600
	jsl.l WaitFrame
	jsl.l DMAToVRAM
	lda.w #$007F
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
	jsl.l DMAToVRAM
	jsl.l SendTextMap
	lda.w #$007F
	sta.b p0+2
	lda.w #$7780
	sta.b p0
	lda.w #$0400
	sta.w MapVRAM
	ldx.w #$000C
	ldy.w #$0004
	jsl.l MapToVRAM
	bra .7

.t1xxxx:
	jsl.l SendTextMap2
.7:
	jsl.l SetCardTeamColours
	jsl.l WaitFrame
	jsl.l SpriteFrameEnd
	lda.w #$3568
	sta.l colourbuf
	jsl.l SendColours
	rtl
.8:
	db $00,$04,$03,$05,$01,$02
