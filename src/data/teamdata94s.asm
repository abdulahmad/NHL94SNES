; Team record offsets, as in 94G teamdata94.asm
Playerdata	=	0					; offset of the player list in a team record
GoalieOdds	=	10					; offset of the starting goalie weights in a team record

; The team database (bank $9C): TeamList points to each team record; team number = index (Anaheim 0 ...
; Winnipeg 25, then the two all-star teams). A record: offsets to its parts (.0), .sr (scouting report),
; .godds (starting goalie weights), the eight lines (.ls; line 1 = the no-line-change line used when
; line changes are Off, then Sc1, Sc2, Chk, PP1, PP2, PK1, PK2), the players (.pld, Player macro: name and
; 16 rating nibbles), four Strings (city, abbreviation, nickname, arena), then playoffseats.

TeamList:							; a long pointer to each team record (team number = index)
	dd Anaheim						; 0
	dd Boston						; 1
	dd Buffalo						; 2
	dd Calgary						; 3
	dd Chicago						; 4
	dd Dallas						; 5
	dd Detroit						; 6
	dd Edmonton						; 7
	dd Florida						; 8
	dd Hartford						; 9
	dd LosAngeles					; 10
	dd Montreal						; 11
	dd NewJersey					; 12
	dd NYIslanders					; 13
	dd NYRangers					; 14
	dd Ottawa						; 15
	dd Philadelphia					; 16
	dd Pittsburgh					; 17
	dd Quebec						; 18
	dd SanJose						; 19
	dd StLouis						; 20
	dd TampaBay						; 21
	dd Toronto						; 22
	dd Vancouver					; 23
	dd Washington					; 24
	dd Winnipeg						; 25
	dd AllStarsEast					; 26
	dd AllStarsWest					; 27
AllStarsEast:						; team record: All Stars East (ASE), team 26
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $77,$20,$00,$E8,$5B
.godds:								; starting goalie weights
	db 203,192
.ls:								; player numbers (1 = the first .pld entry)
	;  -G,LD,RD,LW,-C,RW,XA,00
	db 01,19,18,07,04,16,09,00		; line 1 NLC (no line changes)
	db 01,19,18,07,04,16,10,00		; line 2 Sc1
	db 01,22,20,11,10,17,07,00		; line 3 Sc2
	db 01,23,24,05,12,14,07,00		; line 4 Chk
	db 01,19,22,07,04,16,09,00		; line 5 PP1
	db 01,18,21,08,09,17,07,00		; line 6 PP2
	db 01,19,23,13,05,06,15,00		; line 7 PK1
	db 01,24,25,15,06,05,13,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Patrick Roy", $3366,$4446,$0100,$5566)
	%Player("Grant Fuhr", $3175,$4555,$0000,$4455)
	%Player("Tom Barrasso", $35A4,$4554,$0000,$4444)
	%Player("Mario Lemieux", $66A5,$4644,$3366,$6062)
	%Player("Mark Messier", $11A5,$4443,$5453,$4053)
	%Player("Kirk Muller", $1094,$4444,$4444,$4143)
	%Player("Adam Oates", $1275,$4653,$3154,$5061)
	%Player("Joe Sakic", $1964,$4544,$2045,$5252)
	%Player("Pierre Turgeon", $7894,$4534,$3445,$5141)
	%Player("Pat LaFontaine", $1655,$4643,$3354,$6052)
	%Player("Kevin Stevens", $25B3,$4533,$3644,$5344)
	%Player("Jaromir Jagr", $68A5,$4433,$4453,$4142)
	%Player("Peter Bondra", $1364,$6433,$2044,$4232)
	%Player("Mike Gartner", $2275,$5445,$2353,$5552)
	%Player("Rick Tocchet", $2392,$2544,$3735,$4134)
	%Player("Alexnder Mogilny", $8976,$6634,$2455,$4452)
	%Player("Mark Recchi", $0865,$4534,$3445,$4143)
	%Player("Larry Murphy", $55A4,$3454,$3242,$5143)
	%Player("Ray Bourque", $77A5,$4465,$6055,$6252)
	%Player("Brian Leetch", $0266,$3444,$2651,$5252)
	%Player("Steve Duchesne", $2884,$4444,$2442,$4142)
	%Player("Al Iafrate", $34B4,$4446,$4642,$4444)
	%Player("Scott Stevens", $04B4,$4344,$5642,$5043)
	%Player("Zarley Zalapski", $03A5,$4454,$4442,$5133)
	%Player("Glen Wesley", $2685,$4344,$3641,$4442)
	dw 2							; end of the player list (an empty String)
.tn:								; city
	%String("All Stars East")
.ta:								; abbreviation
	%String("ASE")
.tm:								; nickname
	dw 2							; an empty String
.ar:								; arena
	%String("Madison Square Garden")
AllStarsWest:						; team record: All Stars West (ASW), team 27
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $77,$20,$00,$E8,$59
.godds:								; starting goalie weights
	db 237,144
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,20,22,11,04,15,14,00		; line 1 NLC (no line changes)
	db 01,24,22,11,04,15,13,00		; line 2 Sc1
	db 01,20,23,14,06,13,04,00		; line 3 Sc2
	db 01,18,21,10,08,12,04,00		; line 4 Chk
	db 01,20,19,11,09,13,04,00		; line 5 PP1
	db 01,18,22,06,04,15,09,00		; line 6 PP2
	db 01,25,21,08,12,09,17,00		; line 7 PK1
	db 01,23,24,09,17,08,12,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Ed Belfour", $3066,$4665,$0000,$6655)
	%Player("Tim Cheveldae", $3264,$4444,$0000,$4344)
	%Player("Felix Potvin", $2964,$4664,$0000,$4444)
	%Player("Steve Yzerman", $1966,$5644,$1155,$6152)
	%Player("Mike Modano", $0975,$5445,$2452,$5243)
	%Player("Jeremy Roenick", $2745,$5445,$2355,$5253)
	%Player("Brian Bradley", $2344,$3434,$3335,$4233)
	%Player("Doug Gilmour", $9345,$4554,$4444,$6043)
	%Player("Wayne Gretzky", $9946,$4542,$2262,$6060)
	%Player("Gary Roberts", $1174,$4544,$4845,$5134)
	%Player("Luc Robitaille", $2074,$4534,$2456,$5243)
	%Player("Theoren Fleury", $1435,$5454,$4743,$6133)
	%Player("Brett Hull", $1694,$4536,$3353,$4432)
	%Player("Pavel Bure", $1055,$6544,$2054,$4442)
	%Player("Teemu Selanne", $1365,$6534,$3345,$5442)
	%Player("Pat Falloon", $1874,$4323,$1342,$4531)
	%Player("Jari Kurri", $1784,$3444,$2143,$4132)
	%Player("Gary Suter", $2275,$4454,$4642,$5243)
	%Player("Jeff Brown", $2193,$3445,$2343,$5142)
	%Player("Paul Coffey", $7796,$5434,$2461,$5153)
	%Player("Chris Chelios", $0774,$4465,$4751,$6245)
	%Player("Phil Housley", $0666,$5433,$2462,$4062)
	%Player("Dave Manson", $2494,$4355,$4A41,$5434)
	%Player("Steve Smith", $05B4,$4344,$4641,$5244)
	%Player("Steve Chiasson", $0394,$3444,$3641,$4234)
	dw 2
.tn:								; city
	%String("All Stars West")
.ta:								; abbreviation
	%String("ASW")
.tm:								; nickname
	dw 2
.ar:								; arena
	%String("Madison Square Garden")
Boston:								; team record: Boston (BOS), team 1
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $41,$21,$21,$F7,$4C
.godds:								; starting goalie weights
	db 180,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,19,18,07,03,12,08,00		; line 1 NLC (no line changes)
	db 01,19,18,08,03,12,05,00		; line 2 Sc1
	db 01,20,21,07,05,13,03,00		; line 3 Sc2
	db 01,22,23,09,04,14,03,00		; line 4 Chk
	db 01,20,18,08,03,12,05,00		; line 5 PP1
	db 01,22,21,07,05,13,03,00		; line 6 PP2
	db 01,18,19,09,04,03,06,00		; line 7 PK1
	db 01,20,21,03,06,09,04,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Andy Moog", $3544,$4224,$0000,$4343)
	%Player("John Blue", $3963,$4553,$0000,$4343)
	%Player("Adam Oates", $1275,$4653,$3154,$5061)
	%Player("Dave Poulin", $1974,$3343,$4433,$4142)
	%Player("Vladimir Ruzicka", $38A4,$4334,$2643,$3332)
	%Player("Ted Donato", $2143,$4343,$3033,$3332)
	%Player("Joe Juneau", $4954,$4434,$2043,$4041)
	%Player("Dmitri Kvartalnov", $1064,$4423,$2043,$4241)
	%Player("Dave Reid", $1792,$3333,$1424,$4420)
	%Player("Gregori Pantaleyev", $1364,$4222,$1233,$2431)
	%Player("Brent Hughes", $4263,$3132,$3632,$2534)
	%Player("Cam Neely", $08A4,$4544,$4945,$5344)
	%Player("Stephen Leach", $2763,$3333,$3732,$4533)
	%Player("Stephen Heinze", $2363,$3333,$3333,$3531)
	%Player("C.J. Young", $1863,$3223,$2533,$2322)
	%Player("Darin Kimble", $2991,$1211,$2924,$1315)
	%Player("Peter Douris", $1683,$4333,$2533,$2421)
	%Player("Ray Bourque", $77A5,$4465,$6055,$6252)
	%Player("Don Sweeney", $3244,$4344,$4441,$4142)
	%Player("Glen Wesley", $2685,$4344,$3641,$4442)
	%Player("David Shaw", $3492,$2242,$3322,$4523)
	%Player("Gordie Roberts", $1473,$2231,$3423,$3023)
	%Player("Glen Feathrston", $06B3,$3222,$4823,$2324)
	%Player("Jim Wiemer", $36A2,$1221,$2820,$2324)
	dw 2
.tn:								; city
	%String("Boston")
