; The computer team picks a line by the man advantage, the score and the line energies
CompLine:							; a2 = team to change, a1 = other team; sets tmline of a2
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.w #$0003					; default line 3
	sta.b d0
	ldy.b a2						; power play times of both teams
	lda.w tmap,y
	ldy.b a1
	cmp.w tmap,y					; compare with the other team
	beq .4							; equal: no power play
	bpl .1							; sign of the difference
	inc.b d0						; line 5 on the other side
	inc.b d0
.1:									; call getlinee, d1 = d0, d0 = 1,s + 1, ...
	lda.b d0
	pha								; 1,s = the saved d0
	jsl.l getlinee					; energy of that line
	lda.b d0
	sta.b d1						; d1 = its energy
	lda.b 1,s
	inc a
	sta.b d0
	jsl.l getlinee					; energy of the next line
	lda.b d1
	sec
	sbc.b d0
	bpl .2
	pla
	inc a							; line + 1
	pha
.2:									; tmline,y = pulled value
	pla
	ldy.b a2
	sta.w tmline,y					; store the chosen line
.3:									; a0+2 = pulled value, a0 = pulled value, d2+2 = pulled value, ...
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	rtl
.4:									; a1 = tmap,y: if a2 = 0 go to .t2, ...
	ldy.b a2
	beq .t2
	jmp.w .6

.t2:								; a2 = 0: with OptLine 2 and c1playernum >= 0, use .6 below
	lda.l OptLine
	cmp.w #$0002
	bne .t1
	lda.w c1playernum,y
	bmi .t1
	jmp.w .6

.t1:								; same men on ice: choose from the line table by period and score
	lda.w #$0002
	sta.b d1
	lda.w #.5>>16
	sta.b a0+2
	lda.w #.5
	sta.b a0
	lda.w gsp						; third period?
	cmp.w #$0002
	bne .1x
	lda.w tmscore,y					; score
	ldy.b a1
	cmp.w tmscore,y					; against the other score
	beq .1x							; tied: use the tied table
	php
	lda.w #.5>>16
	sta.b a0+2
	lda.w #.5+14
	sta.b a0
	plp
	bpl .1x
	lda.w #.5>>16
	sta.b a0+2
	lda.w #.5+28
	sta.b a0
.1x:								; d1 = tmline,y * 2, d0 = [a0],y, call getlinee, ...
	ldy.b a1
	lda.w tmline,y					; current line
	asl a							; table index
	sta.b d1
	tay
	lda.b [a0],y					; table entry: next line
	sta.b d0
	jsl.l getlinee					; energy of that line
	lda.b d0
	cmp.w #$0C01					; enough energy?
	bcc .6
	ldy.b d1
	lda.b [a0],y					; take the table entry
	ldy.b a2
	sta.w tmline,y					; store it as the line
	jmp.w .3
.5:									; dw 0,1,2,0,1,0,1, dw 2,0,1,2,0,2,0, dw 0,1,0,0,1,0,1
	dw 0,1,2,0,1,0,1
	dw 2,0,1,2,0,2,0
	dw 0,1,0,0,1,0,1
.6:									; d1 = $0002, a0 = long .7, ...
	lda.w #$0002
	sta.b d1
	lda.w #.7>>16
	sta.b a0+2
	lda.w #.7
	sta.b a0
	lda.w gsp						; third period?
	cmp.w #$0002
	bne .1xx
	ldy.b a2
	lda.w tmscore,y					; score
	ldy.b a1
	cmp.w tmscore,y					; against the other score
	beq .1xx						; tied: use the tied table
	php
	lda.w #.7>>16
	sta.b a0+2
	lda.w #.7+6
	sta.b a0
	plp
	bpl .1xx
	lda.w #.7>>16
	sta.b a0+2
	lda.w #.7+12
	sta.b a0
.1xx:								; loop: increment a0, increment a0, d0 = [a0], ...
	lda.b [a0]						; next line to try
	inc.b a0
	inc.b a0
	sta.b d0
	jsl.l getlinee					; energy of that line
	lda.b d0
	cmp.w #$0F34					; enough energy?
	bcs .2x
	dec.b d1						; else try the next line
	bpl .1xx
.2x:								; decrement a0, decrement a0, tmline,y = [a0], ...
	dec.b a0
	dec.b a0
	ldy.b a2
	lda.b [a0]						; chosen line
	sta.w tmline,y					; store it
	jmp.w .3
.7:									; dw 0,1,2,0,2,1,0,1,0
	dw 0,1,2,0,2,1,0,1,0
