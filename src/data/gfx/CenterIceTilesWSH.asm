; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesWSH:					;the Washington centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 24 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$02,$40
	incbin "../../../Extracted/data/gfx/CenterIceWSH.lin.huf":5..147
