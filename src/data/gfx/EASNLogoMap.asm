; The EASN logo map (7 x 2) that EASNLogo draws, as 93S EASNLogoMap

EASNLogoMap:						;a map, not packed: width, height and a word, then the map words (7 x 2);
									;read
	dw $0007,$0002,$0308
	dw $0401,$0402,$0403,$0404,$0405,$0406,$0401,$0401
	dw $0407,$0408,$0409,$040A,$040B,$0401
