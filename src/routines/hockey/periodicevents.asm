; Run every game loop; the slower checks once a second
;
; Takes d7 = frames elapsed. lldisp counts down by d7 and reloads with $18 (24) when it passes zero.
; Called from DoGameFrame.
periodicevents:						; each frame: penalties, crowd, sound, clock; once a second: game checks
	jsl.l PenaltyManager			; penalty message handling
	jsl.l updatecrowdf				; fade the crowd level
	jsl.l updatesound				; sound engine
	jsl.l clockcont					; end of period check
	lda.w sfhormode					; horizontal screen mode?
	bne .rtl						; yes: skip the slow checks
	lda.w lldisp					; lldisp = count down to the next once-a-second pass
	sec
	sbc.b d7						; minus d7
	sta.w lldisp					; store the new count
	bpl .rtl						; not run out yet: leave
	clc								; reload: add 24 to the (negative) remainder
	adc.w #$0018
	sta.w lldisp					; store the reloaded count
	jsl.l ChkGoalies				; goalie checks
	jsl.l UpdateCwdExcite			; update the crowd excitement
	jsl.l CheckLateGameSong			; late game song check
	jsl.l RestoreBenchEnergy		; bench players regain energy
	jsl.l CheckInjury				; injury check
	jsl.l updatepwrplay				; power play update
.rtl:								; return
	rtl
