; Streamed sound 5 (puckbody, the puck hits a player): a block that UpdateStreamSfx streams in

StreamSamplePuckBody:				; for SPCUploadBlock, as SamplePuckGoalie
	db $0C,$21
	db $0C,$21
	incbin "../../../Extracted/data/sound/StreamSamplePuckBody.spc":4..3109
