; End of a period: the winners celebrate, and the clock moves on
;
; From the third period on, the six skaters of the team ahead get assignment 8 (the winners celebrate). After
; a clinched final in a playoff play mode all players get assignment 9 and bit 3 of pflags is
; cleared.
; Called from clockcont and puckfaceoff.
clockcont_0:						; period over: end of period scene, then the period or game over message
	ldx.w #$001C					; object at offset $1C
	stx.b a3
	lda.w #$0018					; assignment $18
	sta.b d0
	jsl.l assinsert					; give it to that object
	lda.w #$0001					; stream sound effect 1
	jsl.l StreamSfx
	stz.b p0						; p0 = 0: no cup scene
	lda.w gsp						; period (0 based)
	cmp.w #$0002					; third period or later?
	bcs .t1
	jmp.w .8						; first or second period: no celebration

.t1:								; third period or overtime: celebrate with assignment 8
	lda.w #$0008
	sta.b d0
	ldx.w #$0000					; start with team 0 players
	stx.b a3
	lda.l playoffRoundIdx			; playoff round
	cmp.w #$0003					; round 3 = the final
	bne .4							; not the final: only the winners celebrate
	lda.w bosgames					; games in the series
	cmp.w #$0007					; 7: counts as clinched
	beq .3
	lda.l gamenum					; this game's index
	asl a							; times 2 for the word tables
	sta.b a0
	tax
	stz.b d3						; d3 = 0: team 0 side of the wins tables
	lda.l gsflags,x					; game flags
	bit.w #$0001					; team flag set?
	beq .1
	lda.w #$0010					; yes: the other side's wins, $10 on
	sta.b d3
.1:									; compare the scores
	lda.w tmscore					; home score
	cmp.w tmscore+2					; home won?
	bpl .2							; home ahead or level
	lda.b d3						; visitors ahead: flip the side
	eor.w #$0010
	sta.b d3
.2:									; A = game offset + side
	lda.b a0						; game offset
	clc
	adc.b d3						; plus the side
	phx
	tax								; X = index (team offset kept on the stack)
	lda.l gspotwins,x				; series wins of that side
	plx
	cmp.w #$0003					; clinched when it reads 3
	bne .4
.3:									; cup scene (if not regular season)
	lda.l OptPlayMode				; play mode
	cmp.w #$0000
	beq .4							; play mode 0: no cup scene
	inc.b p0						; p0 = 1: also show the extra message
	lda.w #$0009					; all players get assignment 9
	sta.b d0
	lda.w #$000B					; 12 players
	sta.b d2
.loop:								; for each of the 12 players
	lda.w pflags,x
	and.w #$FFF7					; clear bit 3 of pflags (the pad flag)
	sta.w pflags,x
	inx
	inx
	dec.b d2						; next player
	bpl .loop
	ldx.w #$0000					; back to team 0
	stx.b a3
.4:									; pick the winners
	lda.w #$0005					; six players
	sta.b d2
	lda.w tmscore					; compare scores
	cmp.w tmscore+2					; equal
	beq .8							; tied: game over path
	bpl .5							; home ahead: team 0 players
	ldx.w #$000C					; visitors ahead: their players at offset $0C
	stx.b a3
.5:									; for each of the six
	lda.w position,x				; player's position
	beq .6							; no player: skip
	bmi .6							; off ice (negative): skip
	jsl.l assinsert					; give the assignment
	lda.w #$0008					; the rest get assignment 8
	sta.b d0
.6:									; next
	inx								; next word
	inx
	stx.b a3
	dec.b d2						; count down
	bpl .5							; until d2 goes negative
.7:									; game over
	jsl.l ClearPenaltyBuffer		; remove all penalties
	lda.l Crowdlevel				; crowd level
	clc
	adc.w #$03E8					; plus 1000
	sta.l Crowdlevel
	lda.w #$003C					; crowd holds for 60 frames
	sta.b crowdhold
	lda.w #$0040					; game clock stopped
	sta.w gmclock
	tsb.w gmode						; set the same value in the game mode
	lda.w tmscore					; compare scores
	cmp.w tmscore+2
	bmi .1x							; visitors won: keep the level
	lda.w #$0000					; home did not lose: quiet the crowd then cheer
	sta.l Crowdlevel
	lda.w #$0003					; cheer 3 times
	sta.w cheercnt
	lda.b vcount					; first cheer 150 frames ago
	sec
	sbc.w #$0096					; minus 150
	sta.w cheervc
.1x:								; show the end of game penalty message
	lda.w #PenEOG					; end of game message
	sta.b d0
	jsl.l AddPenalty2				; queue it
	lda.b p0						; cup scene?
	beq .rtl						; no: done
	lda.w #PenNoText3				; extra message
	sta.b d0
	jsl.l AddPenalty2				; queue it
.rtl:								; done
	rtl
.8:									; tied in regulation or before the third period
	lda.w gsp						; period
	cmp.w #$0003					; overtime?
	bne .1xx
	lda.l OptPlayMode				; play mode 0: game over
	beq .7
.1xx:								; end any penalty shot, then ShootoutWonBy
	jsl.l EndPenaltyShot
	lda.w #$0002					; d0 = 2
	sta.b d0
	jml.l ShootoutWonBy				; continue in ShootoutWonBy
