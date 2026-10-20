; clear the locked bit of handle A's block
; A = handle ($2000-$20FF index into the handle table); other values are ignored. Reads the block address of
; the handle, finds that block in the heap list of the bank and clears the locked bit of its flags.
;
; No caller found.
UnlockHandle:						; clear the locked bit of handle A's block
	pha
	cmp.w #$2000					; handle in range?
	bcc .exit
	cmp.w #$2100
	bcs .exit
	tax								; X = offset in the handle table
	lda.l Ram7E+2,x					; bank of the block
	tay
	lda.l Ram7E,x					; block address
	tyx								; bank to X
	ldy.w HeapStart7E				; start of the 7E heap
	cpx.w #$007E					; bank $7E?
	beq .heap						; yes
	ldy.w HeapStart7F				; start of the 7F heap
	cpx.w #$007F					; bank $7F?
	bne .exit						; neither: ignore
.heap:								; block header is 8 bytes before the address
	sec
	sbc.w #$0008					; look for the block
	sta.b r3						; pointer low word
	stx.b p0+2						; bank
	stz.b p0
.find:								; walk the heap list
	cpy.b r3						; reached the block?
	beq .found
	iny								; skip to the link field
	iny
	iny
	iny
	lda.b [p0],y					; next block
	beq .exit						; end of the list: not found
	tay
	bra .find						; follow the link
.found:								; found: flags word follows
	iny
	iny
	lda.b [p0],y					; flags
	beq .exit						; none
	and.w #$8000					; keep only bit 15, the other flag bits go
	sta.b [p0],y					; clear the locked bit
.exit:								; handle out of range or block not found
	pla								; restore A
	rtl
