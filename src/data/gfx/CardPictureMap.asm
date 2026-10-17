; The 7 x 7 picture box map of the player card (LoadPlayerCardScreen)

CardPictureMap:						;a 7 x 7 map packed for DecompressLZ (width, height, , then the map words)
			;   read by a screen setup in bank $9D
	db $10,$FB
	db $00,$00,$68
	incbin "../../../Extracted/data/gfx/CardPictureMap.map.lz":5..37
