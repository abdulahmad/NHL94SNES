; Clear the RenderBigText letter tile buffer (bigtextbuf+1, $300 bytes) and part of its map (screenmap+$28C)
ClearBigText:						; called from PlayerSelect
	lda.w #$007E
	sta.b p1+2
	lda.w #$4EF5
	sta.b p1
	lda.w #$0000
	ldx.w #$0300
	jsl.l MemFill
	lda.w #$007E
	sta.b p1+2
	lda.w #$A8FC
	sta.b p1
	ldx.w #$0080
	lda.w #$0000
	jsl.l MemFill
	rts
