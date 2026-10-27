; Player photo 33 (PlayerPhotoTable CGY 10; ASW 11)

Card033:							;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/Card033.lin.huf":5..618
