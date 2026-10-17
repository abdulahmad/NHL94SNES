; The Ron Barr picture map (32 x 28) of the scouting report screen (RonBarrTiles)

RonBarrMap:							;a 32 x 28 map packed for DecompressHuffman (width, height, , then the map
									;words), read
			;   by a screen setup in bank $9D
	db $30,$FB
	db $00,$07,$06
	incbin "../../../Extracted/data/gfx/RonBarrMap.map.huf":5..295
