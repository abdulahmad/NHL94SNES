; Streamed sound 1 (end of a period, clockcont_0): a block for SPCUploadBlock that UpdateStreamSfx streams in

StreamSamplePeriodEnd:				; for SPCUploadBlock, as SampleCrashBack
	db $03,$F9
	db $09,$AB
	incbin "../../../Extracted/data/sound/StreamSamplePeriodEnd.spc":4..2479
