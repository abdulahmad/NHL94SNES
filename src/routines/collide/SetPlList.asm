; Make the list of the players team a2 wants on the ice now
SetPlList:
	lda.w #PlList>>16
	sta.b a4+2
	lda.w #PlList
	sta.b a4
	lda.w #$0000
	sta.b [a4]
	ldy.w #$0002
	sta.b [a4],y
	ldy.w #$0004
	sta.b [a4],y
	lda.w #priolist>>16
	sta.b a0+2
	lda.w #priolist
	sta.b a0
	lda.w penshot
	beq .t1
	lda.w #priolist>>16
	sta.b a0+2
	lda.w #priolist+7
	sta.b a0
	lda.b a2
	cmp.w BA_Team
	bne .1
	inc.b a0
	bra .1

.t1:
	ldy.b a2
	lda.w tmgoalie,y
	bpl .1
	inc.b a0
.1:
	lda.b a3+2
	pha
	lda.b a3
	pha
	jsl.l GetTeamLines
	lda.b a3+2
	sta.b a1+2
	lda.b a3
	sta.b a1
	pla
	sta.b a3
	pla
	sta.b a3+2
	ldy.b a2
	lda.w tmline,y
	asl a
	asl a
	asl a
	sta.b d0
	adc.b a1
	sta.b a1
	lda.w tmap,y
	sta.b d4
	bra .7
.3:
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	sta.b d5
	tay
	sep #$20
	lda.b [a1],y
	ldy.b d4
	sta.b [a4],y
	lda.b d5
	beq .1x
	lda.w penshot
	beq .1x
	lda.w BA_Skater_Offset
	inc a
	sta.b [a4],y
.1x:
	iny
	iny
	iny
	iny
	iny
	iny
	lda.b d5
	sta.b [a4],y
	rep #$20
	lda.b d5
	bne .7
	ldy.b a2
	lda.w tmgoalie,y
	inc a
	sta.b d3
	bne .2
	lda.w penshot
	beq .2
	inc.b d3
.2:
	ldy.b d4
	sep #$20
	lda.b d3
	sta.b [a4],y
	rep #$20
.7:
	dec.b d4
	bpl .3
	lda.w #$0005
	sta.b d4
.4:
	ldy.b d4
	lda.b [a4],y
	and.w #$00FF
	sta.b d3
	bne .t1x
	jmp.w .5

.t1x:
	and.w #$00FF
	bit.w #$0080
	beq .1xx
	ora.w #$FF00
.1xx:
	dec a
	asl a
	sta.b d3
	lda.b a2
	beq .2x
	lda.w #$0034
.2x:
	clc
	adc.b d3
	tay
	lda.w tmpdst,y
	cmp.w #$FFFD
	beq .3x
	cmp.w #$FFFC
	beq .3x
	lda.w tmpdst,y
	bmi .5
	beq .5
.3x:
	lda.b a3+2
	pha
	lda.b a3
	pha
	jsl.l GetTeamLines
	lda.b a3+2
	sta.b a1+2
	lda.b a3
	sta.b a1
	pla
	sta.b a3
	pla
	sta.b a3+2
	lda.b d4
	clc
	adc.w #$0006
	tay
	lda.b [a4],y
	and.w #$00FF
	asl a
	sta.b d0
	lda.w #sublist>>16
	sta.b a0+2
	lda.w #sublist
	sta.b a0
	ldy.b d0
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
.loop:
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .6
	ldy.b d0
	lda.b [a1],y
	and.w #$00FF
	sta.b d0
	jsl.l TryAddPlayerToList
	beq .loop
.5:
	dec.b d4
	bmi .t1xx
	jmp.w .4

.t1xx:
	rtl
.6:
	jsl.l GetPlayerCount
	lda.b d0
	sta.b d3
.loopx:
	lda.b d3
	sta.b d0
	dec.b d3
	bmi .5
	jsl.l TryAddPlayerToList
	beq .loopx
	bra .5
