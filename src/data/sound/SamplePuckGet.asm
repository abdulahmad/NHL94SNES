; In-game sample 2: sound 3, a player takes the puck (puckglue, puckstick; 94G SFXpuckget at puckglue)

SamplePuckGet:						; for SPCUploadBlock, as SampleCrashBack
	db $09,$B4
	db $09,$B4
	incbin "../../../Extracted/data/sound/SamplePuckGet.spc":4..2488
