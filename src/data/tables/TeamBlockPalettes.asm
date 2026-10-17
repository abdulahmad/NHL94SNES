; Per team (0-27): a long pointer to the 16 colours of its team block (DrawTeamBlocks, DrawSelectTeam, PlayoffScreen);
; entry 28 is never read
TeamBlockPalettes:
	dd TeamBlockPaletteANH,TeamBlockPaletteBOS,TeamBlockPaletteBUF,TeamBlockPaletteCGY
	dd TeamBlockPaletteCHI,TeamBlockPaletteDAL,TeamBlockPaletteDET,TeamBlockPaletteEDM
	dd TeamBlockPaletteFLA,TeamBlockPaletteHFD,TeamBlockPaletteLA,TeamBlockPaletteMTL
	dd TeamBlockPaletteNJ,TeamBlockPaletteNYI,TeamBlockPaletteNYR,TeamBlockPaletteOTW
	dd TeamBlockPalettePHI,TeamBlockPalettePIT,TeamBlockPaletteQUE,TeamBlockPaletteSJ
	dd TeamBlockPaletteSTL,TeamBlockPaletteTB,TeamBlockPaletteTOR,TeamBlockPaletteVAN
	dd TeamBlockPaletteWSH,TeamBlockPaletteWPG,TeamBlockPaletteASE,TeamBlockPaletteASW
	dd TeamBlockPaletteUnused
