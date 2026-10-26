; A BRR sound sample, unused: it is in no sample list (Intro, Title, Menu, GameSampleList) and nothing reads
; it, so it never reaches the sound CPU

SampleUnused:						; for SPCUploadBlock, as SampleAPower
	db $0E,$22
	db $0E,$22
	incbin "../../../Extracted/data/sound/SampleUnused.spc":4..3622
