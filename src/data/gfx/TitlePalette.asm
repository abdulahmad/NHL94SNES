; The title and licence screen colours (256), unpacked to unpackbuf and sent to CGRAM with TitleSpritePalette
; over the sprite half

TitlePalette:						; 256 colours packed for DecompressLZ, loaded into CGRAM by a screen setup
	db $10,$FB
	db $00,$02,$00
	incbin "../../../Extracted/data/gfx/Pals/TitlePalette.pal.lz":5..263
