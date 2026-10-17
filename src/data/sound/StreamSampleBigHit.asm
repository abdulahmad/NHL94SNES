; Streamed sound 3 (FallDown, a big hit): a block for SPCUploadBlock that UpdateStreamSfx streams in

StreamSampleBigHit:					;for SPCUploadBlock: loop point and length (big-endian words, in bytes;
									;multiples of the 9-byte BRR block), then the BRR blocks
	db $22,$08
	db $22,$08
	incbin "../../../Extracted/data/sound/StreamSampleBigHit.spc":4..8716
