; Player photo 87 (PlayerPhotoTable BOS 2; ASE 6)

Card087:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card087.lin.huf":5..573
