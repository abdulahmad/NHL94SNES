; Player photo: Peter Sidorkwicz (PlayerPhotoTable OTT 0)

CardPeterSidorkwicz:				;a player photo: 6 x 6 linear 4bpp tiles packed for DecompressHuffman, one
									;entry of the per-team photo
			;   table in bank $9D (the first photo of the Ottawa team)
	db $30,$FB
	db $00,$04,$80
	incbin "../../../Extracted/data/gfx/PlayerCards/CardPeterSidorkwicz.lin.huf":5..532
