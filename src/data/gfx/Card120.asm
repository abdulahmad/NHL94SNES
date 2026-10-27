; Player photo 120 (PlayerPhotoTable QUE 15; ASE 20)

Card120:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card120.lin.huf":5..543
	db $00
