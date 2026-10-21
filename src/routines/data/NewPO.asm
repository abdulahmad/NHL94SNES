; Start new playoffs and build the tree
;
; Takes OptTeam1 and OptPlayMode (2 = single games). Picks a random playoff tree that holds team 1, remembers
; its slot (potreeteam) and tree (postarts), clears the round and the series wins and builds the tree.
; Called from setoptions.
NewPO:								; start new playoffs with team 1 and build the tree
	jsl.l RandomWord				; random 0-31
	and.w #$001F					; tree number
	sta.b d0						; d0 = the tree number
.loop:								; next tree number
	lda.b d0						; next tree, wraps at 32
	inc a
	and.w #$001F					; 0-31
	sta.b d0
	asl a							; times 16 teams per tree
	asl a
	asl a
	asl a
	adc.w #playoffseats				; plus the seat table
	sta.b a0						; bank
	lda.w #playoffseats>>16			; bank of the table
	sta.b a0+2
	lda.w #$000F					; 16 teams
	sta.b d1
	lda.l OptTeam1					; team 1
	sta.b d2
	cmp.w #$001A					; team 26 or more?
	bcc .1
	lda.w #$0019					; use team 25
	sta.b d2
.1:									; find team 1 in this tree
	lda.b [a0]						; team of the seat
	inc.b a0						; next seat
	and.w #$00FF					; byte
	cmp.b d2						; our team?
	beq .t1							; found
	dec.b d1						; next seat
	bpl .1							; more
	bra .loop						; not in this tree: next tree

.t1:								; found: slot of team 1
	lda.b d1						; reverse the slot
	eor.w #$000F					; slot
	sta.b d1						; reverse
	sta.l potreeteam				; potreeteam
	lda.b d0						; the tree number
	sta.l postarts					; postarts
	lda.w #$0000					; first round
	sta.l playoffRoundIdx
	lda.w #$0007					; bosgames 7: single games
	sta.w bosgames
	lda.l OptPlayMode				; play mode 2?
	cmp.w #$0002
	beq .1x							; yes: build the tree
	stz.w bosgames					; best of seven: clear the series
	lda.w #$0007					; 8 series
	sta.b d0
	ldx.w #$0000
	txa
.loopx:								; clear the series wins
	sta.l gspotwins,x
	sta.l gspobwins,x
	inx								; next series
	inx
	dec.b d0						; count down
	bpl .loopx
.1x:								; build the tree
	jml.l maketree					; build the playoff tree from the seeds and the series wins
