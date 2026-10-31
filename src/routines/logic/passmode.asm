; Pass mode: a pad direction sets the pass direction and passes; releasing the button passes too
;
; Takes X = player, d0 = pad direction (bit 3 = none), d2 = changed buttons. Direction 0-7 is stored in
; passdir and passed with d0 set to passdir | 8. Called from doinput.
passmode:							; pass mode input
	lda.b d2						; buttons that changed
	bit.w #$8000					; bit $8000 (pass button) changed?
	bne dopass						; yes: pass now
	lda.b d0						; pad direction
	bit.w #$0008					; bit 3 = no direction
	bne .t1							; none: leave
	and.w #$0007					; direction 0-7
	sta.w passdir					; becomes the pass direction
	ora.w #$0008					; mark it as a direction
	sta.b d0
	bra dopass						; pass

.t1:								; no input
	rtl
