; Title / menu sample 5: the toms of the drums tracks (sounds 6, 8, $A, $C, $D, pitch bytes 4-8; confirmed by
; listening)

SampleTom:							; for SPCUploadBlock, as SampleCowbell
	db $05,$4F
	db $05,$4F
	incbin "../../../Extracted/data/sound/SampleTom.spc":4..1363
