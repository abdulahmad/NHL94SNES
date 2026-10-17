; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesANH:					;the Anaheim centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 0 of
			;   the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$60
	incbin "../../../Extracted/data/gfx/CenterIceANH.lin.huf":5..405
