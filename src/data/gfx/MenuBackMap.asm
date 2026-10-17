; The menu background map (32 x 28) of the scouting, playoff, setup, line editor and shooters screens
; (MenuBackTiles)

MenuBackMap:						;a 32 x 28 map packed for DecompressLZ (width, height, , then the map
									;words), read
			;   by screen setups in banks $9B and $9D
	db $10,$FB
	db $00,$07,$06
	incbin "../../../Extracted/data/gfx/MenuBackMap.map.lz":5..352
