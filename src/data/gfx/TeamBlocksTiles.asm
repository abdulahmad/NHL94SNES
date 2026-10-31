; The team block tiles (21), loaded at scorechars: DrawTeamBlocks draws Teamblocksmap over them in the team's
; TeamBlockPalettes colours, as 93S TeamBlocksTiles (94 draws the name as sprites, so the tiles are a plain
; block)

TeamBlocksTiles:					;tiles packed for DecompressHuffman sent to VRAM by screen setups in banks
									;$9D and $9F
	db $30,$FB
	db $00,$02,$A0
	incbin "../../../Extracted/data/gfx/TeamBlocksTiles.chr.huf":5..290