.ta:								; abbreviation
	%String("BOS")
.tm:								; nickname
	%String("Bruins")
.ar:								; arena
	%String("Boston Garden")
Buffalo:							; team record: Buffalo (BUF), team 2
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $64,$10,$21,$D8,$49
.godds:								; starting goalie weights
	db 178,80
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,17,18,05,04,13,06,00		; line 1 NLC (no line changes)
	db 01,17,19,09,04,13,05,00		; line 2 Sc1
	db 01,18,21,11,05,15,04,00		; line 3 Sc2
	db 01,20,22,08,06,14,04,00		; line 4 Chk
	db 01,17,18,05,04,13,06,00		; line 5 PP1
	db 01,20,21,08,06,15,04,00		; line 6 PP2
	db 01,19,21,09,06,08,04,00		; line 7 PK1
	db 01,17,18,08,04,09,06,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Grant Fuhr", $3175,$4555,$0100,$4455)
	%Player("Tom Draper", $3562,$3332,$0000,$2222)
	%Player("Dominik Hasek", $3943,$3552,$0000,$2222)
	%Player("Pat LaFontaine", $1655,$4643,$3354,$6052)
	%Player("Dale Hawerchuk", $1065,$4443,$2051,$3052)
	%Player("Bob Sweeney", $2094,$2353,$4734,$4233)
	%Player("Dave Hannan", $1462,$2232,$2623,$2022)
	%Player("Randy Wood", $1981,$5332,$3622,$3423)
	%Player("Yuri Khmylev", $1374,$3344,$3134,$3332)
	%Player("Brad May", $2792,$2222,$3A23,$2514)
	%Player("Bob Errey", $1264,$4242,$4432,$4523)
	%Player("Rob Ray", $32A3,$4111,$3A22,$1514)
	%Player("Alexnder Mogilny", $8976,$6634,$2455,$4452)
	%Player("Wayne Presley", $1863,$3334,$2723,$3323)
	%Player("Donald Audette", $2853,$3333,$2933,$3523)
	%Player("Colin Patterson", $1784,$4231,$3523,$2522)
	%Player("Doug Bodger", $08A2,$3342,$3621,$4133)
	%Player("Petr Svoboda", $0754,$4343,$3640,$4033)
	%Player("Richard Smehlik", $42A3,$3343,$4431,$3032)
	%Player("Ken Sutton", $4182,$2242,$1412,$3232)
	%Player("Grant Ledyard", $0394,$3231,$3C10,$2323)
	%Player("Gord Donnelly", $3491,$2231,$3B11,$2225)
	%Player("Randy Moller", $24A3,$2212,$3921,$1124)
	%Player("Keith Carney", $0692,$3212,$3622,$1424)
	dw 2
.tn:								; city
	%String("Buffalo")
.ta:								; abbreviation
	%String("BUF")
.tm:								; nickname
	%String("Sabres")
.ar:								; arena
	%String("Memorial Auditorium")
Calgary:							; team record: Calgary (CGY), team 3
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $42,$00,$00,$C9,$4B
.godds:								; starting goalie weights
	db 197,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,15,16,06,03,11,04,00		; line 1 NLC (no line changes)
	db 01,19,16,06,03,12,04,00		; line 2 Sc1
	db 01,15,21,07,04,11,03,00		; line 3 Sc2
	db 01,17,22,09,05,14,03,00		; line 4 Chk
	db 01,15,16,06,03,12,04,00		; line 5 PP1
	db 01,22,21,04,05,11,03,00		; line 6 PP2
	db 01,15,21,07,11,06,05,00		; line 7 PK1
	db 01,22,18,06,05,07,11,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Mike Vernon", $3043,$4444,$0000,$4433)
	%Player("Jeff Reese", $3542,$3442,$0000,$2233)
	%Player("Joe Nieuwendyk", $2584,$4434,$3444,$4322)
	%Player("Robert Reichel", $2664,$4434,$2444,$3242)
	%Player("Joel Otto", $29B4,$3352,$5734,$4124)
	%Player("Gary Roberts", $1074,$4544,$4845,$5134)
	%Player("Paul Ranheim", $2884,$4343,$1343,$3431)
	%Player("Brent Ashton", $15A3,$3343,$4632,$4433)
	%Player("Chris Lindberg", $1173,$4232,$2433,$2321)
	%Player("Craig Berube", $1692,$3112,$2A11,$1414)
	%Player("Theoren Fleury", $1435,$5454,$4743,$6133)
	%Player("Sergei Makarov", $4265,$4422,$1054,$3052)
	%Player("Greg Paslawski", $2372,$2313,$2134,$2220)
	%Player("Ronnie Stern", $2282,$2212,$3723,$1324)
	%Player("Gary Suter", $2075,$4454,$4642,$5243)
	%Player("Al MacInnis", $0284,$4436,$3541,$5243)
	%Player("Roger Johansson", $3474,$3222,$3431,$2332)
	%Player("Trent Yawney", $1873,$2242,$3630,$3133)
	%Player("Frank Musil", $0394,$4232,$3621,$3523)
	%Player("Michel Petit", $0793,$3234,$3941,$3333)
	%Player("Kevin Dahl", $0472,$3242,$3331,$3132)
	%Player("Chris Dahlquist", $0583,$3143,$3431,$3523)
	%Player("Greg Smyth", $06A0,$0100,$1901,$1404)
	dw 2
.tn:								; city
	%String("Calgary")
.ta:								; abbreviation
	%String("CGY")
.tm:								; nickname
	%String("Flames")
.ar:								; arena
	%String("Olympic Saddledome")
Chicago:							; team record: Chicago (CHI), team 4
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $20,$10,$21,$E8,$4E
.godds:								; starting goalie weights
	db 228,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,18,17,07,03,11,05,00		; line 1 NLC (no line changes)
	db 01,18,17,07,03,11,04,00		; line 2 Sc1
	db 01,19,20,09,04,13,03,00		; line 3 Sc2
	db 01,21,23,10,05,12,03,00		; line 4 Chk
	db 01,18,17,07,03,11,04,00		; line 5 PP1
	db 01,19,20,04,05,13,03,00		; line 6 PP2
	db 01,18,17,05,11,03,12,00		; line 7 PK1
	db 01,20,22,03,12,05,11,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Ed Belfour", $3066,$4665,$0000,$6655)
	%Player("Jim Waite", $2963,$3332,$0000,$2233)
	%Player("Jeremy Roenick", $2745,$5445,$2355,$5253)
	%Player("Christan Ruuttu", $2284,$4343,$4442,$4243)
	%Player("Brent Sutter", $1263,$2453,$4343,$5133)
	%Player("Troy Murray", $1984,$3242,$4331,$3533)
	%Player("Michel Goulet", $1684,$3332,$2635,$3312)
	%Player("Stephane Matteau", $3282,$2321,$3623,$3213)
	%Player("Greg Gilbert", $1472,$2332,$4633,$3112)
	%Player("Jocelyn Lemieux", $2693,$4334,$2622,$2213)
	%Player("Steve Larmer", $2874,$4464,$4444,$6342)
	%Player("Dirk Graham", $3384,$3353,$4732,$4534)
	%Player("Brian Noonan", $1073,$3334,$3343,$4533)
	%Player("Dave Christian", $2583,$3233,$2331,$3231)
	%Player("Joe Murphy", $1774,$4434,$3233,$4243)
	%Player("Rob Brown", $4464,$3322,$2841,$2024)
	%Player("Chris Chelios", $0774,$4465,$4751,$6245)
	%Player("Steve Smith", $05B4,$4344,$4641,$5244)
	%Player("Bryan Marchment", $0283,$3242,$4621,$3215)
	%Player("Frantsek Kucera", $0692,$2243,$1321,$3422)
	%Player("Craig Muni", $0392,$2132,$4620,$4223)
	%Player("Keith Brown", $0472,$2232,$3931,$3433)
	%Player("Cam Russell", $0853,$3132,$3431,$3524)
	%Player("Adam Bennett", $4792,$2111,$2520,$1412)
	dw 2
.tn:								; city
	%String("Chicago")
.ta:								; abbreviation
	%String("CHI")
.tm:								; nickname
	%String("Blackhawks")
.ar:								; arena
	%String("Chicago Stadium")
Detroit:							; team record: Detroit (DET), team 6
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $73,$21,$00,$F8,$4B
.godds:								; starting goalie weights
	db 212,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,19,18,04,03,13,08,00		; line 1 NLC (no line changes)
	db 01,21,25,11,03,13,04,00		; line 2 Sc1
	db 01,18,23,08,04,14,03,00		; line 3 Sc2
	db 01,19,20,09,05,15,03,00		; line 4 Chk
	db 01,18,20,08,03,13,15,00		; line 5 PP1
	db 01,19,21,15,04,14,03,00		; line 6 PP2
	db 01,19,23,08,04,03,05,00		; line 7 PK1
	db 01,21,25,05,03,08,04,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Tim Cheveldae", $3264,$4444,$0000,$4344)
	%Player("Vincent Riendeau", $3763,$3222,$0000,$3223)
	%Player("Steve Yzerman", $1966,$5644,$1155,$6152)
	%Player("Sergei Fedorov", $9175,$4444,$3254,$4153)
	%Player("Dallas Drake", $2844,$4343,$2033,$4133)
	%Player("Mike Sillinger", $2373,$3332,$2332,$4021)
	%Player("Vachslav Kozlov", $1354,$3223,$1233,$3533)
	%Player("Paul Ysebaert", $2174,$4443,$2644,$3342)
	%Player("Shawn Burr", $1162,$2332,$4622,$3123)
	%Player("Keith Primeau", $55B3,$3343,$1624,$3124)
	%Player("Gerard Gallant", $1762,$2333,$4633,$3134)
	%Player("John Ogrodnick", $2593,$3333,$3234,$2130)
	%Player("Dino Ciccarelli", $2255,$4425,$2355,$4143)
	%Player("Ray Sheppard", $2662,$2433,$3334,$3222)
	%Player("Bob Probert", $24B4,$3333,$4A22,$4235)
	%Player("Sheldon Kennedy", $1543,$3322,$2324,$2522)
	%Player("Jim Hiller", $1472,$2212,$3722,$1424)
	%Player("Paul Coffey", $7796,$5434,$2461,$5153)
	%Player("Steve Chiasson", $0394,$3444,$3641,$4234)
	%Player("Yves Racine", $3363,$3344,$3431,$4233)
	%Player("Nicklas Lidstrom", $0554,$3344,$3441,$4241)
	%Player("Mark Howe", $0463,$3343,$3231,$3031)
	%Player("Vladimir Konstantov", $1663,$3243,$4731,$4233)
	%Player("Steve Konroyd", $0883,$3232,$4421,$3233)
	%Player("Brad McCrimmon", $0283,$2242,$4610,$3133)
	dw 2
