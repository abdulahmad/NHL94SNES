; Random team pairs for the 8 other games ($7E3528 / $7E3538), none of them HomeTeam or VisTeam and no team
; twice (bit sets $B3 / d3)
;
; Takes HomeTeam and VisTeam; fills gst1/gst2 for the 8 other games. Teams 0-25 are tracked as bits in d3 (low
; word for 0-15, d3+2 for 16-25). Called from FigureJoy.
InitializeGameStructures:			; build the other games of the day
	lda.w #$FFFF					; gamenum -1
	sta.l gamenum
	stz.b d3						; no teams taken
	stz.b d3+2
	lda.w HomeTeam					; mark the home team
	sta.b d0
	jsr.w .2						; mark it taken
	lda.w VisTeam					; mark the visiting team
	sta.b d0
	jsr.w .2						; mark it taken
	ldx.w #$0000					; first game
.loop:								; next game
	jsr.w .1						; pick the first team
	lda.b d0
	sta.l gst1,x
	jsr.w .1						; pick the second team
	lda.b d0
	sta.l gst2,x					; store the second team
	inx								; next game
	inx
	cpx.w #$0010					; 8 games done?
	bne .loop
	rtl								; done
.1:									; pick a random team not yet taken
	lda.w #$001A					; 26 teams
	sta.b d0
	jsl.l randomd0					; random team
	jsr.w .2						; mark it taken
	lda.w teamtaken					; already taken?
	cmp.w #$0000
	bne .1							; yes: pick again
	rts
.2:									; local routine: mark team d0 taken in d3 (teamtaken nonzero if it was)
	stz.w teamtaken					; not taken yet
	lda.b d0
	sec								; team 16 or more?
	sbc.w #$0010
	bmi .t1							; no: low word
	jsr.w .t2						; bit mask of the team
	lda.b d3+2
	bit.w teambit					; already marked?
	beq .1x
	inc.w teamtaken					; yes: teamtaken
.1x:								; not yet marked
	ora.w teambit					; mark it
	sta.b d3+2
	rts

.t1:								; team 0-15
	lda.b d0
	and.w #$000F					; team number
	jsr.w .t2						; bit mask of the team
	lda.b d3
	bit.w teambit					; already marked?
	beq .1xx
	inc.w teamtaken					; yes: teamtaken
.1xx:								; not yet marked
	ora.w teambit					; mark it
	sta.b d3
	rts

.t2:								; local routine: teambit = 1 shifted left by A
	tay								; shift count
	lda.w #$0001					; bit 0
.loopx:								; shift loop
	cpy.w #$0000
	beq .t1x						; count done
	asl a							; shift
	dey
	bra .loopx

.t1x:								; count done: store the mask
	sta.w teambit					; teambit
	rts
