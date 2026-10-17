; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesPHI:					;the Philadelphia centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 16 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$80
	incbin "../../../Extracted/data/gfx/CenterIcePHI.lin.huf":5..289
