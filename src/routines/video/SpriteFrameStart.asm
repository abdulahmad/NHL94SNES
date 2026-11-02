; start filling OAMDrawBuf after the reserved entries; free the tiles of frames not drawn
; Takes nothing. Sets the data bank to $7E, computes SpritesLeft ($80 - SpritesReserved), the OAM high table
; pointer and shift and OAMNext for the reserved entries, then walks the frame cache: entries not used since
; the last call are freed with FreeCacheEntry.
;
; Called from SwapRosterTeam, SetupScreen, SelectLinePlayer, setoptions, SaveRegsStartHL2, RedrawPlayerSelect.
SpriteFrameStart:					;start filling OAMDrawBuf after the reserved entries; free the tiles of
									;frames not drawn
			;   since the last call
	phb								; save the data bank
	lda.w #$7E7E					; bank $7E for both
	pha
	plb
	plb
	lda.w #$0080					; 128 OAM entries
	sec
	sbc.w SpritesReserved			; minus the reserved ones
	sta.w SpritesLeft				; entries left for drawing
	lda.w SpritesReserved			; reserved entries
	lsr a							; 4 entries per high table byte
	lsr a
	tax								; X = high table byte offset
	clc
	adc.w OAMDrawBuf				; plus the draw buffer
	adc.w #$0200					; plus the high table offset in the buffer
	sta.w OAMHiPtr					; next high table byte to fill
	txa								; entry number
	and.w #$0003					; position inside the byte
	eor.w #$0003					; counts down, 3 to 0
	sta.w OAMHiShift				; shift of the next entry
	lda.w SpritesReserved			; reserved entries
	asl a							; 4 bytes per entry
	asl a
	adc.w OAMDrawBuf				; plus the draw buffer
	sta.w OAMNext					; first OAM entry to fill
	lda.w FrameCacheCount			; frame cache entries in use
	beq .2							; none
	dec a							; last entry
	asl a							; word index
	tax
.1:									; look at each cache entry
	lda.w FrameCacheUse,x			; use count word
	bmi .t1							; negative: never freed this way
	lsr a							; age the entry
	sta.w FrameCacheUse,x
	bcc .t1							; still used? skip
	ldy.w FrameCacheNum,x			; tile number of the entry
	sep #$20
	lda.b #$80
	pha
	rep #$20						; 16-bit A
	lda.w #.t1-1					; return address for the free routine
	pha
	phx
	phy
	phb
	jmp.w FreeCacheEntry			; free the cache entry, returns to .t1

.t1:								; next cache entry
	dex
	dex
	bpl .1							; until the first is done
.2:									; leave
	plb								; restore the data bank
	rtl
