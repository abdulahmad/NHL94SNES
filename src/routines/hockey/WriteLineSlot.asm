; Write the low byte of A to [a3]
;
; Takes: A = value, [a3] = the byte to write. Called from SetLineSlot and SwapLineSlots.
WriteLineSlot:						; store the low byte of A through the a3 pointer
	and.w #$00FF					; keep only the low byte
	sep #$20						; 8-bit accumulator
	sta.b [a3]						; write the byte
	rep #$20						; back to 16-bit
	rts
