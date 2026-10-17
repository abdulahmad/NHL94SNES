; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesCHI:					;the Chicago centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 4 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$80
	incbin "../../../Extracted/data/gfx/CenterIceCHI.lin.huf":5..439
