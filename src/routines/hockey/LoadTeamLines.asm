; Copy team a2's lines from its team data into its RAM lines (GetTeamLines)
LoadTeamLines:						; copy team a2's lines from the team data into RAM
; Takes a2 = team. Called from setoptions, SaveRegsStartHL2, EditLinesMenu and StartGame.
	lda.b a3+2						; save a3, a1, d0 and y
	pha
	lda.b a3
	pha
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.b d0
	pha
	phy
	jsl.l GetTeamLines				; a3 = RAM lines of team a2
	ldy.b a2						; a1 = the lines in the team data (offset word at +6 of the record)
	lda.w #TeamList>>16
	sta.b a1+2
	lda.w tmdata,y
	sta.b a1
	ldy.w #$0006					; add that offset
	clc
	adc.b [a1],y
	sta.b a1
	lda.w #$0000
	sta.b d0
.loop:								; copy $38 bytes
	sep #$20
	lda.b [a1]
	sta.b [a3]
	rep #$20
	inc.b a1
	inc.b a3
	lda.b d0
	inc a
	sta.b d0
	cmp.w #$0038
	bmi .loop
	lda.l OptLine					; OptLine nonzero: done, else copy 8 more bytes from the offset at +$C
	bne .1
	jsl.l GetTeamLines				; a3 = the RAM lines of team a2
	ldy.b a2
	lda.w #TeamList>>16
	sta.b a1+2
	lda.w tmdata,y
	sta.b a1
	ldy.w #$000C
	clc
	adc.b [a1],y
	sta.b a1
	lda.w #$0000
	sta.b d0
.loop2:								; copy 8 bytes
	sep #$20
	lda.b [a1]
	sta.b [a3]
	rep #$20
	inc.b a1
	inc.b a3
	lda.b d0
	inc a
	sta.b d0
	cmp.w #$0008
	bmi .loop2
.1:									; restore the registers
	ply
	pla
	sta.b d0
	pla
	sta.b a1
	pla
	sta.b a1+2
	pla
	sta.b a3
	pla
	sta.b a3+2
	rtl
