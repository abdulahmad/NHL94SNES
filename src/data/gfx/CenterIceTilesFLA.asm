; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesFLA:					;the Florida centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 8 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$20
	incbin "../../../Extracted/data/gfx/CenterIceFLA.lin.huf":5..272
