; Player photo 84 (PlayerPhotoTable NJ 17; ASE 22)

Card084:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card084.lin.huf":5..577