.tn:								; city
	%String("Detroit")
.ta:								; abbreviation
	%String("DET")
.tm:								; nickname
	%String("Red Wings")
.ar:								; arena
	%String("Joe Louis Arena")
Edmonton:							; team record: Edmonton (EDM), team 7
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $16,$02,$12,$E8,$43
.godds:								; starting goalie weights
	db 208,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,16,17,08,02,14,09,00		; line 1 NLC (no line changes)
	db 01,16,17,09,02,14,03,00		; line 2 Sc1
	db 01,19,18,08,03,15,02,00		; line 3 Sc2
	db 01,20,21,10,11,04,02,00		; line 4 Chk
	db 01,16,17,09,08,14,06,00		; line 5 PP1
	db 01,20,18,10,06,15,09,00		; line 6 PP2
	db 01,16,18,08,04,11,02,00		; line 7 PK1
	db 01,19,21,11,02,08,04,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Bill Ranford", $3044,$3334,$0000,$4454)
	%Player("Doug Weight", $3963,$3343,$3443,$3132)
	%Player("Todd Elik", $3473,$4332,$2433,$3123)
	%Player("Craig MacTavish", $1484,$3242,$4432,$5223)
	%Player("Kevin Todd", $1553,$4333,$3632,$3332)
	%Player("Shjon Podein", $2692,$2322,$2624,$2512)
	%Player("Mike Hudson", $2093,$3242,$4820,$3233)
	%Player("Shayne Corson", $0994,$4343,$4642,$4234)
	%Player("Craig Simpson", $1883,$3434,$2345,$3132)
	%Player("Zdeno Ciger", $0874,$3333,$2033,$3230)
	%Player("Kelly Buchberger", $16A2,$2232,$4A13,$3213)
	%Player("Martin Gelinas", $0783,$3223,$2432,$2422)
	%Player("Louie DeBrusk", $29C1,$1212,$3C14,$1515)
	%Player("Petr Klima", $8575,$5324,$1355,$4533)
	%Player("Steven Rice", $12B2,$2212,$1321,$1223)
	%Player("Dave Manson", $2494,$4355,$4A41,$5434)
	%Player("Igor Kravchuk", $2194,$3343,$3242,$4432)
	%Player("Brian Benning", $1982,$2343,$3622,$4234)
	%Player("Geoff Smith", $2594,$3231,$1431,$3231)
	%Player("Brian Glynn", $06B3,$3234,$3421,$4323)
	%Player("Luke Richardson", $22B3,$3132,$4630,$2434)
	%Player("Chris Joseph", $02A3,$3313,$3531,$1233)
	%Player("Brad Werenka", $3693,$3223,$2633,$2523)
	dw 2
.tn:								; city
	%String("Edmonton")
.ta:								; abbreviation
	%String("EDM")
.tm:								; nickname
	%String("Oilers")
.ar:								; arena
	%String("Northlands Coliseum")
Hartford:							; team record: Hartford (HFD), team 9
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $17,$02,$00,$E6,$42
.godds:								; starting goalie weights
	db 163,96
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,18,19,08,04,13,05,00		; line 1 NLC (no line changes)
	db 01,18,23,08,04,13,06,00		; line 2 Sc1
	db 01,21,19,10,06,14,04,00		; line 3 Sc2
	db 01,20,22,09,05,15,04,00		; line 4 Chk
	db 01,18,19,08,04,13,05,00		; line 5 PP1
	db 01,20,21,09,05,06,04,00		; line 6 PP2
	db 01,20,19,15,14,08,04,00		; line 7 PK1
	db 01,18,23,08,04,15,14,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Sean Burke", $01A4,$3224,$0000,$4444)
	%Player("Mario Gosselin", $3132,$3442,$0000,$1122)
	%Player("Frank Pietrngelo", $4063,$3113,$0000,$2222)
	%Player("Andrew Cassels", $2173,$3442,$2034,$4032)
	%Player("Mikael Nylander", $3654,$3323,$2232,$3132)
	%Player("Robert Kron", $3853,$3342,$2233,$3432)
	%Player("Robert Petrovicky", $3954,$3223,$2231,$3433)
	%Player("Geoff Sanderson", $0864,$4434,$2044,$4331)
	%Player("Patrick Poulin", $24A3,$3323,$3033,$3232)
	%Player("Yvon Corriveau", $1182,$2232,$3812,$3311)
	%Player("Jim McKenzie", $3392,$2112,$2422,$2314)
	%Player("Randy Cunnyworth", $0762,$3232,$3622,$3533)
	%Player("Pat Verbeek", $1673,$4434,$3744,$4244)
	%Player("Mark Janssens", $22B3,$3333,$4633,$4124)
	%Player("Nick Kypreos", $2082,$2221,$3624,$3415)
	%Player("Mark Greig", $1771,$1210,$1511,$1013)
	%Player("Jamie Leach", $3483,$3212,$3923,$1520)
	%Player("Zarley Zalapski", $03A5,$4454,$4442,$5133)
	%Player("Eric Weinrich", $04A3,$4343,$3432,$4133)
	%Player("Adam Burt", $0674,$3234,$3441,$4334)
	%Player("Dan Keczmer", $3772,$2231,$1622,$2513)
	%Player("Doug Houda", $2772,$2122,$2921,$2414)
	%Player("Allen Pedersen", $41A2,$3132,$3621,$2123)
	dw 2
.tn:								; city
	%String("Hartford")
.ta:								; abbreviation
	%String("HFD")
.tm:								; nickname
	%String("Whalers")
.ar:								; arena
	%String("Hartford Civic Center")
LosAngeles:							; team record: Los Angeles (LA), team 10
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $66,$12,$11,$C9,$4A
.godds:								; starting goalie weights
	db 150,32
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,16,17,08,04,12,05,00		; line 1 NLC (no line changes)
	db 01,16,18,08,04,12,05,00		; line 2 Sc1
	db 01,17,20,09,05,13,04,00		; line 3 Sc2
	db 01,19,21,10,06,14,04,00		; line 4 Chk
	db 01,18,16,08,04,13,05,00		; line 5 PP1
	db 01,19,17,09,05,12,04,00		; line 6 PP2
	db 01,20,17,09,14,04,13,00		; line 7 PK1
	db 01,18,21,04,13,09,14,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Kelly Hrudey", $3263,$3444,$0000,$2223)
	%Player("Robb Stauber", $3562,$3553,$0000,$2222)
	%Player("Rick Knickle", $0122,$3332,$0000,$2221)
	%Player("Wayne Gretzky", $9946,$4542,$2262,$6060)
	%Player("Jimmy Carson", $1294,$4434,$2345,$4241)
	%Player("Corey Millen", $2343,$4432,$1534,$3333)
	%Player("Gary Shuchuk", $1462,$2201,$2322,$0322)
	%Player("Luc Robitaille", $2074,$4534,$2456,$5243)
	%Player("Tony Granato", $2164,$5443,$3334,$3334)
	%Player("Pat Conacher", $1572,$2222,$2423,$2431)
	%Player("Warren Rychel", $1072,$2211,$3612,$1515)
	%Player("Tomas Sandstrom", $0794,$4535,$3845,$3233)
	%Player("Jari Kurri", $1784,$3444,$2143,$4132)
	%Player("Mike Donnelly", $1164,$4432,$3423,$4332)
	%Player("Dave Taylor", $1873,$2233,$3532,$3323)
	%Player("Rob Blake", $04B4,$4444,$3341,$4344)
	%Player("Marty McSorley", $33C3,$3343,$3932,$4436)
	%Player("Alexei Zhitnik", $0254,$4343,$3432,$4133)
	%Player("Darryl Sydor", $2593,$3233,$3431,$3232)
	%Player("Charlie Huddy", $22A3,$2243,$3431,$3132)
	%Player("Mark Hardy", $2483,$3231,$3620,$2123)
	%Player("Brent Thompson", $0352,$2121,$2820,$2114)
	%Player("Tim Watters", $0562,$2121,$2620,$2122)
	%Player("Rene Chapdlaine", $0881,$1010,$1510,$1313)
	dw 2
.tn:								; city
	%String("Los Angeles")
.ta:								; abbreviation
	%String("LA")
.tm:								; nickname
	%String("Kings")
.ar:								; arena
	%String("Great Western Forum")
