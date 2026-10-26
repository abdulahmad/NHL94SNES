; In-game sample 16: sound $11, a skate stop (dostop; 93S SFXstop); also in the title set

SampleStop:							; for SPCUploadBlock, as SampleCrashBack
	db $08,$04
	db $08,$04
	incbin "../../../Extracted/data/sound/SampleStop.spc":4..2056
