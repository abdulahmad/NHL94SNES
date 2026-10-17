; Packed small font tiles (106; the print font), remapped with PixelRemap83 as 93S SmallFontTiles

SmallFontTiles:						;tiles packed for DecompressPairs that screen setups in banks $9D and $9F
									;send to VRAM
	db $46,$FB
	db $00,$0D,$40
	incbin "../../../Extracted/data/gfx/SmallFontTiles.chr.pairs":5..1250
