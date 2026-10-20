; During the intermission, show the next ticker score, then the highlights
;
; Called each frame during the intermission: when $150 frames have passed since the last ticker change
; it steps TickerNext, repeating until the ticker is back at its first game, then plays DoHiLights.
; Returns A = 0. Called from SelectPauseController.
IntermissionTick:					; the intermission ticker timer
	lda.w demoflag					; demo mode (intermission)?
	beq IntermissionTick_done		; no: leave
	lda.b vcount					; frames since the last change
	sec
	sbc.w tickervc
	cmp.w #$0150					; $150 frames
	bcc IntermissionTick_done		; not yet: leave
	jsl.l TickerNext				; next ticker game
	lda.l tickerstart				; first ticker game
	cmp.w TickerNum					; back at the first one?
	bne IntermissionTick			; no: change again
	jsl.l DoHiLights				; yes: play the highlights
	lda.w #$0008					; clear flag bit 3 of sflags3
	trb.w sflags3
IntermissionTick_done:				; nothing to report
	lda.w #$0000					; return 0
	rtl
