; Line editor player list: each row a player name and the attribute (GetNameandAttrib), the selected row
; highlighted
PrintLinePlayerList:				; called from SelectLinePlayer
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PrintLinePlayerListPos>>16
	sta.b a1+2
	lda.w #PrintLinePlayerListPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w SelectedPlayerIdx
	dec a
	asl a
	asl a
	asl a
	sta.b d0
	ldy.b a2
	lda.w picktop
	inc a
	sta.b a3
	lda.w #PositionNames
	sta.b a5
	lda.w #PositionNames>>16
	sta.b a5+2
	lda.w pickrows
	dec a
	sta.b d1
.loop:								; loop: printa = $3800, if not zero go to .1, ...
	lda.w #$3800
	sta.w printa
	lda.b d1
	sep #$20
	cmp.w curplayer
	rep #$20
	bne .1
	lda.w #$2000
	sta.w printa
.1:									; a5 = a1, a5+2 = a1+2, printx = $0002, ...
	lda.b a1
	sta.b a5
	lda.b a1+2
	sta.b a5+2
	lda.w #$0002
	sta.w printx
	lda.b a3
	and.w #$00FF
	dec a
	sta.b d0
	sta.b r1
	stz.b r2
	jsl.l GoalieCount
	lda.b r1
	cmp.b d0
	bpl .2
	lda.w #$0010
	sta.b r2
.2:									; d0 = r1, call GetNameandAttrib, increment a3, ...
	lda.b r1
	sta.b d0
	jsl.l GetNameandAttrib
	inc.b a3
	inc.w printy
	dec.b d1
	bpl .loop
	lda.w #$3800
	sta.w printa
	rts
