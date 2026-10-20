; Swap line slot bytes d0+2 and d0+4
SwapLineSlots:						; d0 = slot offset; called from SetLineSlot
	lda.b d0						; slot offset
.1:									; A = offset: swap the slots at A+2 and A+4
	inc a
	inc a
	sta.b a3						; a3 = first slot
	jsr.w ReadLineSlot				; read the first slot
	sta.w lineswap					; keep it
	inc.b a3						; a3 = second slot
	inc.b a3
	jsr.w ReadLineSlot
	dec.b a3						; back to the first slot
	dec.b a3
	jsr.w WriteLineSlot				; the second slot's byte goes to the first
	inc.b a3						; second slot again
	inc.b a3
	lda.w lineswap					; the first slot's old byte
	jsr.w WriteLineSlot				; goes to the second
	rts								; done
; A = the byte at [a3]
ReadLineSlot:						; returns A = the byte at [a3]
	sep #$20						; 8-bit A
	lda.b [a3]
	rep #$20
	and.w #$00FF					; clear the high byte
	rts
