; Player photo: Pierre Turgeon (PlayerPhotoTable NYI 1; ASE 8)

CardPierreTurgeon:					;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardPierreTurgeon.lin.huf":5..517
