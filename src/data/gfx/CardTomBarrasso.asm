; Player photo: Tom Barrasso (PlayerPhotoTable PIT 0; ASE 2)

CardTomBarrasso:					;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardTomBarrasso.lin.huf":5..521
