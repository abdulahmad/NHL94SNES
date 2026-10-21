; Clear the RenderBigText letter tile buffer (bigtextbuf+1, $300 bytes) and part of its map (screenmap+$28C)
ClearBigText:						; called from PlayerSelect
	lda.w #bigtextbuf>>16
	sta.b p1+2
	lda.w #bigtextbuf+1
	sta.b p1
	lda.w #$0000
	ldx.w #$0300
	jsl.l MemFill
	lda.w #screenmap>>16
	sta.b p1+2
	lda.w #screenmap+$28C
	sta.b p1
	ldx.w #$0080
	lda.w #$0000
	jsl.l MemFill
	rts
