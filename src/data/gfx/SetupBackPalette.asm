; The setup screen goalie picture colours (palette 2, where SetupBackMap is pasted)

SetupBackPalette:					;colours packed for DecompressHuffman, loaded into CGRAM by a screen setup
	db $30,$FB
	db $00,$01,$00
	incbin "../../../Extracted/data/gfx/Pals/SetupBackPalette.pal.huf":5..43
