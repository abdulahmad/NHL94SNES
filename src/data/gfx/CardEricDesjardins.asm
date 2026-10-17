; Player photo: Eric Desjardins (PlayerPhotoTable MTL 16)

CardEricDesjardins:					;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardEricDesjardins.lin.huf":5..568
	db $00
