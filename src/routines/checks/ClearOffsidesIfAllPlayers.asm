; Clear team a2's offsides flag once none of its skaters is past the blue line
; Takes: a2 = team. Called from ChkOffsides. Clears tmfoside in tmflags of the team once none of its six
; skaters is past the blue line (y beyond $58, seen from his own goal); otherwise ends through
; ChkOffsides_rtl.
ClearOffsidesIfAllPlayers:			; clear the offsides flag when nobody is offside any more
	ldy.b a2						; team
	lda.w tmflags,y					; team flags
	bit.w #tmfoside					; tmfoside set?
	bne .t1							; yes: check the players
	jmp.w ChkOffsides_rtl			; no: nothing to do

.t1:								; flag is set: look at the six players
	lda.w tmsort,y					; first player of the team
	sta.b a0						; a0 = first
	lda.w #$0005					; six players
	sta.b d1
.2:									; each player in turn
	ldy.b a0
	lda.w position,y				; empty position: skip
	bmi .1
	lda.w Ypos,y					; y
	sta.b d0
	lda.w pfgoal,y					; which goal he shoots at
	bne .1
	lda.w #$0000					; mirror y for the other end
	sec
	sbc.b d0
	sta.b d0
.1:									; next player
	inc.b a0
	inc.b a0
	lda.b d0						; y minus the blue line
	sec
	sbc.w #$0058
	bmi .t1x						; not past it: next player
	jmp.w ChkOffsides_rtl			; past the blue line: still offside

.t1x:								; next player
	dec.b d1
	bpl .2							; more players
	ldy.b a2						; nobody past the line: clear the flag
	lda.w tmflags,y
	and.w #$FFEF					; clear tmfoside
	sta.w tmflags,y
	rtl								; return
