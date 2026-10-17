; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesLA:					;the Los Angeles centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 10 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$20
	incbin "../../../Extracted/data/gfx/CenterIceLA.lin.huf":5..240
