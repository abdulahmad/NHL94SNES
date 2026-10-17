; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesTB:					;the Tampa Bay centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 21 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$C0
	incbin "../../../Extracted/data/gfx/CenterIceTB.lin.huf":5..363
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
