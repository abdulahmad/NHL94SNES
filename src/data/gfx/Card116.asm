; Player photo 116 (PlayerPhotoTable BUF 12; ASE 15)

Card116:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card116.lin.huf":5..552
