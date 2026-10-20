; Fill the hot / cold table ($1A12, both teams) with random values -12 ... 12
;
; Fills 624 bytes ($270) from the end down: each is a random 0-13 limited to 12, negative when bit 4 of seed
; is clear. Called from StartGame.
Create_HotCold_Table:				; fill HotColdTable with random values -12 to 12
	ldx.w #$026F					; X = last byte of the table
.2:									; next byte
	lda.w #$000E					; random 0 to 13
	jsl.l randoma8
	cmp.w #$000C					; limit to 12
	bcc .1
	lda.w #$000C
.1:									; keep the magnitude
	sta.b r3
	lda.w seed						; random sign from the seed
	and.w #$0010					; bit 4 clear: negative
	beq .4							; clear: negative value
	sep #$20						; 8-bit A
	lda.b r3
	sta.w HotColdTable,x			; store +r3
.3:									; next byte
	rep #$20						; 16-bit A
	dex
	bpl .2							; until X is negative
	rtl								; done
.4:									; negative value
	sep #$20
	lda.b #$00
	sec
	sbc.b r3						; 0 - r3
	sta.w HotColdTable,x
	bra .3
