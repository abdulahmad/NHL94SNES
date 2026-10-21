; Roster column: where the player is (ice, bench, injured) or his penalty time
; Takes d0 = player index, a2 = team offset. Looks up the status word in tmpdst: a negative word is a state
; (0 to 3, larger ones become 1) shown from StatusTextTbl, a positive one with bit 12 set is state 3,
; otherwise a penalty time printed with PushTime, followed by string 4 or 5 (bit 14 of the word).
;
; Called through attribjmp.
AttribStatus:						; print the player status or penalty time
	asl.b d0
	lda.b a2
	beq .1
	lda.w #$0034					; away team offset $34
.1:									; index into tmpdst
	adc.b d0
	tay								; index
	lda.w tmpdst,y					; tmpdst: negative = not of the status
	sta.b d0						; state
	bpl .5
	eor.w #$FFFF
	sta.b d0
	cmp.w #$0004
	bcc .4
.2:									; unknown state: show 1
	lda.w #$0001
	sta.b d0
	bra .4
.3:									; state 3
	lda.w #$0003					; injured
	sta.b d0
.4:									; print the string d0 of StatusTextTbl
	lda.w #StatusTextTbl>>16
	sta.b a1+2						; text list
	lda.w #StatusTextTbl
	sta.b a1
	jml.l PrintStringFromList		; prints a string from a list
.5:									; positive word: penalty time or state 3
	lda.b d0
	bit.w #$1000
	bne .3
	lda.b d0
	sta.b d1						; d1 = state
	and.w #$0FFF					; time bits
	sta.b d0
	jsl.l PushTime					; d0 = time
	jsl.l print						; print it
	lda.w #$0004
	sta.b d0						; text 4
	lda.w #$4000
	trb.b d1						; clear it
	beq .1x
	lda.w #$0005					; text 5
	sta.b d0
.1x:								; string 4 or 5 of StatusTextTbl
	lda.w #StatusTextTbl>>16
	sta.b a1+2
	lda.w #StatusTextTbl
	sta.b a1
	jml.l PrintStringFromList		; prints a string from a list
