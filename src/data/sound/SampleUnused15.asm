; In-game sample 15, unused: only sound $10 plays it, and no code plays sound $10 (the sfx, PuckSfx,
; QueueSound and PlaySound callers pass other sounds; the replay plays back the recorded ones)

SampleUnused15:						; for SPCUploadBlock, as SampleCowbell
	db $04,$53
	db $04,$53
	incbin "../../../Extracted/data/sound/SampleUnused15.spc":4..1111
