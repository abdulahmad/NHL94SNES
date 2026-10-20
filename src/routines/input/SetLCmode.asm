; Open the line change box for player X's team, when line changes are on and the box is not open
;
; Takes X = player of the team. Does nothing unless OptLine is 1 and the team's tmflags bit 3 (line change
; box open) is clear; sets that bit, clears sflags bits 2-3 and continues in SetLCmode2.
; Called from doinput and puckfaceoff.
SetLCmode:							; open the line change box for the team of player X
	lda.l OptLine					; line changes option
	cmp.w #$0001					; only 1 (on) opens the box
	bne .t1							; off or automatic: leave
	jsl.l loadTeamStruct			; a2 = team of player X
	ldy.b a2						; Y = team offset
	lda.w tmflags,y					; team flags
	bit.w #$0008					; box already open (bit 3)?
	bne .t1							; yes: leave
	ora.w #$0008					; mark the box as open
	sta.w tmflags,y					; store the team flags
	lda.w #$000C					; clear sflags bits 2 and 3 (pass and shot direction set)
	trb.w sflags
	jmp.w SetLCmode2				; draw the box

.t1:								; nothing to do
	rtl
