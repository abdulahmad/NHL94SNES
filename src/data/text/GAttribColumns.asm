GAttribColumns:						; goalie rating columns
	%String("   Status   ]")
	dw $0000,$0000
	%String("[  Overall  ]")
	dw $930F,$000A
	%String("[  Agility  ]")
	dw $1000,$000A
	%String("[   Speed   ]")
	dw $0800,$000A
	%String("[Glove Hand ]")
	dw $0040,$0004
	%String("[Def. Aware.]")
	dw $0200,$000A
	%String("[Puck Cont. ]")
	dw $0100,$000A
	%String("[Stick Right]")
	dw $0008,$000A
	%String("[Stick Left ]")
	dw $0004,$000A
	%String("[Glove Right]")
	dw $0002,$000A
	%String("[Glove Left ]")
	dw $0001,$000A
	%String("[   Weight   ")
	dw $2000,$0006
	dw $FFFF
