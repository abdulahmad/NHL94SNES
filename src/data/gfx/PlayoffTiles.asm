; The playoff tree tiles (6): the tiles of 93S PlayoffTiles, byte for byte, sent to VRAM $1000 as 93S does

PlayoffTiles:						; packed for DecompressHuffman by a screen setup
	db $30,$FB
	db $00,$00,$C0
	incbin "../../../Extracted/data/gfx/PlayoffTiles.huf":5..45
