; Roster column: left or right handed
; Takes d0 = player attribute word. Bit 0 inverted selects the string of HandedTextTbl and
; PrintStringFromList prints it (this is a jump, it returns to the caller).
;
; Called through attribjmp.
AttribHanded:						; print left or right handed
	lda.b d0
	and.w #$0001
	eor.w #$0001
	sta.b d0
	lda.w #HandedTextTbl>>16		; text list for the hand
	sta.b a1+2
	lda.w #HandedTextTbl
	sta.b a1
	jml.l PrintStringFromList
