; The big letter tiles (50, linear 4bpp, A-Z and marks) RenderBigText draws team names with: the player select
; and playoff screens unpack them

BigLetterTiles:						;packed for DecompressHuffman, unpacked into a RAM buffer by screen setups
	db $30,$FB
	db $00,$06,$40
	incbin "../../../Extracted/data/gfx/BigLetterTiles.huf":5..401
