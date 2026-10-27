; Player photo 102 (PlayerPhotoTable HFD 17; ASE 23)

Card102:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card102.lin.huf":5..564
