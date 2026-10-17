; Background tiles packed for DecompressLZ: LoadPlayerCardScreen loads all 324 after CardBackTiles, but only
; the last 8 are shown, the photo frame CardPictureMap lays out; the first 316 are an unused EA SPORTS /
; ELECTRONIC ARTS logo on marble (no map in the ROM uses them; not the boot logo, EALogoTiles)

CardFrameTiles:
	db $10,$FB
	db $00,$28,$80
	incbin "../../../Extracted/data/gfx/CardFrameTiles.chr.lz":5..5452