Dallas:								; team record: Dallas (DAL), team 5
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $14,$10,$00,$D9,$43
.godds:								; starting goalie weights
	db 181,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,16,17,04,03,10,11,00		; line 1 NLC (no line changes)
	db 01,16,19,03,11,15,04,00		; line 2 Sc1
	db 01,18,20,07,04,13,11,00		; line 3 Sc2
	db 01,21,17,08,05,10,11,00		; line 4 Chk
	db 01,16,17,11,03,10,04,00		; line 5 PP1
	db 01,21,18,07,04,12,10,00		; line 6 PP2
	db 01,23,19,05,10,07,08,00		; line 7 PK1
	db 01,16,20,07,08,05,10,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Jon Casey", $3024,$3443,$0000,$2234)
	%Player("Darcy Wakaluk", $3562,$3333,$0000,$2232)
	%Player("Mike Modano", $0975,$5445,$2452,$5243)
	%Player("Dave Gagner", $1564,$4443,$2444,$4244)
	%Player("Neal Broten", $0744,$4353,$3032,$4341)
	%Player("Brent Gilchrist", $4164,$3223,$2042,$2532)
	%Player("Mike McPhee", $1794,$3333,$4422,$4422)
	%Player("Gaetan Duchesne", $1093,$4232,$3423,$3511)
	%Player("Brian Propp", $1683,$3323,$3632,$2530)
	%Player("Russ Courtnall", $2665,$6424,$2133,$3432)
	%Player("Ulf Dahlen", $2283,$4433,$2044,$4330)
	%Player("Mike Craig", $2063,$3333,$3743,$3223)
	%Player("Trent Klatt", $2992,$2312,$1521,$1122)
	%Player("Shane Churla", $2791,$2221,$2922,$2125)
	%Player("Stewart Gavin", $1273,$3221,$2022,$2513)
	%Player("Mark Tinordi", $2493,$3344,$4433,$4224)
	%Player("Tommy Sjodin", $3364,$3334,$2131,$3331)
	%Player("Jim Johnson", $0672,$3242,$3631,$4143)
	%Player("Derian Hatcher", $0293,$2232,$2421,$4224)
	%Player("Craig Ludwig", $03C2,$2132,$3420,$3424)
	%Player("Richard Matvichuk", $0472,$3133,$3630,$3522)
	%Player("Mark Osiecki", $2392,$2122,$2520,$1312)
	%Player("Brad Berry", $0572,$2032,$3420,$3514)
	%Player("Enrico Ciccone", $3991,$1022,$2820,$3525)
	dw 2
.tn:								; city
	%String("Dallas")
.ta:								; abbreviation
	%String("DAL")
.tm:								; nickname
	%String("Stars")
.ar:								; arena
	%String("Dallas Arena")
Montreal:							; team record: Montreal (MTL), team 11
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $52,$11,$21,$E8,$49
.godds:								; starting goalie weights
	db 197,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,18,17,07,03,12,04,00		; line 1 NLC (no line changes)
	db 01,23,18,07,03,12,04,00		; line 2 Sc1
	db 01,22,17,08,04,14,03,00		; line 3 Sc2
	db 01,19,20,09,05,13,03,00		; line 4 Chk
	db 01,18,17,07,03,12,05,00		; line 5 PP1
	db 01,19,20,08,04,05,03,00		; line 6 PP2
	db 01,17,23,07,06,03,13,00		; line 7 PK1
	db 01,22,19,03,13,07,06,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Patrick Roy", $3366,$4446,$0000,$5566)
	%Player("Andre Racicot", $3742,$3333,$0000,$2222)
	%Player("Kirk Muller", $1194,$4444,$4444,$4143)
	%Player("Stephan Lebeau", $4754,$4433,$2145,$4031)
	%Player("Denis Savard", $1855,$4433,$2353,$3043)
	%Player("Guy Carbonneau", $2164,$3242,$4141,$3341)
	%Player("Vincent Damphousse", $2564,$4433,$2053,$4243)
	%Player("Gilbert Dionne", $4583,$4333,$2433,$3232)
	%Player("John Leclair", $17B3,$4333,$3033,$3222)
	%Player("Benoit Brunet", $2262,$2322,$2223,$2222)
	%Player("Mario Roberge", $3261,$1112,$3813,$1314)
	%Player("Brian Bellows", $2384,$4434,$2344,$4242)
	%Player("Mike Keane", $1253,$4432,$3323,$3033)
	%Player("Gary Leeman", $2654,$4323,$2933,$3232)
	%Player("Todd Ewen", $36B1,$1211,$3712,$2314)
	%Player("Ed Ronan", $3182,$2212,$3322,$1421)
	%Player("Eric Desjardins", $2894,$3343,$4342,$4233)
	%Player("Matt Schneider", $2773,$4333,$3442,$4243)
	%Player("Patrice Brisebois", $4353,$3333,$3722,$4323)
	%Player("Kevin Haller", $1462,$2231,$2612,$4523)
	%Player("Rob Ramage", $0593,$2233,$4731,$3534)
	%Player("J.J. Daigneault", $4864,$3244,$3432,$4422)
	%Player("Lyle Odelein", $2493,$2242,$3620,$3324)
	%Player("Donald Dufresne", $3492,$2122,$3921,$2313)
	dw 2
.tn:								; city
	%String("Montreal")
.ta:								; abbreviation
	%String("MTL")
.tm:								; nickname
	%String("Canadiens")
.ar:								; arena
	%String("Montreal Forum")
NewJersey:							; team record: New Jersey (NJ), team 12
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $34,$11,$12,$F7,$44
.godds:								; starting goalie weights
	db 152,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,19,18,12,03,13,08,00		; line 1 NLC (no line changes)
	db 01,18,21,08,04,12,03,00		; line 2 Sc1
	db 01,19,23,07,03,15,04,00		; line 3 Sc2
	db 01,20,22,09,05,13,04,00		; line 4 Chk
	db 01,18,20,12,05,13,07,00		; line 5 PP1
	db 01,22,21,08,09,07,13,00		; line 6 PP2
	db 01,18,22,07,17,08,03,00		; line 7 PK1
	db 01,20,19,08,03,07,17,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Chris Terreri", $3124,$4443,$0000,$3333)
	%Player("Craig Billington", $0143,$4221,$0000,$2222)
	%Player("Alexnder Semak", $2064,$3443,$3144,$3242)
	%Player("Bernie Nicholls", $1963,$3433,$1342,$3043)
	%Player("Peter Stastny", $2694,$3343,$3044,$3241)
	%Player("Janne Ojanen", $3492,$2322,$2222,$2232)
	%Player("Valeri Zelepukin", $2564,$4433,$1043,$3143)
	%Player("John MacLean", $1593,$3344,$3733,$4423)
	%Player("Bobby Holik", $16A3,$4333,$3333,$4533)
	%Player("Tom Chorske", $0992,$2321,$2332,$2232)
	%Player("Troy Mallette", $08A2,$2221,$1824,$1313)
	%Player("Stephane Richer", $4494,$4435,$2143,$4432)
	%Player("Claude Lemieux", $22B4,$4434,$3732,$4334)
	%Player("Bill Guerin", $1292,$2323,$2333,$2323)
	%Player("Randy McKay", $2162,$2222,$2922,$3424)
	%Player("Scott Pellerin", $1862,$3332,$2623,$2223)
	%Player("Dave Barr", $1183,$3233,$3323,$3222)
	%Player("Scott Stevens", $04B4,$4344,$5642,$5043)
	%Player("Vachslav Fetisov", $02B4,$2244,$4441,$3044)
	%Player("Bruce Driver", $2363,$3342,$3432,$4232)
	%Player("Scott Niedrmayer", $2793,$3333,$3432,$3132)
	%Player("Ken Daneyko", $03A2,$2141,$4620,$4414)
	%Player("Tommy Albelin", $0673,$2232,$2230,$3322)
	%Player("Myles O'Connor", $0571,$1011,$1210,$1303)
	dw 2
.tn:								; city
	%String("New Jersey")
.ta:								; abbreviation
	%String("NJ")
.tm:								; nickname
	%String("Devils")
.ar:								; arena
	%String("Meadowlands Arena")
NYIslanders:						; team record: New York (NYI), team 13
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $53,$21,$00,$D8,$42
.godds:								; starting goalie weights
	db 144,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,16,15,08,02,03,10,00		; line 1 NLC (no line changes)
	db 01,20,17,08,02,11,03,00		; line 2 Sc1
	db 01,15,16,09,03,12,02,00		; line 3 Sc2
	db 01,18,19,10,06,13,02,00		; line 4 Chk
	db 01,15,19,08,02,09,03,00		; line 5 PP1
	db 01,18,17,06,03,11,08,00		; line 6 PP2
	db 01,20,18,12,11,03,13,00		; line 7 PK1
	db 01,15,22,03,13,11,12,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Glenn Healy", $3552,$4442,$0000,$2222)
	%Player("Pierre Turgeon", $7794,$4534,$3445,$5141)
	%Player("Benoit Hogue", $3374,$5433,$2445,$4143)
	%Player("Marty McInnis", $1843,$3322,$2333,$3022)
	%Player("Travis Green", $3982,$2322,$3121,$2322)
	%Player("Ray Ferraro", $2063,$3334,$2643,$4333)
	%Player("Claude Loiselle", $1083,$2211,$3833,$1524)
	%Player("Steve Thomas", $3264,$4433,$4433,$4243)
	%Player("Derek King", $2793,$2434,$1445,$4222)
	%Player("Dave Volek", $2564,$4322,$1242,$4532)
	%Player("Patrick Flatley", $2683,$2432,$3342,$4042)
	%Player("Brian Mullen", $1663,$3333,$2433,$4531)
	%Player("Brad Dalgarno", $15B1,$2321,$1524,$2123)
	%Player("Mick Vukota", $1282,$3111,$1911,$2414)
	%Player("Vladimir Malakhov", $23A3,$3434,$3432,$4233)
	%Player("Darius Kasparitis", $1174,$3233,$4431,$3234)
	%Player("Jeff Norton", $0883,$3432,$2422,$4132)
	%Player("Uwe Krupp", $04E2,$2343,$3322,$4132)
	%Player("Tom Kurvers", $2883,$3434,$2631,$4132)
	%Player("Scott Lachance", $0782,$2243,$3432,$4133)
	%Player("Dennis Vaske", $37A1,$1212,$2611,$1113)
	%Player("Richard Pilon", $4793,$3123,$3821,$2515)
	dw 2
.tn:								; city
	%String("New York")
.ta:								; abbreviation
	%String("NYI")
.tm:								; nickname
	%String("Islanders")
.ar:								; arena
	%String("Nassau Coliseum")
