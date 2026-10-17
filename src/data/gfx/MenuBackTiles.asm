; The menu background tiles (bevelled boxes on a pattern) of the scouting, playoff, setup and shooters
; screens, drawn with MenuBackMap

MenuBackTiles:						; tiles packed for DecompressLZ that screen setups send to VRAM
	db $10,$FB
	db $00,$0D,$00
	incbin "../../../Extracted/data/gfx/MenuBackTiles.chr.lz":5..1816
