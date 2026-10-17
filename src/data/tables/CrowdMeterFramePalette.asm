; The crowd meter box colours: SetupScreenPalette with another first row, and only that row is used:
; ShowCrowdMeter sends it to palette 5, the palette SetupScreen gives the FramerNineTile box tiles, so the box
; around the meter is gold (a gold ramp where SetupScreenPalette has greys)
CrowdMeterFramePalette:
	db $10,$FB
	db $00,$01,$00
	incbin "../../../Extracted/data/gfx/Pals/CrowdMeterFramePalette.pal.lz":5..143
