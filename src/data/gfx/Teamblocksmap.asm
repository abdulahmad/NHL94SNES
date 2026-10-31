; The team block map (9 x 2 per team) that DrawTeamBlocks copies, as 93S Teamblocksmap

Teamblocksmap:						;a map, not packed: width, height and a word, then the map words (9 x 2);
									;read
	dw $0009,$0002,$0308
	dw $0001,$0002,$0003,$0004,$0005,$0007,$0008,$0009
	dw $000A,$000B,$000C,$000D,$000E,$0010,$0011,$0012
	dw $0013,$0014
