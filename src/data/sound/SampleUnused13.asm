; In-game sample 13, unused: only sound $E plays it, and no code plays sound $E (the sfx, PuckSfx, QueueSound
; and PlaySound callers pass other sounds; the replay plays back the recorded ones)

SampleUnused13:						; for SPCUploadBlock, as SamplePuckGoalie
	db $0B,$52
	db $0B,$52
	incbin "../../../Extracted/data/sound/SampleUnused13.spc":4..2902
