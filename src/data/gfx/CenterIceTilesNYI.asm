; Centre-ice logo tiles: linear 4bpp, packed for DecompressHuffman.

CenterIceTilesNYI:					;the New York Islanders centre ice logo: linear 4bpp tiles packed for
									;DecompressHuffman (team 13
			;   of the centre ice table in bank $9C)
	db $30,$FB
	db $00,$03,$A0
	incbin "../../../Extracted/data/gfx/CenterIceNYI.lin.huf":5..305
	db $FF,$FF,$FF,$FF