NYRangers:							; team record: New York (NYR), team 14
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $34,$11,$11,$E7,$4A
.godds:								; starting goalie weights
	db 144,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,17,16,06,02,10,07,00		; line 1 NLC (no line changes)
	db 01,16,19,07,02,11,05,00		; line 2 Sc1
	db 01,17,20,06,05,12,02,00		; line 3 Sc2
	db 01,18,22,08,03,10,02,00		; line 4 Chk
	db 01,16,17,11,02,10,04,00		; line 5 PP1
	db 01,18,21,07,04,12,10,00		; line 6 PP2
	db 01,16,19,07,02,04,03,00		; line 7 PK1
	db 01,17,20,04,03,07,02,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Mike Richter", $3573,$4443,$0000,$4444)
	%Player("Mark Messier", $11A5,$4443,$5453,$4053)
	%Player("Sergei Nemchinov", $1364,$3353,$4034,$5232)
	%Player("Darren Turcotte", $0864,$4433,$2443,$4432)
	%Player("Ed Olczyk", $1294,$3334,$2443,$3442)
	%Player("Esa Tikkanen", $1095,$5344,$5442,$4443)
	%Player("Adam Graves", $0964,$4432,$3633,$4534)
	%Player("Phil Bourque", $2982,$4232,$4832,$3222)
	%Player("Jan Erixon", $2083,$3232,$2233,$3031)
	%Player("Mike Gartner", $2275,$5445,$2353,$5552)
	%Player("Tony Amonte", $3364,$4433,$1333,$4332)
	%Player("Alexei Kovalev", $2774,$3333,$1034,$3433)
	%Player("Paul Broten", $3771,$1231,$2312,$2312)
	%Player("Joey Kocur", $2682,$1132,$3921,$2424)
	%Player("Mike Hartman", $1872,$3101,$3611,$1514)
	%Player("Brian Leetch", $0266,$3444,$2651,$5252)
	%Player("James Patrick", $0394,$4344,$4341,$4243)
	%Player("Sergei Zubov", $2173,$3343,$3332,$3130)
	%Player("Jeff Beukeboom", $23B2,$2242,$3720,$3024)
	%Player("Kevin Lowe", $0484,$3243,$4241,$3133)
	%Player("Peter Andersson", $0592,$3322,$2231,$2432)
	%Player("Jay Wells", $24A2,$2222,$3620,$2124)
	dw 2
.tn:								; city
	%String("New York")
.ta:								; abbreviation
	%String("NYR")
.tm:								; nickname
	%String("Rangers")
.ar:								; arena
	%String("Madison Square Garden")
Ottawa:								; team record: Ottawa (OTW), team 15
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $07,$02,$13,$F8,$37
.godds:								; starting goalie weights
	db 197,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,20,19,10,03,15,11,00		; line 1 NLC (no line changes)
	db 01,20,19,10,03,15,07,00		; line 2 Sc1
	db 01,22,25,12,07,17,03,00		; line 3 Sc2
	db 01,21,23,11,04,16,03,00		; line 4 Chk
	db 01,20,19,15,03,16,05,00		; line 5 PP1
	db 01,23,22,10,05,08,16,00		; line 6 PP2
	db 01,19,23,06,07,12,04,00		; line 7 PK1
	db 01,20,25,12,04,07,06,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Peter Sidorkwicz", $3162,$3112,$0000,$2222)
	%Player("Daniel Berthiaume", $3213,$3112,$0000,$2222)
	%Player("Jamie Baker", $1373,$3333,$2433,$4232)
	%Player("Mark Lamb", $0764,$3242,$3031,$3333)
	%Player("Neil Brady", $1292,$2332,$2622,$3133)
	%Player("Mark Freer", $1162,$2332,$2423,$4322)
	%Player("Laurie Boschman", $1664,$2242,$3432,$3523)
	%Player("David Archibald", $1572,$2232,$1622,$3522)
	%Player("Rob Murphy", $1891,$2222,$3621,$2412)
	%Player("Sylvain Turgeon", $6194,$4333,$2432,$3523)
	%Player("Mike Peluso", $4492,$2232,$3A13,$3525)
	%Player("Doug Smail", $0953,$3232,$2621,$2423)
	%Player("Jeff Lazaro", $2863,$3312,$2833,$1522)
	%Player("Darcy Loewen", $1062,$2122,$1612,$2424)
	%Player("Bob Kudelski", $2693,$3333,$2334,$3432)
	%Player("Jody Hull", $1792,$2332,$3122,$3321)
	%Player("Andrew McBain", $2092,$2332,$3522,$2122)
	%Player("Tomas Jelinek", $2572,$2222,$1632,$2513)
	%Player("Norm Maciver", $2263,$3443,$3022,$4133)
	%Player("Brad Shaw", $0473,$2333,$2331,$3232)
	%Player("Darren Rumble", $3492,$2232,$3420,$3423)
	%Player("Chris Luongo", $2362,$2131,$1320,$2423)
	%Player("Ken Hammond", $0573,$2132,$3621,$3513)
	%Player("Gord Dineen", $0681,$1221,$2311,$2513)
	%Player("Brad Marsh", $14B2,$2031,$3610,$2522)
	dw 2
.tn:								; city
	%String("Ottawa")
.ta:								; abbreviation
	%String("OTW")
.tm:								; nickname
	%String("Senators")
.ar:								; arena
	%String("Ottawa Civic Center")
Philadelphia:						; team record: Philadelphia (PHI), team 16
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $36,$02,$22,$D7,$45
.godds:								; starting goalie weights
	db 134,48
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,18,17,05,04,14,15,00		; line 1 NLC (no line changes)
	db 01,18,17,10,04,14,08,00		; line 2 Sc1
	db 01,20,22,08,05,15,04,00		; line 3 Sc2
	db 01,19,21,11,06,16,04,00		; line 4 Chk
	db 01,17,19,05,04,14,06,00		; line 5 PP1
	db 01,20,18,10,06,15,04,00		; line 6 PP2
	db 01,17,22,08,14,10,05,00		; line 7 PK1
	db 01,20,18,10,05,08,14,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Tommy Soderstrom", $3034,$4554,$0000,$3434)
	%Player("Dominic Roussel", $3363,$3333,$0000,$3322)
	%Player("Steph Beauregard", $3572,$3001,$0100,$2222)
	%Player("Eric Lindros", $88C4,$3444,$5946,$5244)
	%Player("Rod BrindAmour", $1794,$3444,$3444,$4243)
	%Player("Pelle Eklund", $0955,$4433,$3243,$4041)
	%Player("Josef Beranek", $4263,$3332,$1033,$3433)
	%Player("Keith Acton", $2542,$2243,$4032,$4232)
	%Player("Vachslav Butsayev", $2262,$2222,$2620,$2123)
	%Player("Brent Fedyk", $1882,$2433,$3323,$3122)
	%Player("Doug Evans", $1562,$2222,$2423,$2223)
	%Player("Dave Snuggerud", $1473,$3222,$2631,$2531)
	%Player("Claude Boivin", $1091,$1212,$2814,$1214)
	%Player("Mark Recchi", $0865,$4534,$3445,$4143)
	%Player("Kevin Dineen", $1174,$5342,$2733,$4534)
	%Player("Dave Brown", $2191,$1021,$2910,$2513)
	%Player("Garry Galley", $0372,$2342,$3631,$3233)
	%Player("Dimitri Yushkevich", $0274,$3343,$2431,$4333)
	%Player("Greg Hawgood", $2074,$3333,$2432,$3133)
	%Player("Terry Carkner", $29A2,$2232,$3621,$3024)
	%Player("Ric Nattress", $05A2,$2332,$2523,$3322)
	%Player("Ryan McGill", $2782,$2232,$2721,$3414)
	%Player("Shawn Cronin", $44A1,$1111,$2C13,$1513)
	dw 2
.tn:								; city
	%String("Philadelphia")
.ta:								; abbreviation
	%String("PHI")
.tm:								; nickname
	%String("Flyers")
.ar:								; arena
	%String("Spectrum")
Pittsburgh:							; team record: Pittsburgh (PIT), team 17
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $71,$20,$21,$D9,$4B
.godds:								; starting goalie weights
	db 197,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,16,17,07,03,10,11,00		; line 1 NLC (no line changes)
	db 01,16,17,07,03,10,04,00		; line 2 Sc1
	db 01,20,18,09,04,11,03,00		; line 3 Sc2
	db 01,22,19,08,05,12,03,00		; line 4 Chk
	db 01,16,19,07,03,10,12,00		; line 5 PP1
	db 01,22,17,04,12,11,03,00		; line 6 PP2
	db 01,16,17,11,03,04,12,00		; line 7 PK1
	db 01,22,21,04,12,03,11,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Tom Barrasso", $35A4,$4554,$0100,$4444)
	%Player("Ken Wregget", $3182,$3442,$0000,$3232)
	%Player("Mario Lemieux", $66A5,$4644,$3366,$6062)
	%Player("Ron Francis", $1094,$3444,$4443,$4042)
	%Player("Shawn McEachern", $1573,$3333,$2433,$4332)
	%Player("Mike Stapleton", $2663,$2222,$2121,$2530)
	%Player("Kevin Stevens", $25B3,$4533,$3644,$5344)
	%Player("Dave Tippett", $1462,$3232,$2422,$3122)
	%Player("Jeff Daniels", $2092,$2122,$2623,$2421)
	%Player("Jaromir Jagr", $68A5,$4433,$4453,$4142)
	%Player("Rick Tocchet", $2292,$2544,$3735,$4134)
	%Player("Joe Mullen", $0764,$3433,$3145,$4230)
	%Player("Martin Straka", $8253,$3322,$2222,$2032)
	%Player("Mike Needham", $3962,$2222,$2523,$2521)
	%Player("Jay Caufield", $16E1,$2011,$3B10,$1314)
	%Player("Larry Murphy", $55A4,$3454,$3342,$5143)
	%Player("Ulf Samuelsson", $0584,$4353,$5630,$4135)
	%Player("Jim Paek", $0282,$3222,$2421,$3122)
	%Player("Paul Stanton", $2383,$3234,$3321,$3543)
	%Player("Peter Taglianeti", $3292,$2233,$4430,$4324)
	%Player("Mike Ramsey", $0683,$2232,$3622,$3122)
	%Player("Kjell Samuelsson", $28E2,$2134,$4731,$4523)
	%Player("Grant Jennings", $0392,$2132,$3820,$2313)
	%Player("Bryan Fogarty", $3381,$1211,$2220,$1011)
	dw 2
