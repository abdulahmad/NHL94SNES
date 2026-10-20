; Change team a2 to the chosen line
;
; Takes a2 = team, a3 = player X, d2 = the chosen line change row. Leaves the box (tmflags bit 3 cleared),
; sets tmline, puts the new line on the ice and ends in lcfound2. Called from lineinput and puckfaceoff.
lcfound:							; switch team a2 to the line chosen by row d2
	ldx.b a3						; X = player
	ldy.b a2						; Y = team offset
	lda.b d2						; chosen row
	sta.b d0
	sta.w tmlcchoice,y				; remember it
	jsl.l getlchoice				; d0 = the line for that row
	lda.b d0						; no line there?
	bmi .t1							; leave
	lda.w pflags,x					; player flags
	ora.w #$0008					; set bit 3
	sta.w pflags,x
	jsl.l loadTeamStruct			; a2 = team of X
	ldy.b a2
	lda.w tmflags,y					; team flags
	and.w #$FFF7					; close the line change box (bit 3)
	sta.w tmflags,y
	lda.b d0
	sta.w tmline,y					; team's line
	lda.w #$FFFF					; no pad has the box
	sta.w lcpad,y					; store it
	jsl.l setpersonel				; players for the new line
	jmp.w lcfound2					; close the box and redraw the scoreboard

.t1:								; nothing chosen
	rtl
