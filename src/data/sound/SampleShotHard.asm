; In-game sample 1: sound 2, doshot's shot when passspeed is $1E or more (93S SFXshothard); in the title set
; it is sample 13, the distorted guitar of TitleSong's dist tracks

SampleShotHard:						; for SPCUploadBlock, as SampleCrashBack
	db $09,$36
	db $09,$36
	incbin "../../../Extracted/data/sound/SampleShotHard.spc":4..2362