.tn:								; city
	%String("Pittsburgh")
.ta:								; abbreviation
	%String("PIT")
.tm:								; nickname
	%String("Penguins")
.ar:								; arena
	%String("Civic Arena")
Quebec:								; team record: Quebec (QUE), team 18
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $75,$21,$00,$D8,$47
.godds:								; starting goalie weights
	db 166,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,17,16,03,12,13,15,00		; line 1 NLC (no line changes)
	db 01,17,16,07,03,12,04,00		; line 2 Sc1
	db 01,18,19,08,04,13,03,00		; line 3 Sc2
	db 01,20,21,06,05,14,03,00		; line 4 Chk
	db 01,17,16,04,03,13,14,00		; line 5 PP1
	db 01,18,19,07,14,12,03,00		; line 6 PP2
	db 01,18,20,03,15,05,12,00		; line 7 PK1
	db 01,17,16,05,12,03,15,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Ron Hextall", $2774,$4444,$0000,$4433)
	%Player("Stephane Fiset", $3553,$4332,$0000,$2222)
	%Player("Joe Sakic", $1964,$4544,$2045,$5252)
	%Player("Mike Ricci", $0974,$4433,$3435,$3043)
	%Player("Claude Lapointe", $4753,$3342,$2432,$3123)
	%Player("Martin Rucinsky", $2553,$2323,$1433,$3132)
	%Player("Valeri Kamensky", $3184,$4435,$2543,$4142)
	%Player("Gino Cavallini", $44B1,$3222,$2423,$2222)
	%Player("Scott Pearson", $2292,$2222,$3624,$3524)
	%Player("Chris Simon", $12D1,$1101,$2811,$0515)
	%Player("Tony Twist", $15A1,$1101,$1C10,$1414)
	%Player("Mats Sundin", $1374,$4544,$1345,$4043)
	%Player("Owen Nolan", $1184,$4434,$1744,$4334)
	%Player("Andrei Kovalenko", $5133,$4433,$3434,$4132)
	%Player("Scott Young", $4873,$3343,$2133,$3431)
	%Player("Steve Duchesne", $2884,$4444,$2442,$4142)
	%Player("Curtis Leschyshyn", $0793,$4342,$3423,$4032)
	%Player("Alexei Gusarov", $0563,$3333,$3033,$4032)
	%Player("Kerry Huffman", $0293,$3333,$3631,$3223)
	%Player("Adam Foote", $5262,$2241,$3321,$3224)
	%Player("Steven Finn", $2982,$2233,$3622,$3424)
	%Player("Mikhail Tatarinov", $0483,$3225,$4641,$2443)
	%Player("Craig Wolanin", $0692,$2221,$2811,$2114)
	dw 2
.tn:								; city
	%String("Quebec")
.ta:								; abbreviation
	%String("QUE")
.tm:								; nickname
	%String("Nordiques")
.ar:								; arena
	%String("Colisee de Quebec")
SanJose:							; team record: San Jose (SJ), team 19
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $07,$02,$12,$C8,$38
.godds:								; starting goalie weights
	db 102,48
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,17,16,09,04,13,05,00		; line 1 NLC (no line changes)
	db 01,17,20,09,04,13,05,00		; line 2 Sc1
	db 01,18,21,11,05,14,04,00		; line 3 Sc2
	db 01,16,23,10,06,15,04,00		; line 4 Chk
	db 01,16,18,09,04,13,06,00		; line 5 PP1
	db 01,17,20,10,06,05,04,00		; line 6 PP2
	db 01,20,22,04,13,05,07,00		; line 7 PK1
	db 01,17,21,07,05,04,13,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Arturs Irbe", $3252,$4443,$0000,$3322)
	%Player("Jeff Hackett", $3052,$3112,$0000,$2222)
	%Player("Brian Hayward", $0162,$3002,$0000,$2222)
	%Player("Kelly Kisio", $1162,$2443,$3334,$4033)
	%Player("Rob Gaudreau", $3763,$3333,$2323,$4531)
	%Player("Dean Evason", $1261,$1232,$3323,$3323)
	%Player("Mike Sullivan", $4762,$3232,$1021,$4521)
	%Player("Perry Berezan", $1674,$4222,$3322,$2533)
	%Player("Johan Garpenlov", $1063,$3422,$1033,$3122)
	%Player("Jeff Odgers", $3691,$2322,$2623,$3415)
	%Player("John Carter", $2042,$2222,$2821,$2523)
	%Player("David Maley", $2581,$1112,$3820,$1414)
	%Player("Pat Falloon", $1774,$4323,$1342,$4531)
	%Player("Ed Courtenay", $3992,$2331,$1313,$2121)
	%Player("Mark Pederson", $1882,$2322,$2623,$2522)
	%Player("Doug Wilson", $2474,$3336,$3641,$3343)
	%Player("Neil Wilkinson", $0573,$3132,$3530,$4443)
	%Player("Sandis Ozolinsh", $0673,$3333,$3632,$4233)
	%Player("Tom Pederson", $4141,$2322,$2522,$2432)
	%Player("Doug Zmolek", $19C2,$2232,$3621,$3524)
	%Player("Jay More", $0473,$2134,$3331,$3534)
	%Player("Peter Ahola", $2192,$2132,$3621,$3422)
	%Player("Rob Zettler", $0272,$2132,$2430,$3434)
	dw 2
.tn:								; city
	%String("San Jose")
.ta:								; abbreviation
	%String("SJ")
.tm:								; nickname
	%String("Sharks")
.ar:								; arena
	%String("San Jose Arena")
StLouis:							; team record: St. Louis (STL), team 20
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $22,$20,$21,$D9,$45
.godds:								; starting goalie weights
	db 208,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,16,15,10,02,11,03,00		; line 1 NLC (no line changes)
	db 01,15,16,09,05,11,02,00		; line 2 Sc1
	db 01,18,22,06,02,10,05,00		; line 3 Sc2
	db 01,17,19,08,03,13,05,00		; line 4 Chk
	db 01,15,17,10,02,11,04,00		; line 5 PP1
	db 01,19,20,03,04,12,10,00		; line 6 PP2
	db 01,18,22,05,04,08,13,00		; line 7 PK1
	db 01,19,16,08,13,04,05,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Curtis Joseph", $3164,$4664,$0000,$3344)
	%Player("Craig Janney", $1574,$3543,$2044,$4040)
	%Player("Nelson Emerson", $0744,$4433,$2343,$4132)
	%Player("Ron Sutter", $2263,$3342,$4533,$4343)
	%Player("Ron Wilson", $1863,$3241,$2022,$4322)
	%Player("Bob Bassen", $2843,$4222,$4833,$2323)
	%Player("Philippe Bozon", $3662,$2222,$1621,$2513)
	%Player("Igor Korolev", $3872,$2232,$2021,$3021)
	%Player("Basil McRae", $1792,$2222,$2C21,$3415)
	%Player("Brendan Shanahan", $19A3,$3544,$2745,$4244)
	%Player("Brett Hull", $1694,$4536,$3353,$4432)
	%Player("Kevin Miller", $1474,$3343,$3733,$4333)
	%Player("Rich Sutter", $2373,$3241,$2322,$4523)
	%Player("Kelly Chase", $3981,$1121,$1911,$2315)
	%Player("Jeff Brown", $2193,$3445,$2343,$5142)
	%Player("Garth Butcher", $0592,$3242,$4731,$4434)
	%Player("Doug Crossman", $0672,$2332,$2623,$4032)
	%Player("Rick Zombo", $0482,$2233,$2320,$4023)
	%Player("Stephane Quintal", $33B2,$2142,$3730,$4433)
	%Player("Lee Norwood", $2082,$2231,$3822,$3224)
	%Player("Bret Hedican", $4482,$2112,$3620,$1322)
	%Player("Curt Giles", $0253,$2131,$2220,$3312)
	%Player("Murray Baron", $34A3,$3122,$2621,$2513)
	dw 2
.tn:								; city
	%String("St. Louis")
.ta:								; abbreviation
	%String("STL")
.tm:								; nickname
	%String("Blues")
.ar:								; arena
	%String("St. Louis Arena")
TampaBay:							; team record: Tampa Bay (TB), team 21
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $05,$02,$00,$E7,$38
.godds:								; starting goalie weights
	db 104,64
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,19,18,11,04,05,06,00		; line 1 NLC (no line changes)
	db 01,21,22,12,04,14,06,00		; line 2 Sc1
	db 01,20,23,11,06,16,04,00		; line 3 Sc2
	db 01,18,19,13,05,15,04,00		; line 4 Chk
	db 01,19,20,12,04,14,05,00		; line 5 PP1
	db 01,18,21,11,06,05,04,00		; line 6 PP2
	db 01,21,18,11,16,14,15,00		; line 7 PK1
	db 01,19,20,15,14,11,16,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Wendell Young", $0163,$3223,$0000,$3233)
	%Player("Pat Jablonski", $3552,$3222,$0100,$2222)
	%Player("J.C. Bergeron", $3072,$3222,$0000,$1111)
	%Player("Brian Bradley", $1944,$3434,$3335,$4233)
	%Player("Chris Kontos", $1683,$3433,$3035,$4330)
	%Player("Adam Creighton", $10A3,$2322,$3422,$3433)
	%Player("Marc Bureau", $2873,$3332,$2132,$3324)
	%Player("Rob DiMaio", $1852,$3332,$2522,$3223)
	%Player("Steve Kasper", $1153,$3132,$4433,$3231)
	%Player("Jason Lafreniere", $1762,$2332,$1324,$2212)
	%Player("Mikael Andersson", $3462,$4232,$1032,$4530)
	%Player("Rob Zamuner", $0792,$3322,$3432,$3322)
	%Player("Steve Maltais", $37A2,$2232,$3021,$3422)
	%Player("John Tucker", $1492,$3333,$2332,$3233)
	%Player("Danton Cole", $2473,$3332,$2122,$3421)
	%Player("Tim Bergland", $2182,$2132,$2321,$3522)
	%Player("Stan Drulia", $2771,$2102,$2312,$0512)
	%Player("Bob Beers", $0293,$3332,$2322,$3323)
	%Player("Roman Hamrlik", $4473,$2233,$2431,$3423)
	%Player("Shawn Chambers", $2292,$2332,$2221,$3222)
	%Player("Marc Bergevin", $2562,$2223,$3420,$3322)
	%Player("Joe Reekie", $29B3,$2223,$2630,$3223)
	%Player("Chris Lipuma", $4061,$1211,$0210,$1114)
	%Player("Matt Hervey", $2691,$1211,$2910,$1304)
	dw 2
