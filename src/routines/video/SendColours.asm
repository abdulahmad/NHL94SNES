; send the 256 colours of the colour buffer with DMAToCGRAM
SendColours:						; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.w #colourbuf>>16
	sta.b p0+2
	lda.w #colourbuf
	sta.b p0
	ldy.w #$0000
	ldx.w #$0100
	jsl.l DMAToCGRAM				; DMA X bytes of colours from [p0] to CGRAM at colour Y
	rtl
