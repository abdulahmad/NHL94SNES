; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesNJ:					;the New Jersey centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 12 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$20
	incbin "../../../Extracted/data/gfx/CenterIceNJ.lin.huf":5..328
