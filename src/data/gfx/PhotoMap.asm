; The 6 x 6 player photo map (tile numbers in order) that DrawPlayerPicture uses

PhotoMap:							;a map for a player photo: width, height and a word, then 6 x 6 tile
									;numbers in order
	dw $0006,$0006,$0308
	dw $0000,$0001,$0002,$0003,$0004,$0005,$0006,$0007
	dw $0008,$0009,$000A,$000B,$000C,$000D,$000E,$000F
	dw $0010,$0011,$0012,$0013,$0014,$0015,$0016,$0017
	dw $0018,$0019,$001A,$001B,$001C,$001D,$001E,$001F
	dw $0020,$0021,$0022,$0023
	db $FF,$FF
