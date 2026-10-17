; The 30 x 12 player list box map (SelectLinePlayer, ShooterSelectList)

PlayerListMap:						;a 30 x 12 map packed for DecompressLZ (width,
									;height, , then the map words)
			;   read in bank $9B
	db $10,$FB
	db $00,$02,$D6
	incbin "../../../Extracted/data/gfx/PlayerListMap.map.lz":5..41
