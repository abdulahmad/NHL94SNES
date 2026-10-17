; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesWPG:					;the Winnipeg centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 25 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$A0
	incbin "../../../Extracted/data/gfx/CenterIceWPG.lin.huf":5..302
