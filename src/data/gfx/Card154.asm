; Player photo 154 (PlayerPhotoTable PIT 2; ASE 3)

Card154:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card154.lin.huf":5..470
