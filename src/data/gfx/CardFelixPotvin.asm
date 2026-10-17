; Player photo: Felix Potvin (PlayerPhotoTable TOR 0; ASW 2)

CardFelixPotvin:		; a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardFelixPotvin.lin.huf":5..564
	db $00
