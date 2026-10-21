; Record the played playoff game and the series wins
;
; Takes gamenum, the scores in tmscore and bosgames (7 = single games, else best of seven). Stores the score,
; counts the series win and, when the round is over, collects the winners into WinBits and moves to the next
; round (playoffRoundIdx). Called from EncodePW.
ResolveGames:						; record the played playoff game and the series wins
	lda.l gamenum					; game number of the played game
	asl a
	sta.b d0
	stz.b a0
	tax
	lda.w tmscore					; copy the score of the played game
	sta.l gss1,x
	lda.w tmscore+2
	sta.l gss2,x
	jsl.l GetShifter				; d1 = games - 1
	lda.b d1						; number of series in the round - 1
	asl a
	sta.b a0
	lda.w bosgames					; best of seven round?
	cmp.w #$0007
	bne .4							; best of seven: count the wins
	jmp.w .9						; single games
.4:									; skip finished series (4 wins decide)
	ldx.b a0
	lda.w #$0004					; 4 wins decide a series
	cmp.l gspotwins,x
	beq .3							; series already decided?
	cmp.l gspobwins,x
	beq .3
	stz.b d3						; d3 = 0
	lda.l gsflags,x					; gsflags bit 0: teams swapped
	bit.w #$0001
	beq .1							; not swapped
	lda.w #$0010					; swapped: d3 = $10
	sta.b d3
.1:									; compare the scores
	lda.l gss1,x
	cmp.l gss2,x
	bpl .2							; first team ahead or equal
	lda.b d3
	eor.w #$0010					; flip the side of the win
	sta.b d3
.2:									; series offset plus the side: count the win
	lda.b a0
	clc
	adc.b d3
	tax
	lda.l gspotwins,x
	inc a
	sta.l gspotwins,x				; count the series win
.3:									; next series
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .4							; more series
	inc.w bosgames					; next game of the series
	lda.w bosgames
	cmp.w #$0007					; series finished?
	bne .t3
	jmp.w .7						; yes: next round

.t3:								; the played game's series
	lda.l gamenum
	asl a
	sta.b a0
	tax
	lda.w #$0004					; 4 wins?
	cmp.l gspotwins,x
	beq .t1
	cmp.l gspobwins,x
	beq .t1
	jmp.w .8						; series still open: done

.t1:								; finish the other series of the round
	lda.l playoffRoundIdx
	sec
	sbc.w #$0003					; before level 3?
	bmi .t2							; signed compare
	bvs .5
	bra .7							; next round

.t2:								; if overflow set go to .7
	bvs .7							; signed compare
.5:									; d1 = games - 1
	jsl.l GetShifter				; games of the round less one and its first win bit
	lda.b d1
	asl a
	sta.b a0
.6:									; series loop
	ldx.b a0
	lda.b d1
	cmp.l gamenum					; skip the played series
	beq .t1x
	lda.w #$0004					; 4 wins already?
	cmp.l gspotwins,x
	beq .t1x
	cmp.l gspobwins,x
	beq .t1x
	lda.l gspotwins,x				; play it out at random
	inc a
	sta.l gspotwins,x
	jsl.l RandomWord				; 50/50
	lsr a
	bcc .6							; first team wins this one
	lda.l gspotwins,x
	dec a
	sta.l gspotwins,x
	lda.l gspobwins,x				; count the loss for the other side
	inc a
	sta.l gspobwins,x
	bra .6

.t1x:								; next series
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .6
	jsl.l WritePassBits				; passbits before the rest was resolved
	ldx.w #$000E					; 8 words of passbits
.loop:								; copy the pass bits of the game
	lda.l passbits,x
	sta.l tpassbits,x
	dex
	dex
	bpl .loop
	lda.w #$0004					; sflags3 bit $0004: the saved passbits are used later
	tsb.w sflags3
.7:									; advance to the next round
	stz.w bosgames					; reset the game counter
	jsl.l GetShifter				; d1 = games - 1
	lda.b d1
	asl a
	sta.b a0
	stz.b d3
.loopx:								; series won by the second team?
	ldx.b a0
	lda.l gspotwins,x
	cmp.w #$0004					; first team has 4 wins: not marked
	beq .1x
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x			; mark the series the second team won
	tsb.b d3
.1x:								; reset the win counts for the next round
	lda.b a0
	lda.w #$0000
	sta.l gspotwins,x				; clear the win counts
	sta.l gspobwins,x
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .loopx
	lda.b d2						; WinBits: the winners of level d2
	asl a
	tax
	lda.l BitMaskTable,x			; mask of the level
	tax
	dec a							; mask - 1: clear the old bits
	and.w WinBits
	sta.w WinBits
	lda.b d3						; new winners
	jsl.l Mul16U					; shifted into place
	lda.b r2
	tsb.w WinBits					; merge the new winners
	lda.l playoffRoundIdx			; next round
	inc a
	sta.l playoffRoundIdx
.8:									; return
	rtl
.9:									; single games
	stz.b d3						; d3 = 0
.loopxx:							; compare the scores of the game
	ldx.b a0
	lda.l gss2,x					; visitor score
	cmp.l gss1,x
	bcc .1xx						; visitors behind: not marked
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x			; mark the series
	tsb.b d3
.1xx:								; teams swapped?
	ldx.b a0
	lda.l gsflags,x
	bit.w #$0001					; gsflags bit 0
	beq .2x
	lda.b d1
	asl a
	tax
	lda.l BitMaskTable,x
	eor.b d3						; invert the winner bit
	sta.b d3
.2x:								; previous game
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .loopxx
	lda.b d2						; WinBits of this level
	asl a
	tax
	lda.l BitMaskTable,x			; mask of the level
	tax
	dec a							; mask - 1: clear the old bits
	and.w WinBits
	sta.w WinBits
	lda.b d3						; new winners
	jsl.l Mul16U					; shifted into place
	lda.b r2
	tsb.w WinBits					; merge the new winners
	lda.l playoffRoundIdx			; next round
	inc a
	sta.l playoffRoundIdx
	rtl
