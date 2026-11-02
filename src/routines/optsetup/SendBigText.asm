; Send the RenderBigText map (screenmap, the BigLetterSelect map) and the letter tiles (bigtextbuf,
; bigtextchar letters) to VRAM
SendBigText:						; called from PlayerSelect
	lda.w #$0020
	sta.l screenmap+6
	sta.l screenmap+8
	lda.w #screenmap>>16
	sta.b p0+2
	lda.w #screenmap+6
	sta.b p0
	lda.w #$0800
	sta.w MapVRAM
	lda.w #$0000
	sta.b r7
	lda.w #$0020
	sta.b r4
	lda.w #$0002
	sta.b r4+2
	ldy.w printy
	sty.b r7+2
	ldx.w #$0000
	jsl.l MapPartToVRAM				; copy part of map [p0] into the screen map in video memory at column X
	lda.w #bigtextbuf>>16
	sta.b p0+2
	lda.w #bigtextbuf
	sta.b p0
	ldy.w #$4000
	lda.l bigtextchar
	inc a
	asl a
	asl a
	asl a
	asl a
	tax
	jsl.l DMAToVRAM					; DMA X bytes from [p0] to video memory at Y
	rts
