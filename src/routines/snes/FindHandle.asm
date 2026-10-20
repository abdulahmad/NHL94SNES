; the handle of address A in bank X, 0 if none
;
; Takes: A = address, X = bank. Returns A = the handle (offset of its entry in HandleTable) whose address and
; bank match, or 0 if none. Searches all 64 entries of 4 bytes.
FindHandle:							; search the handle table
	stx.b r3+2						; bank to find
	sta.b r3
	ldx.w #$2000					; first entry at $2000
.loop:								; compare entry X with the address and bank
	lda.l Ram7E,x					; compare the address word, then the bank word
	cmp.b r3
	bne .next
	lda.l Ram7E+2,x
	cmp.b r3+2
	beq .found
.next:								; next entry
	inx
	inx
	inx
	inx
	cpx.w #$2100					; end of the table ($2100)?
	bne .loop
	lda.w #$0000					; not found
	bra .exit
.found:								; found
	txa								; A = offset of the entry
.exit:								; return
	rtl
