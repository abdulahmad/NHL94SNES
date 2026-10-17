; An unused sprite palette, then two team block palettes (16 colours each).

UnusedSetupSpritePalette:			;SetupScreen and LoadScoutingScreen send it (a gold ramp) to sprite
									;palette 4, but no
			;   sprite on those screens is drawn in palette 4 (letters use 0, team logos 2 and 3; the player
			;   photos are background), so it never shows
	incbin "../../../Extracted/data/gfx/Pals/UnusedSetupSpritePalette.pal"
TeamBlockPaletteANH:				; the Anaheim team block colours (TeamBlockPalettes)
	incbin "../../../Extracted/data/gfx/Pals/TeamBlockPaletteANH.pal"
TeamBlockPaletteBUF:				; the Buffalo team block colours (TeamBlockPalettes)
	incbin "../../../Extracted/data/gfx/Pals/TeamBlockPaletteBUF.pal"
