; The title logo NHL letters (32 x 28 map at VRAM $5800, over TitleLogoTiles)

TitleNHLMap:						;a 32 x 28 map packed for DecompressHuffman (width, height, , then the map
									;words), read
			;   by a screen setup in bank $9D
	db $30,$FB
	db $00,$07,$06
	incbin "../../../Extracted/data/gfx/TitleNHLMap.map.huf":5..229
	db $00
