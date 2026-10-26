; Title / menu sample 4: the closed hi-hat of the drums tracks (sounds 5 and 7; SampleOpenHat is the open one;
; confirmed by listening)

SampleClosedHat:					; for SPCUploadBlock, as SampleCowbell
	db $05,$22
	db $05,$22
	incbin "../../../Extracted/data/sound/SampleClosedHat.spc":4..1318