.tn:								; city
	%String("Tampa Bay")
.ta:								; abbreviation
	%String("TB")
.tm:								; nickname
	%String("Lightning")
.ar:								; arena
	%String("Expo Hall")
Toronto:							; team record: Toronto (TOR), team 22
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $20,$20,$11,$E8,$48
.godds:								; starting goalie weights
	db 150,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,17,18,08,03,12,14,00		; line 1 NLC (no line changes)
	db 01,20,16,08,03,12,05,00		; line 2 Sc1
	db 01,22,21,10,05,13,03,00		; line 3 Sc2
	db 01,17,18,09,04,14,03,00		; line 4 Chk
	db 01,17,16,08,03,12,14,00		; line 5 PP1
	db 01,18,20,14,04,13,03,00		; line 6 PP2
	db 01,17,22,05,03,11,06,00		; line 7 PK1
	db 01,20,16,11,06,03,05,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Felix Potvin", $2964,$4664,$0000,$4444)
	%Player("Daren Puppa", $0193,$4552,$0100,$2233)
	%Player("Doug Gilmour", $9345,$4554,$4444,$6043)
	%Player("John Cullen", $1974,$3433,$2344,$4143)
	%Player("Mike Krushelski", $2693,$3342,$3434,$4322)
	%Player("Peter Zezel", $2593,$3333,$4033,$4141)
	%Player("Dave McLlwain", $0773,$2231,$3433,$3532)
	%Player("Dave Andreychuk", $14B3,$3444,$4334,$5432)
	%Player("Wendel Clark", $1783,$3335,$4643,$4344)
	%Player("Mark Osborne", $2192,$2242,$3422,$4413)
	%Player("Bill Berg", $1072,$2232,$3423,$4523)
	%Player("Nikolai Borshevsky", $1664,$4423,$2044,$4241)
	%Player("Glenn Anderson", $0974,$4433,$2643,$4143)
	%Player("Rob Pearson", $1262,$2331,$1123,$4524)
	%Player("Mike Foligno", $7182,$2232,$5533,$3523)
	%Player("Ken Baumgartnr", $2292,$2021,$2A10,$2324)
	%Player("Todd Gill", $2363,$3332,$4422,$4123)
	%Player("Dave Ellett", $0494,$4345,$4441,$4242)
	%Player("Dimitri Mironov", $1573,$2333,$1232,$3132)
	%Player("Drake Berehowsky", $55A2,$2332,$3522,$3023)
	%Player("Jamie Macoun", $3483,$3244,$4431,$4442)
	%Player("Bob Rouse", $03A3,$3242,$4320,$4423)
	%Player("Sylvain Lefebvre", $0292,$2131,$3420,$4433)
	%Player("Bob McGill", $0882,$2023,$3523,$2324)
	dw 2
.tn:								; city
	%String("Toronto")
.ta:								; abbreviation
	%String("TOR")
.tm:								; nickname
	%String("Maple Leafs")
.ar:								; arena
	%String("Maple Leaf Gardens")
Vancouver:							; team record: Vancouver (VAN), team 23
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $61,$02,$11,$E8,$47
.godds:								; starting goalie weights
	db 166,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,18,17,06,03,12,04,00		; line 1 NLC (no line changes)
	db 01,18,21,09,03,13,05,00		; line 2 Sc1
	db 01,23,17,08,05,12,03,00		; line 3 Sc2
	db 01,19,24,06,04,15,03,00		; line 4 Chk
	db 01,17,19,13,04,12,08,00		; line 5 PP1
	db 01,18,22,06,03,08,12,00		; line 6 PP2
	db 01,23,17,12,07,04,15,00		; line 7 PK1
	db 01,18,22,04,15,07,12,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Kirk McLean", $0184,$4444,$0000,$4433)
	%Player("Kay Whitmore", $3552,$3552,$0000,$2323)
	%Player("Cliff Ronning", $0755,$5432,$2043,$5141)
	%Player("Petr Nedved", $1952,$2432,$1036,$4233)
	%Player("Tom Fergus", $15A2,$2332,$2223,$3022)
	%Player("Geoff Courtnall", $1475,$5433,$1443,$3244)
	%Player("Murray Craven", $3263,$3433,$3434,$3031)
	%Player("Greg Adams", $0873,$3443,$3235,$4131)
	%Player("Sergio Momesso", $27B4,$3333,$4623,$4424)
	%Player("Gino Odjick", $29B2,$2232,$3A21,$3326)
	%Player("Garry Valk", $2372,$2232,$3623,$3323)
	%Player("Pavel Bure", $1055,$6544,$2054,$4442)
	%Player("Trevor Linden", $1694,$4444,$3344,$4342)
	%Player("Dixon Ward", $1792,$3333,$2125,$3123)
	%Player("Jim Sandlak", $25B1,$2333,$2922,$3324)
	%Player("Tim Hunter", $2692,$2122,$3923,$2324)
	%Player("Jyrki Lumme", $2174,$3342,$3441,$4142)
	%Player("Doug Lidster", $0393,$3233,$4341,$4142)
	%Player("Adrien Plavsic", $0672,$2332,$3622,$3023)
	%Player("Jiri Slegr", $24A3,$3333,$2631,$4134)
	%Player("Gerald Diduck", $04A3,$3234,$4731,$3434)
	%Player("Dave Babych", $44B2,$2343,$2630,$4233)
	%Player("Dana Murzyn", $0592,$3234,$4621,$4424)
	%Player("Robert Dirk", $22B2,$2132,$3632,$3324)
	dw 2
.tn:								; city
	%String("Vancouver")
.ta:								; abbreviation
	%String("VAN")
.tm:								; nickname
	%String("Canucks")
.ar:								; arena
	%String("Pacific Coliseum")
Winnipeg:							; team record: Winnipeg (WPG), team 25
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $45,$11,$11,$F8,$48
.godds:								; starting goalie weights
	db 214,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,19,18,04,03,13,09,00		; line 1 NLC (no line changes)
	db 01,22,18,08,03,13,04,00		; line 2 Sc1
	db 01,19,21,09,04,14,03,00		; line 3 Sc2
	db 01,20,24,10,06,17,03,00		; line 4 Chk
	db 01,20,18,08,03,13,04,00		; line 5 PP1
	db 01,19,21,09,04,14,03,00		; line 6 PP2
	db 01,19,21,10,06,05,16,00		; line 7 PK1
	db 01,24,22,05,16,10,06,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Bob Essensa", $3534,$4554,$0000,$4444)
	%Player("Jim Hrivnak", $3062,$3222,$0000,$2222)
	%Player("Alexei Zhamnov", $1075,$3433,$3054,$4152)
	%Player("Thomas Steen", $2584,$3433,$3444,$4053)
	%Player("Luciano Borsato", $3843,$3332,$3134,$3232)
	%Player("Mike Eagles", $3673,$3242,$5422,$5123)
	%Player("Stu Barnes", $1452,$3332,$2323,$3421)
	%Player("Darrin Shannon", $3492,$2343,$4034,$4033)
	%Player("Keith Tkachuk", $0793,$2334,$3623,$4424)
	%Player("Kris King", $17A3,$3242,$3622,$4324)
	%Player("Russ Romaniuk", $2163,$2122,$3623,$2522)
	%Player("Andy Brickley", $2392,$2221,$3220,$2030)
	%Player("Teemu Selanne", $1365,$6534,$3345,$5442)
	%Player("Evgeny Davydov", $1164,$4334,$1334,$3532)
	%Player("John Druce", $1592,$2332,$3322,$3122)
	%Player("Bryan Erickson", $1852,$3332,$3322,$3121)
	%Player("Tie Domi", $2092,$2232,$3923,$4126)
	%Player("Phil Housley", $0666,$5433,$2462,$4062)
	%Player("Teppo Numminen", $2774,$3353,$3142,$4132)
	%Player("Fredrik Olausson", $0494,$3434,$1142,$3141)
	%Player("Sergei Bautin", $0363,$3243,$4431,$4233)
	%Player("Igor Ulanov", $0592,$2242,$3621,$4024)
	%Player("Mike Lalor", $2293,$2132,$2420,$4523)
	%Player("Dean Kennedy", $2692,$2132,$3320,$4423)
	%Player("Randy Carlyle", $0892,$2122,$3621,$2522)
	dw 2
.tn:								; city
	%String("Winnipeg")
.ta:								; abbreviation
	%String("WPG")
.tm:								; nickname
	%String("Jets")
.ar:								; arena
	%String("Winnipeg Arena")
