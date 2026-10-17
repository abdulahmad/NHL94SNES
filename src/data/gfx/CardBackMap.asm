; The player card screen frame map (EA SPORTS, the NHL shield, the NHLPA logo), pasted in palette 4 over
; CardBackTiles

CardBackMap:						;a 32 x 32 map packed for DecompressLZ (width, height, , then the map
									;words), read by a screen
			;   setup in bank $9D
	db $10,$FB
	db $00,$08,$06
	incbin "../../../Extracted/data/gfx/CardBackMap.map.lz":5..943
