; Player photo: Brian Bradley (PlayerPhotoTable TB 3; ASW 6)

CardBrianBradley:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardBrianBradley.lin.huf":5..553
