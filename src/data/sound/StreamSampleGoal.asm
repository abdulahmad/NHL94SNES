; Streamed sound 2 (Goal): a block for SPCUploadBlock that UpdateStreamSfx streams in

StreamSampleGoal:					; for SPCUploadBlock, as SampleCrowd2
	db $00,$3F
	db $11,$82
	incbin "../../../Extracted/data/sound/StreamSampleGoal.spc":4..4486
