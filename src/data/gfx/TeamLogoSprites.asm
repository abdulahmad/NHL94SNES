; Team logos as one sprite set, packed for DecompressHuffman: one frame per team, then the Wales
; and Campbell conference logos and the NHL and NHLPA logos. Team setup unpacks the set and draws
; a frame with DrawSprite, in that team's palette.

TeamLogoSprites:					; format word, unpacked size (big-endian), then the stream
	db $30,$FB
	db $00,$7C,$00
	incbin "../../../Extracted/data/gfx/TeamLogos.spr.huf":5..21095
