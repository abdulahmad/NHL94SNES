; The Ron Barr picture tiles (the announcer at the desk with the EA SPORTS microphone): the scouting report
; background

RonBarrTiles:						;background tiles packed for DecompressHuffman, unpacked by a screen setup
	db $30,$FB
	db $00,$12,$80
	incbin "../../../Extracted/data/gfx/RonBarrTiles.chr.huf":5..2944
