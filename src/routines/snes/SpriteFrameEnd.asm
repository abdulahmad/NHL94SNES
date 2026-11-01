; move the unused entries off screen, swap the OAM buffers and set OAMReady
; Takes nothing. Fills the OAM entries from OAMNext up to OAMHideEnd with Y=$E1 (off screen), then swaps
; OAMDrawBuf and OAMShowBuf and sets OAMReady so that the NMI copies the buffer.
;
; Called from SelectLinePlayer, TeamRosterScreen, setoptions, PeriodStatsScreen and SaveRegsStartHL2.
SpriteFrameEnd:						;move the unused entries off screen, swap the OAM buffers and set OAMReady
	phb								; save the data bank
	pea.w (Ram7E>>16)*$0101			; data bank = $7E (pushed twice)
	plb
	plb
	lda.w SpritesLeft				; (SpritesLeft value is not used)
	ldx.w OAMNext					; first unused entry
	lda.w #$E100					; off screen value for the Y and X bytes
.loop:								; hide loop
	cpx.w OAMHideEnd				; reached the end of the entries hidden last frame?
	bcs .1							; yes
	sta.w $0000,x					; park this entry
	inx
	inx
	inx
	inx								; next entry (4 bytes each)
	bne .loop						; loop until the index wraps
.1:									; entries hidden
	ldy.w OAMLastEnd				; end of last frame's entries
	lda.w OAMNext					; this frame's end
org $80B001
	sta.w OAMLastEnd				; remember this frame's end
	sty.w OAMHideEnd				; and the end for the next hiding pass
	ldx.w OAMDrawBuf				; swap the OAM buffers
	ldy.w OAMShowBuf
	stx.w OAMShowBuf
	sty.w OAMDrawBuf
	sep #$20						; 8-bit A
	lda.b #$01						; tell the NMI
	sta.w OAMReady					; a new OAM buffer is ready
	rep #$20						; 16-bit A
	plb								; restore the data bank
	rtl
