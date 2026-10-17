; The colours of the player markers (the arrows and stars of each controller: SpriteFrames frames 374-395, the
; only frames in sprite palette 2): setplayercolors copies the first 16 into sprite palette 2 in the game,
; PlayerSelect into sprite palette 1; the rest is not read

PlayerMarkerPalette:
	incbin "../../../Extracted/data/gfx/Pals/PlayerMarkerPalette.pal"
