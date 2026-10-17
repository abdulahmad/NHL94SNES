; Player photo: Joe Cirella (PlayerPhotoTable FLA 11)

CardJoeCirella:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardJoeCirella.lin.huf":5..613
