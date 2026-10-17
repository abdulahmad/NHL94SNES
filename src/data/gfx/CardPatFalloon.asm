; Player photo: Pat Falloon (PlayerPhotoTable SJ 12; ASW 15)

CardPatFalloon:						;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the photo table
			;   in bank $9D
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardPatFalloon.lin.huf":5..601
	db $00
