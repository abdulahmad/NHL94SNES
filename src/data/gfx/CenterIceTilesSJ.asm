; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesSJ:					;the San Jose centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 19 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$00
	incbin "../../../Extracted/data/gfx/CenterIceSJ.lin.huf":5..269
