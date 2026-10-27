; Player photo 90 (PlayerPhotoTable BOS 17; ASE 18)

Card090:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card090.lin.huf":5..573
