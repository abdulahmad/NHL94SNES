; The title logo "94" puck (32 x 28 map at VRAM $5400, over TitleLogoTiles)

Title94Map:							;a 32 x 28 map packed for DecompressHuffman (width, height, , then the map
									;words), read
			;   by a screen setup in bank $9D
	db $30,$FB
	db $00,$07,$06
	incbin "../../../Extracted/data/gfx/Title94Map.map.huf":5..145
