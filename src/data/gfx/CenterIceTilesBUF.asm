; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesBUF:					;the Buffalo centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 2 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$60
	incbin "../../../Extracted/data/gfx/CenterIceBUF.lin.huf":5..266
