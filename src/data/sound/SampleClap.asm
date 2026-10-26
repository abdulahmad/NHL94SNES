; In-game sample 18: sound $14, a hand clap (identified by listening); the second instrument of 7 TeamSongs
; songs, set with StepTrack event $DC $6A (SongBirthday, SongBlueDanube, SongHereWeGoF, SongLetsGoClapsF,
; SongLetsGoF, SongRallyTime, SongRallyTimeAlt); StartSoundVoice gives it a fixed length

SampleClap:							; for SPCUploadBlock, as SampleCrashBack
	db $09,$CF
	db $09,$CF
	incbin "../../../Extracted/data/sound/SampleClap.spc":4..2515
