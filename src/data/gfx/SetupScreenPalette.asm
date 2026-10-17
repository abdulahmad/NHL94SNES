; The stats screens' base colours (palettes 0-2, under the framer and the font), loaded at colour 0 by SetupScreen, LoadScoutingScreen and LoadPlayerCardScreen: the colours 93S keeps in its RonBarrMap block and sends to colour 0 for its stats screens (two colours of the first row differ)

SetupScreenPalette:		; colours packed for DecompressLZ, loaded into CGRAM by screen setups
	db $10,$FB
	db $00,$01,$00
	incbin "../../../Extracted/data/gfx/Pals/SetupScreenPalette.pal.lz":5..137
