; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesNHL:					;the NHL shield centre ice logo of the all-star teams (26 and 27 of the
									;centre ice table in bank
			;   $9C): linear 4bpp tiles packed for DecompressHuffman, drawn with CenterIceMapNHL
	db $30,$FB
	db $00,$02,$E0
	incbin "../../../Extracted/data/gfx/CenterIceNHL.lin.huf":5..249
