; Players on the bench get some energy back
RestoreBenchEnergy:					; no input; adds energy to the benched players of both teams
	lda.l OptLine					; OptLine option set?
	beq .rtl						; no
	stz.b a2						; team 0
	jsl.l .1						; do team 0, then fall into .1 for team 2
	lda.w #$0002					; team 2
	sta.b a2
.1:									; one team: a2 = 0 or 2
	lda.w #$0032					; d0 = player offset, last to first
	sta.b d0
.loop:								; next player
	lda.b a2						; team 0?
	beq .2							; yes
	lda.w #$0034					; team 2 offset
.2:									; y = team offset + player offset
	clc
	adc.b d0
	tay								; y = index
	lda.w tmpdst,y					; tmpdst entry of the player
	cmp.w #$FFFE					; probably the benched marker?
	bne .3							; no
	lda.w tmpde,y					; energy
	clc
	adc.w #$000A					; plus 10
	sta.w tmpde,y
	sec
	sbc.w #$1000					; above the limit $1000?
	bmi .3							; no
	lda.w #$1000					; cap at $1000
	sta.w tmpde,y
.3:									; next player
	dec.b d0						; previous player
	dec.b d0
	bpl .loop						; more players
.rtl:								; done
	rtl
