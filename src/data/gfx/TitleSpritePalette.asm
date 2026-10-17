; The title sprite colours, unpacked to $7F0100 (colours 128 up, the sprite palettes) before TitlePalette goes to CGRAM

TitleSpritePalette:		; colours packed for DecompressLZ, loaded into CGRAM by a screen setup
	db $10,$FB
	db $00,$00,$A0
	incbin "../../../Extracted/data/gfx/Pals/TitleSpritePalette.pal.lz":5..76
