; Random team pairs for the 8 other games ($7E3528 / $7E3538), none of them HomeTeam or VisTeam and no team
; twice (bit sets $B3 / d3)
InitializeGameStructures:
	lda.w #$FFFF
	sta.l gamenum
	stz.b d3
	stz.b d3+2
	lda.w HomeTeam
	sta.b d0
	jsr.w .2
	lda.w VisTeam
	sta.b d0
	jsr.w .2
	ldx.w #$0000
.loop:
	jsr.w .1
	lda.b d0
	sta.l gst1,x
	jsr.w .1
	lda.b d0
	sta.l gst2,x
	inx
	inx
	cpx.w #$0010
	bne .loop
	rtl
.1:
	lda.w #$001A
	sta.b d0
	jsl.l randomd0
	jsr.w .2
	lda.w teamtaken
	cmp.w #$0000
	bne .1
	rts
.2:
	stz.w teamtaken
	lda.b d0
	sec
	sbc.w #$0010
	bmi .t1
	jsr.w .t2
	lda.b d3+2
	bit.w teambit
	beq .1x
	inc.w teamtaken
.1x:
	ora.w teambit
	sta.b d3+2
	rts

.t1:
	lda.b d0
	and.w #$000F
	jsr.w .t2
	lda.b d3
	bit.w teambit
	beq .1xx
	inc.w teamtaken
.1xx:
	ora.w teambit
	sta.b d3
	rts

.t2:
	tay
	lda.w #$0001
.loopx:
	cpy.w #$0000
	beq .t1x
	asl a
	dey
	bra .loopx

.t1x:
	sta.w teambit
	rts
