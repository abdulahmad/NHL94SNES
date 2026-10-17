; Streamed sound 6 (wallcollb, the puck over the glass): a block that UpdateStreamSfx streams in

StreamSampleOverGlass:				; for SPCUploadBlock, as SampleAPower
	db $10,$86
	db $10,$86
	incbin "../../../Extracted/data/sound/StreamSampleOverGlass.spc":4..4234
