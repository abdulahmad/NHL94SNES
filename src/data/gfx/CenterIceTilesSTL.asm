; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesSTL:					;the St. Louis centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 20 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$20
	incbin "../../../Extracted/data/gfx/CenterIceSTL.lin.huf":5..268
