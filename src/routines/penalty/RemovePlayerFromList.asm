; Remove entry a0 from a penalty box list by moving the rest down
;
; a0 = index just after the entry to remove, as the caller's scan left it. The bytes after the entry are
; copied down one place up to the one with bit 7 set (the end marker), then a0 is stepped back so the
; caller's scan sees the next entry. Called from updatepentime and PenGoalStuff.
RemovePlayerFromList:				; removes a player from a box list
	lda.w #$FFFF					; d2 = -1
	sta.b d2
.loop:								; next entry
	inc.b d2						; next entry
	lda.b a0
	clc
	adc.b d2
	tay								; index
	sep #$20						; 8-bit A
	lda.w tmboxlist,y				; entry
	sta.w tmboxlist-1,y				; move it down
	rep #$30						; 16-bit registers
	bit.w #$0080					; end mark in bit 7
	beq .loop						; not the end marker yet: next
	dec.b a0						; one entry less
	rtl								; return
