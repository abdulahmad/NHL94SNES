; While the pause pad holds A or B: pulse the side colour (PulsePauseSide) and send it to CGRAM each frame
PulseUntilRelease:					; no input; returns when the pause pad lets go of A and B
	jsr.w PulsePauseSide			; pulse the side colour
	lda.w #(colourbuf+$1C0)>>16		; p0 = colour buffer copy
	sta.b p0+2
	lda.w #colourbuf+$1C0
	sta.b p0
	ldy.w #$00E0					; y = first CGRAM colour (palette entry $E0)
	ldx.w #$0020					; x = bytes (16 colours)
	jsl.l WaitFrame					; wait for the frame
	jsl.l DMAToCGRAM				; send to CGRAM
	ldx.w pausepad					; pad that paused
	lda.w PadRaw1,x					; its buttons
	bit.w #$8080					; B or A (PadRaw1 $8000 / $0080) still held?
	bne PulseUntilRelease			; yes, keep pulsing
	rts
