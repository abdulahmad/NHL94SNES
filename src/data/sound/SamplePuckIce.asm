; In-game sample 6: sound 7, the puck on the ice (Endfaceoff, updateplayers; 94G SFXpuckice at both) and
; doshot without the puck

SamplePuckIce:						; for SPCUploadBlock, as SamplePlayoffOrgan
	db $00,$51
	db $00,$51
	incbin "../../../Extracted/data/sound/SamplePuckIce.spc":4..85
