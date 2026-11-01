; Screen titles: Wins!, Win!, Shootout, Edit Lines, and the cursors between them
WinsMark:
	%String("Wins!")
WinMark:
	%String("Win!")
ShootoutShootersPos:
	dw $0005 : db CC_Font1Pal1Pri,$00,$00
ShootoutShootersPos2:
	dw $0005 : db CC_Font1Pri,$09,$0A
LineupTxt:
	dw $0011 : db CC_Font1Pal2Pri,$0A,$0B,"   Lineup   "
DrawShootersBackPos:
	dw $0005 : db CC_Font1Pal1Pri,$00,$00
DrawShootersBackPos2:
	dw $0005 : db CC_Font1Pri,$09,$0A
LineupTxt2:
	dw $0011 : db CC_Font1Pal2Pri,$0A,$0B,"   Lineup   "
ShootoutLabel:
	%String("Shootout")
ShootersBackgroundPos:
	dw $0005 : db CC_Font1Pal1Pri,$0B,$07
PrintShooterNamesPos:
	dw $0005 : db CC_Font1Pal1Pri,$00,$0D
PrintShooterNamesPos2:
	dw $0005 : db CC_Font1Pal1Pri,$00,$0E
ShooterSelectListPos:
	dw $0005 : db CC_Font1Pal1Pri,$00,$00
PrintShooterListPos:
	dw $0005 : db CC_Font1Pal1Pri,$00,$00
PlayerTxt2:
	dw $000B : db CC_Font1Pal1Pri,$03,$02,"Player"
LeftArrowTxt3:
	dw $0006 : db CC_Font1Pal1Pri,$02,$02,"{"
RightArrowTxt3:
	dw $0006 : db CC_Font1Pal1Pri,$09,$02,"}"
PrintShooterRowsPos:
	dw $0005 : db CC_Font1Pal1Pri,$00,$03
LineEditorPos:
	dw $0005 : db CC_Font1Pal2Pri,$08,$0A
LineEditorPos2:
	dw $0005 : db CC_Font1Pri,$0B,$01
PrintLineNamesPos:
	dw $0005 : db CC_Font1Pal2Pri,$08,$0A
DrawEditLinesTopPos:
	dw $0005 : db CC_Font1Pri,$00,$00
DrawEditLinesTopPos2:
	dw $0005 : db CC_Font1Pri,$07,$09
EditLinesLabel:
	%String("Edit Lines")
