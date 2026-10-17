; Rating columns of the shooter list
ShooterAttribColumns:				;rating columns of the shooter list: title, then a mask word and a value
									;word; $FFFF ends it
	%String("      Status]")
	dw $0000,$0000
	%String("    [Overall]")
	dw $1F3A,$000A
	%String("     [Energy]")
	dw $0000,$0002
	%String("    [Agility]")
	dw $1000,$000A
	%String("      [Speed]")
	dw $0800,$000A
	%String("     [Handed]")
	dw $0040,$0004
	%String("[Off. Aware.]")
	dw $0400,$000A
	%String("[Def. Aware.]")
	dw $0200,$000A
	%String(" [Shot Power]")
	dw $0100,$000A
	%String(" [Shot Accur]")
	dw $0010,$000A
	%String(" [Pass Accur]")
	dw $0002,$000A
	%String("[Stick Handl]")
	dw $0020,$000A
	%String("     [Weight]")
	dw $2000,$0006
	%String(" [ Endurance]")
	dw $0008,$000A
	%String(" [Aggression]")
	dw $0001,$000A
	%String("   [Checking ")
	dw $0080,$000A
	dw $FFFF
