; The goal box with the scorer and the assists
ShowGoalBox:						; called from SetPA
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
	stx.b xsave						; keep X
	ldx.w #$0000
.loop:								; loop: X + 1, X + 1, if not zero go to .loop, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .loop
	ldx.b xsave						; restore X
	lda.w #$FFFF
	sta.w lcpad
	sta.w lcpad+2
	stz.b a2						; find the line change data for both teams
	jsl.l lcfound_close					; close the line change box and redraw the scoreboard
	inc.b a2
	inc.b a2
	jsl.l lcfound_close					; close the line change box and redraw the scoreboard
	lda.w #ScoreSum>>16
	sta.b a4+2
	lda.w #ScoreSum-6
	clc
	adc.l ScoreSumbytes
	sta.b a4
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowGoalBoxPos>>16
	sta.b a1+2
	lda.w #ShowGoalBoxPos
	sta.b a1
	jsl.l print						; print ShowGoalBoxPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0013					; box width 19
	sta.b d0
	lda.w #$0005					; box height 5
	sta.b d1
	ldy.w #ssassist1				; assist byte
	lda.b [a4],y
	bit.w #$0080					; no assist: box one row smaller
	bne .1
	inc.b d1
	inc.b d1
	lda.b [a4],y
	bmi .1
	inc.b d1
.1:									; call Framer, a2 = 0, if [a4],y bits $0080 clear go to .2, ...
	jsl.l Framer					; draw the frame d0 x d1
	stz.b a2
	ldy.w #ssflags
	lda.b [a4],y					; home or visitor flag in the entry
	bit.w #$0080
	beq .2
	inc.b a2
	inc.b a2
.2:									; a1 = GoalBoxText, if a2 = 0 go to .3, ...
	lda.w #GoalBoxText>>16
	sta.b a1+2
	lda.w #GoalBoxText
	sta.b a1
	ldy.w #ssscorer					; scorer number
	lda.b [a4],y
	and.w #$00FF
	ldy.b a2
	beq .3
	clc
	adc.w #$001A
.3:									; if not zero go to .4, ...
	tay
	lda.w tmgoals,y					; goals of the scorer
	and.w #$00FF
	cmp.w #$0003					; third goal: hat trick text
	bne .4
	jsl.l GoalieCount				; d0 = the number of goalies on team a2
	ldy.w #ssscorer
	lda.b [a4],y
	and.w #$00FF
	cmp.b d0
	bmi .4
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
	ldy.b a2
	bne .4
	jsl.l StartHatTrick				; start the hat trick sprites: clear the ten slots and set hattrick
	lda.w PenCntDwn
	clc
	adc.w #$000A
	sta.w PenCntDwn
.4:									; call printbig, d0 = [a4],y & $00FF, call PlayerShortName, ...
	jsl.l printbig
	ldy.w #ssscorer
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	jsl.l PlayerShortName			; mesarea = the number
	jsl.l print						; print it
	ldy.w #ssassist1
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080					; none: done
	bne .5
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #AssistByTxt>>16
	sta.b a1+2
	lda.w #AssistByTxt
	sta.b a1
	jsl.l print						; print AssistByTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l PlayerShortName			; mesarea = the number
	jsl.l print
	ldy.w #ssassist2
	lda.b [a4],y
	and.w #$00FF
	sta.b d0
	bit.w #$0080					; none: done
	bne .5
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShowGoalBoxPos2>>16
	sta.b a1+2
	lda.w #ShowGoalBoxPos2
	sta.b a1
	jsl.l print						; print ShowGoalBoxPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l PlayerShortName			; mesarea = the number
	jsl.l print						; print it
.5:									; xsave = X
	stx.b xsave						; keep X
	ldx.w #$0012
.loop2:								; loop: a0,x = pulled value, X - 1, X - 1, ...
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop2
	ldx.b xsave						; restore X
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
	ldx.b a3
	rtl