Washington:							; team record: Washington (WSH), team 24
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $52,$20,$11,$E8,$46
.godds:								; starting goalie weights
	db 181,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,18,17,04,03,12,13,00		; line 1 NLC (no line changes)
	db 01,18,17,10,04,14,03,00		; line 2 Sc1
	db 01,19,20,09,03,12,04,00		; line 3 Sc2
	db 01,21,22,11,05,13,04,00		; line 4 Chk
	db 01,20,17,04,03,12,06,00		; line 5 PP1
	db 01,18,19,06,05,13,04,00		; line 6 PP2
	db 01,21,17,03,14,10,06,00		; line 7 PK1
	db 01,19,20,10,06,03,14,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Don Beaupre", $3343,$4333,$0000,$3333)
	%Player("Rick Tabaracci", $3162,$3112,$0000,$3322)
	%Player("Mike Ridley", $1794,$4433,$2044,$4042)
	%Player("Dimitri Khristich", $0873,$3434,$3146,$4142)
	%Player("Dale Hunter", $3282,$2443,$4624,$4044)
	%Player("Michal Pivonka", $2083,$3433,$3443,$4043)
	%Player("Steve Konowlchuk", $2262,$2222,$3222,$2222)
	%Player("Reggie Savage", $1572,$2212,$2622,$1322)
	%Player("Bob Carpenter", $1174,$4333,$2432,$3443)
	%Player("Todd Krygier", $2162,$3232,$2422,$3512)
	%Player("Alan May", $1692,$2233,$3722,$3425)
	%Player("Peter Bondra", $1264,$6433,$2044,$4232)
	%Player("Pat Elynuik", $1963,$3333,$2335,$3122)
	%Player("Kelly Miller", $1084,$4333,$2043,$3241)
	%Player("Keith Jones", $2672,$2222,$3323,$2234)
	%Player("Paul MacDermid", $2392,$2232,$4724,$3323)
	%Player("Kevin Hatcher", $04C3,$3445,$4342,$4443)
	%Player("Al Iafrate", $34B4,$4446,$4642,$4444)
	%Player("Sylvain Cote", $0363,$3343,$3132,$4432)
	%Player("Calle Johansson", $0694,$3344,$3441,$4142)
	%Player("Paul Cavallini", $14A3,$3233,$3431,$3532)
	%Player("Shawn Anderson", $3692,$2122,$3621,$2331)
	%Player("Jason Woolley", $2562,$2111,$2220,$1212)
	%Player("Rod Langway", $05B3,$2022,$3230,$2323)
	dw 2
.tn:								; city
	%String("Washington")
.ta:								; abbreviation
	%String("WSH")
.tm:								; nickname
	%String("Capitals")
.ar:								; arena
	%String("Capital Centre")
Florida:							; team record: Florida (FLA), team 8
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $07,$02,$13,$96,$33
.godds:								; starting goalie weights
	db 214,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,14,12,08,05,04,07,00		; line 1 NLC (no line changes)
	db 01,14,17,08,05,03,04,00		; line 2 Sc1
	db 01,16,12,06,10,11,05,00		; line 3 Sc2
	db 01,13,15,07,09,04,05,00		; line 4 Chk
	db 01,14,12,08,05,04,10,00		; line 5 PP1
	db 01,13,17,06,10,03,05,00		; line 6 PP2
	db 01,14,12,09,05,07,08,00		; line 7 PK1
	db 01,13,17,07,08,09,05,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("John Vanbiesbrk", $3453,$4553,$0000,$3434)
	%Player("Mark Fitzpatrik", $3072,$4223,$0000,$2222)
	%Player("Tom Fitzgerald", $1482,$2232,$2122,$3222)
	%Player("Scott Mellanby", $2791,$1333,$4723,$3324)
	%Player("Brian Skrudland", $3984,$2242,$4633,$4434)
	%Player("Mike Hough", $1873,$2333,$2432,$3233)
	%Player("Dave Lowry", $1082,$2232,$3622,$3424)
	%Player("Andrei Lomakin", $2374,$3323,$1233,$3242)
	%Player("Randy Gilhen", $2072,$2132,$3221,$3521)
	%Player("Jesse Belanger", $2941,$2312,$2022,$1421)
	%Player("Bill Lindsay", $2271,$2222,$2022,$2421)
	%Player("Joe Cirella", $06A3,$3223,$2922,$3323)
	%Player("Alexnder Godynyuk", $21A2,$3222,$3822,$3512)
	%Player("Gord Murphy", $2885,$4234,$4931,$3333)
	%Player("Gord Hynes", $2642,$2221,$3222,$2522)
	%Player("Milan Tichy", $4383,$2112,$3821,$2224)
	%Player("Stephane Richer", $2593,$3333,$3332,$3322)
	dw 2
.tn:								; city
	%String("Florida")
.ta:								; abbreviation
	%String("FLA")
.tm:								; nickname
	%String("Panthers")
.ar:								; arena
	%String("Miami Arena")
Anaheim:							; team record: Anaheim (ANH), team 0
.0:	dw .pld-.0,.sr-.0,.tn-.0,.ls+8-.0,.sr-.0,.godds-.0,.ls-.0	; offsets to the parts (from .0)
.sr:								; the scouting report
	db $07,$02,$13,$97,$34
.godds:								; starting goalie weights
	db 214,0
.ls:								; -G,LD,RD,LW,-C,RW,XA,00: player numbers (1 = the first .pld entry)
	db 01,12,14,04,06,08,03,00		; line 1 NLC (no line changes)
	db 01,12,16,03,06,11,04,00		; line 2 Sc1
	db 01,14,15,09,08,07,03,00		; line 3 Sc2
	db 01,13,18,04,10,05,03,00		; line 4 Chk
	db 01,12,16,04,06,08,04,00		; line 5 PP1
	db 01,13,15,03,09,11,03,00		; line 6 PP2
	db 01,12,14,06,07,04,08,00		; line 7 PK1
	db 01,17,16,04,08,07,06,00		; line 8 PK2
.pld:								; name, then the ratings as 16 nibbles: unwl,sodp,chga,eytm
	%Player("Guy Hebert", $2962,$3332,$0000,$2222)
	%Player("Ron Tugnutt", $0122,$3331,$0000,$1112)
	%Player("Steven King", $2772,$2322,$1323,$3422)
	%Player("Troy Loney", $24A2,$3232,$4621,$3213)
	%Player("Stu Grimson", $23B1,$1021,$3A11,$2514)
	%Player("Terry Yake", $2563,$3433,$3334,$4032)
	%Player("Bob Corkum", $30A2,$2132,$2322,$3522)
	%Player("Anatoli Semenov", $2073,$3343,$2033,$4032)
	%Player("Lonnie Loach", $2862,$3322,$2623,$2222)
	%Player("Robin Bawa", $26B2,$2112,$1514,$1323)
	%Player("Tim Sweeney", $4152,$2322,$1022,$1411)
	%Player("Alexei Kasatonov", $07B4,$3234,$4441,$3142)
	%Player("Sean Hill", $3882,$2222,$3521,$2314)
	%Player("Randy Ladouceur", $39B3,$3131,$2421,$3514)
	%Player("David Williams", $0382,$2222,$2520,$2213)
	%Player("Bill Houlder", $33B3,$2332,$3422,$2421)
	%Player("Bobby Dollas", $32B2,$1121,$2110,$2111)
	%Player("Dennis Vial", $17B1,$1121,$3810,$2113)
	dw 2
.tn:								; city
	%String("Anaheim")
.ta:								; abbreviation
	%String("ANH")
.tm:								; nickname
	%String("Mighty Ducks")
.ar:								; arena
	%String("Pond in Anaheim")
playoffseats:						; the playoff tree seedings: 32 rows of 16 team numbers (TeamList index)
	db 02,01,11,18, 13,24,12,17, 22,06,20,04, 10,03,25,23
	db 13,02,21,11, 18,17,14,01, 03,22,10,23, 20,06,05,04
	db 12,17,16,02, 09,11,24,01, 05,22,07,04, 19,23,10,06
	db 09,17,18,11, 24,01,12,02, 10,22,07,06, 05,04,03,23
	db 18,02,12,17, 09,11,16,01, 03,06,19,22, 05,23,07,04
	db 15,01,09,11, 13,17,14,02, 19,23,03,06, 05,04,07,22
	db 16,11,15,17, 21,02,13,01, 20,06,25,04, 00,23,03,22
	db 12,01,18,17, 16,11,13,02, 19,06,03,04, 05,23,10,22
	db 15,17,09,01, 08,11,24,02, 03,22,05,23, 25,04,10,06
	db 14,02,16,01, 18,11,09,17, 25,04,19,06, 20,23,03,22
	db 16,11,18,01, 12,17,13,02, 00,06,25,22, 10,23,03,04
	db 13,17,15,11, 14,02,12,01, 05,06,10,04, 19,22,20,23
	db 18,01,14,02, 15,11,16,17, 05,23,19,22, 07,04,03,06
	db 12,11,14,17, 15,01,09,02, 20,22,19,04, 05,06,07,23
	db 24,13,14,11, 16,02,21,17, 22,20,05,10, 25,04,19,23
	db 18,02,21,13, 12,11,09,17, 07,20,05,10, 19,23,06,04
	db 01,21,15,02, 12,11,18,17, 22,20,19,10, 05,23,25,04
	db 09,13,12,02, 15,11,01,17, 03,23,05,10, 22,04,07,20
	db 15,17,09,11, 08,02,14,13, 22,20,25,04, 06,23,07,10
	db 24,13,12,17, 14,02,01,11, 06,23,05,10, 07,04,25,20
	db 15,11,18,02, 01,13,24,17, 07,20,03,10, 25,23,06,04
	db 15,17,21,11, 18,13,12,02, 19,10,03,04, 25,20,07,23
	db 15,11,16,02, 12,08,18,17, 05,04,22,10, 25,20,19,23
	db 12,11,18,17, 15,13,16,02, 06,23,19,10, 22,20,07,04
	db 09,17,18,13, 15,11,01,02, 06,04,07,20, 03,10,22,23
	db 14,13,01,02, 24,11,15,17, 06,04,05,23, 07,10,25,20
	db 09,02,15,13, 12,17,01,11, 22,10,03,20, 06,23,19,04
	db 18,13,21,02, 01,11,08,17, 07,10,25,20, 03,04,05,23
	db 09,11,12,13, 24,02,18,17, 19,20,00,23, 03,04,06,10
	db 14,02,08,21, 24,17,01,11, 22,04,25,23, 05,10,00,20
	db 12,11,15,02, 21,17,14,13, 07,10,19,04, 00,23,06,20
	db 24,08,12,17, 01,11,21,02, 19,20,06,04, 00,10,25,23
