; Add to the attack zone time of the team with the puck past the blue line
chkatop:							; called from updatepentime
	stz.b d1						; team 0
	lda.w pucky						; puck y
	sec
	sbc.w #Blueline					; minus Blueline
	bpl .1
	inc.b d1						; team 1
	inc.b d1
	lda.w pucky						; puck y
	sec
	sbc.w #-Blueline				; minus -Blueline
	bpl .rtl
.1:									; if gmode bits gmdir clear go to .2, ...
	lda.w gmode						; gmdir: swap the teams
	bit.w #gmdir					; direction swapped?
	beq .2							; yes
	lda.b d1
	eor.w #$0002					; swap the teams
	sta.b d1
.2:									; tmATOP,y = tmATOP,y + 1
	ldy.b d1						; team
	lda.w tmATOP,y					; attack zone time
	inc a							; one more
	sta.w tmATOP,y
.rtl:								; return
	rtl
