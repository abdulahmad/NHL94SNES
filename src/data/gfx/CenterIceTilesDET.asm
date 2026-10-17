; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesDET:					;the Detroit centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 6 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$40
	incbin "../../../Extracted/data/gfx/CenterIceDET.lin.huf":5..267
