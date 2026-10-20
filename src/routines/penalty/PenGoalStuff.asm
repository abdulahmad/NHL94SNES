; After a power play goal, let the first player whose penalty is not coincidental out of the box
;
; Called from Goal after a goal. a1 = team scored on and a2 = scoring team.
; Prunes PenBuf (the entries without minutes or not for the scoring team are overwritten with $34), then,
; if the scoring team had more players on the ice, releases the first scored-on player in the box whose
; penalty is not coincidental. All registers are restored.
PenGoalStuff:						; handles the penalties after a goal
	lda.b d0						; save d0 to a0+2 (8 words)
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
	lda.w gsp						; game period
	cmp.w #$0003					; period 3?
	beq .4							; yes: clear PenBuf
	lda.w #PenBuf					; a0 = PenBuf
	sta.b a0
.3:									; walk PenBuf
	lda.b (a0)						; next word
	inc.b a0
	inc.b a0
	and.w #$00FF					; low byte is the penalty number
	cmp.w #$0034					; $34: entry already dropped
	beq .3
	cmp.w #$0000					; zero: end of PenBuf
	bne .t1
	jmp.w .5						; end: go to the release part

.t1:								; look the penalty up
	tay								; y = penalty number
	lda.w #PenaltyList>>16			; a1 = PenaltyList
	sta.b a1+2
	lda.w #PenaltyList
	sta.b a1
	lda.b [a1],y					; offset of this penalty's record
	clc
	adc.b a1
	sta.b a1
	lda.b [a1]						; first byte of the record: penalty minutes
	and.w #$00FF
	beq .2							; none: drop the entry
	dec.b a0						; back to the entry
	dec.b a0
	lda.w #$0000					; d0 = 0 (home)
	sta.b d0
	lda.b (a0)						; the entry's high byte (object offset)
	inc.b a0
	inc.b a0
	and.w #$FF00					; object offset only
	cmp.w #$0600					; below $600: home player
	bcc .1							; home: d0 stays 0
	lda.w #$0002					; else d0 = 2 (visitors)
	sta.b d0
.1:									; team of the player in d0
	lda.b a2						; scoring team
	cmp.b d0						; same team: keep the entry
	beq .3							; keep it, next entry
.2:									; not for the scoring team or no minutes
	dec.b a0						; back to the entry
	dec.b a0
	lda.w #$0034					; mark it $34
	sta.b (a0)						; store
	inc.b a0
	inc.b a0
	bra .3							; next entry
.4:									; period 3 (see above)
	jsl.l ClearPenaltyBuffer		; clear PenBuf
.5:									; release a scored-on player
	ldy.b a2						; scoring team
	lda.w tmap,y					; players on the ice
	ldy.b a1						; scored-on team
	sec
	sbc.w tmap,y					; scoring team minus scored-on team
	beq .3x							; equal: no release
	bmi .3x							; fewer: no release
	lda.b a1						; scored-on team
	beq .1x							; team 0: box list at 0
	lda.w #$001A					; team 1: box list at $1A
.1x:								; box list offset chosen
	sta.b a0						; a0 = box list start
.loop:								; next player in the box list
	ldy.b a0
	lda.w tmboxlist,y				; box list entry
	inc.b a0						; a0 advances
	and.w #$00FF					; player in the low byte
	sta.b d2						; d2 = player
	bit.w #$0080					; bit 7 set = end of list
	bne .3x							; end: done
	lda.b a1						; scored-on team
	beq .2x							; team 0: state table at 0
	lda.w #$0034					; team 1 state table is $34 bytes on
.2x:								; state table offset chosen
	clc
	adc.b d2
	tay								; y = index into tmpdst
	lda.w tmpdst,y					; player state
	bit.w #$4000					; bit 14: coincidental
	bne .loop						; coincidental: skip
	lda.w #$0000					; out of the box: state 0
	sta.w tmpdst,y
	jsl.l RemovePlayerFromList		; take him off the box list
	ldy.b a1						; one more player on the ice
	lda.w tmap,y
	inc a
	sta.w tmap,y
	ldy.b a2						; scoring team
	lda.w tmPwrGoals,y				; power play goals + 1
	inc a
	sta.w tmPwrGoals,y
	lda.w #$0001					; line change box redraw (bit 0 of tmflags)
	tsb.w tmflags					; both teams' tmflags
	tsb.w tmflags+2
.3x:								; restore the registers
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
	rtl								; return
