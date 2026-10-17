; Data table.
TeamSongs:							;songs for MusicStart, six per team (long pointers, $FFFFFFFF none), by
									;home team and song slot (0 first faceoff of a period, 1 faceoff on a home
									;power play, 2 other faceoffs, 3 home goal, 4 faceoff on a home penalty
									;kill, 5 random in the third period)
	dd $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dd $FFFFFFFF,$FFFFFFFF,SongHereWeGo,SongChargeEFlat
	dd SongGoTeamGoEFlat,$FFFFFFFF,SongDefense,SongHereWeGo
	dd SongSabreDance,SongRallyTime,SongRallyTime,SongSabreDance
	dd SongDefense,$FFFFFFFF,SongOMalleysStepsG,SongBirthday
	dd SongOMalleysStepsG,SongBirthday,SongKalinka,SongKalinka
	dd SongHereComeTheHawks,SongMexicanHatDance,SongGypsySpainG,SongHereComeTheHawks
	dd SongDefense,SongHavaNagila,SongHereWeGo,SongCharge
	dd SongCharge,$FFFFFFFF,SongDefense,$FFFFFFFF
	dd SongLaRaspa,SongOMalleysSteps,SongMexicanHatDance,$FFFFFFFF
	dd SongDefense,SongOMalleysSteps,SongOMalleysStepsF,SongHereWeGo
	dd SongHereWeGo,$FFFFFFFF,SongDefense,$FFFFFFFF
	dd $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dd $FFFFFFFF,$FFFFFFFF,SongBrassBonanza,SongWilliamTell
	dd SongLetsGoC,SongWilliamTell,SongDefense,SongBrassBonanza
	dd SongOMalleysStepsC,SongOMalleysStepsC,SongMexicanHatDance,SongBirthday
	dd SongDefense,SongGoTeamGoC,SongOMalleysSteps,SongGypsySpainE
	dd SongOMalleysSteps,SongHalteLa,SongDefense,SongLetsGoClapsCOnly
	dd SongLetsGoF,SongBuildupC,SongLetsGoF,$FFFFFFFF
	dd SongDefense,SongLaRaspa,SongRallyTime,SongCharge
	dd SongRallyTime,SongIslandersCharge,SongDefense,SongIslandersCharge
	dd SongHereWeGo,SongChargeSlow,SongLetsGoF,$FFFFFFFF
	dd SongDefense,$FFFFFFFF,SongRallyTime,SongOMalleysSteps
	dd SongGypsySpainCharge,$FFFFFFFF,SongDefense,$FFFFFFFF
	dd SongLetsGoAlt,SongBuildupF,SongLetsGoAlt,SongZorba
	dd SongDefense,SongZorba,SongOMalleysStepsFast,SongLetsGoRallyTime
	dd SongOMalleysStepsFast,SongDrunkenSailor,SongDefense,SongDrunkenSailor
	dd SongLetsGoClapsC,SongKalinka,SongLetsGoClapsC,$FFFFFFFF
	dd SongDefense,SongKalinka,SongBuildupCharge,SongJaws
	dd SongLetsGoClapsF,SongBlueDanube,SongBuildupChargeF,SongHavaNagila
	dd SongSaintsGoMarchingIn,SongBuildupOMalleys,SongBuildupOMalleys,SongSaintsGoMarchingIn
	dd SongDefense,SongLetsGoClapsAlt,SongHereWeGoF,SongCavalryCharge
	dd SongCavalryCharge,$FFFFFFFF,SongDefense,$FFFFFFFF
	dd SongOMalleysStepsSlow,SongOMalleysStepsSlow,SongQuickBuildup,$FFFFFFFF
	dd SongDefense,$FFFFFFFF,SongLetsGoClapsShort,SongBuildupCharge
	dd SongChargeFanfare,$FFFFFFFF,SongDefense,$FFFFFFFF
	dd SongOMalleysSteps,SongRallyTimeAlt,SongOMalleysSteps,$FFFFFFFF
	dd SongDefense,SongOMalleysSteps,SongRallyTime,SongOMalleysSteps
	dd SongGypsySpainCharge,$FFFFFFFF,SongDefense,$FFFFFFFF
	dd $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dd $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dd $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
