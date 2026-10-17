; The playoff tree colours (128) unpacked into palbuffer: the colours of 93S PlayoffTiles (two bytes differ)

PlayoffPalette:		; packed for DecompressLZ by a screen setup
	db $10,$FB
	db $00,$01,$00
	incbin "../../../Extracted/data/gfx/Pals/PlayoffPalette.pal.lz":5..89
