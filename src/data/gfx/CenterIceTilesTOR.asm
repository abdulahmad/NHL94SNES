; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesTOR:					;the Toronto centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 22 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$40
	incbin "../../../Extracted/data/gfx/CenterIceTOR.lin.huf":5..216
