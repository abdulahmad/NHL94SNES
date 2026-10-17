; The menu background colours (palettes 3 and 4, where MenuBackMap is pasted) of the scouting, playoff and setup screens

MenuBackPalette:		; colours packed for DecompressLZ, loaded into CGRAM by screen setups
	db $10,$FB
	db $00,$01,$00
	incbin "../../../Extracted/data/gfx/Pals/MenuBackPalette.pal.lz":5..71
