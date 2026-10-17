; Player photo: Tim Cheveldae (PlayerPhotoTable DET 0; ASW 1)

CardTimCheveldae:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardTimCheveldae.lin.huf":5..572
	db $00
