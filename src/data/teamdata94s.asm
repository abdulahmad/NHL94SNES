; *** ANONYMIZED: the player names and team nicknames are placeholders. ***
; Players are P001 ... P653, nicknames N01 ... N26. The real ones are NHLPA / NHL licensed
; data and are not in this repository.

; Each %Player row and each nickname %String has a placeholder of the same length as the
; real text (the macro writes the length word, so it must not change). The ratings after a
; name are unchanged.

; This file does not assemble into the real game by itself and is not included directly: it
; needs the original ROM.

; tools/extract.py reads the names from your ROM into Extracted/PlayerNames.txt and
; Extracted/TeamNicknames.txt (one per line, in the order they appear below).

; tools/names.py (run by build.sh and build.ps1) copies this file to output/names/ with the
; real names put back, and src/banks/b9C_teams.asm includes that copy.

; Keep the placeholder lengths when editing a name or adding a player.

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
	dd NewYorkI						; 13
	dd NewYorkR						; 14
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
.pld:								; player data: one player per row, ended by an empty String
	;						unwl,sodp,chga,eytm
	%Player("P001_______", $3366,$4446,$0100,$5566)
	%Player("P002______", $3175,$4555,$0000,$4455)
	%Player("P003________", $35A4,$4554,$0000,$4444)
	%Player("P004_________", $66A5,$4644,$3366,$6062)
	%Player("P005________", $11A5,$4443,$5453,$4053)
	%Player("P006_______", $1094,$4444,$4444,$4143)
	%Player("P007______", $1275,$4653,$3154,$5061)
	%Player("P008_____", $1964,$4544,$2045,$5252)
	%Player("P009__________", $7894,$4534,$3445,$5141)
	%Player("P010__________", $1655,$4643,$3354,$6052)
	%Player("P011_________", $25B3,$4533,$3644,$5344)
	%Player("P012________", $68A5,$4433,$4453,$4142)
	%Player("P013________", $1364,$6433,$2044,$4232)
	%Player("P014________", $2275,$5445,$2353,$5552)
	%Player("P015________", $2392,$2544,$3735,$4134)
	%Player("P016____________", $8976,$6634,$2455,$4452)
	%Player("P017_______", $0865,$4534,$3445,$4143)
	%Player("P018________", $55A4,$3454,$3242,$5143)
	%Player("P019_______", $77A5,$4465,$6055,$6252)
	%Player("P020________", $0266,$3444,$2651,$5252)
	%Player("P021__________", $2884,$4444,$2442,$4142)
	%Player("P022______", $34B4,$4446,$4642,$4444)
	%Player("P023_________", $04B4,$4344,$5642,$5043)
	%Player("P024___________", $03A5,$4454,$4442,$5133)
	%Player("P025_______", $2685,$4344,$3641,$4442)
	dw 2							; end of player data: empty String
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P026______", $3066,$4665,$0000,$6655)
	%Player("P027_________", $3264,$4444,$0000,$4344)
	%Player("P028________", $2964,$4664,$0000,$4444)
	%Player("P029_________", $1966,$5644,$1155,$6152)
	%Player("P030_______", $0975,$5445,$2452,$5243)
	%Player("P031__________", $2745,$5445,$2355,$5253)
	%Player("P032_________", $2344,$3434,$3335,$4233)
	%Player("P033________", $9345,$4554,$4444,$6043)
	%Player("P034_________", $9946,$4542,$2262,$6060)
	%Player("P035________", $1174,$4544,$4845,$5134)
	%Player("P036__________", $2074,$4534,$2456,$5243)
	%Player("P037__________", $1435,$5454,$4743,$6133)
	%Player("P038______", $1694,$4536,$3353,$4432)
	%Player("P039______", $1055,$6544,$2054,$4442)
	%Player("P040_________", $1365,$6534,$3345,$5442)
	%Player("P041_______", $1874,$4323,$1342,$4531)
	%Player("P042______", $1784,$3444,$2143,$4132)
	%Player("P043______", $2275,$4454,$4642,$5243)
	%Player("P044______", $2193,$3445,$2343,$5142)
	%Player("P045_______", $7796,$5434,$2461,$5153)
	%Player("P046_________", $0774,$4465,$4751,$6245)
	%Player("P047________", $0666,$5433,$2462,$4062)
	%Player("P048_______", $2494,$4355,$4A41,$5434)
	%Player("P049_______", $05B4,$4344,$4641,$5244)
	%Player("P050__________", $0394,$3444,$3641,$4234)
	dw 2							; end of player data: empty String
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P051_____", $3544,$4224,$0000,$4343)
	%Player("P052_____", $3963,$4553,$0000,$4343)
	%Player("P053______", $1275,$4653,$3154,$5061)
	%Player("P054_______", $1974,$3343,$4433,$4142)
	%Player("P055____________", $38A4,$4334,$2643,$3332)
	%Player("P056______", $2143,$4343,$3033,$3332)
	%Player("P057______", $4954,$4434,$2043,$4041)
	%Player("P058_____________", $1064,$4423,$2043,$4241)
	%Player("P059_____", $1792,$3333,$1424,$4420)
	%Player("P060______________", $1364,$4222,$1233,$2431)
	%Player("P061________", $4263,$3132,$3632,$2534)
	%Player("P062_____", $08A4,$4544,$4945,$5344)
	%Player("P063_________", $2763,$3333,$3732,$4533)
	%Player("P064__________", $2363,$3333,$3333,$3531)
	%Player("P065______", $1863,$3223,$2533,$2322)
	%Player("P066________", $2991,$1211,$2924,$1315)
	%Player("P067________", $1683,$4333,$2533,$2421)
	%Player("P068_______", $77A5,$4465,$6055,$6252)
	%Player("P069_______", $3244,$4344,$4441,$4142)
	%Player("P070_______", $2685,$4344,$3641,$4442)
	%Player("P071______", $3492,$2242,$3322,$4523)
	%Player("P072__________", $1473,$2231,$3423,$3023)
	%Player("P073___________", $06B3,$3222,$4823,$2324)
	%Player("P074______", $36A2,$1221,$2820,$2324)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Boston")
.ta:								; abbreviation
	%String("BOS")
.tm:								; nickname
	%String("N01___")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P075______", $3175,$4555,$0100,$4455)
	%Player("P076______", $3562,$3332,$0000,$2222)
	%Player("P077_________", $3943,$3552,$0000,$2222)
	%Player("P078__________", $1655,$4643,$3354,$6052)
	%Player("P079__________", $1065,$4443,$2051,$3052)
	%Player("P080_______", $2094,$2353,$4734,$4233)
	%Player("P081_______", $1462,$2232,$2623,$2022)
	%Player("P082______", $1981,$5332,$3622,$3423)
	%Player("P083________", $1374,$3344,$3134,$3332)
	%Player("P084____", $2792,$2222,$3A23,$2514)
	%Player("P085_____", $1264,$4242,$4432,$4523)
	%Player("P086___", $32A3,$4111,$3A22,$1514)
	%Player("P087____________", $8976,$6634,$2455,$4452)
	%Player("P088_________", $1863,$3334,$2723,$3323)
	%Player("P089__________", $2853,$3333,$2933,$3523)
	%Player("P090___________", $1784,$4231,$3523,$2522)
	%Player("P091_______", $08A2,$3342,$3621,$4133)
	%Player("P092________", $0754,$4343,$3640,$4033)
	%Player("P093___________", $42A3,$3343,$4431,$3032)
	%Player("P094______", $4182,$2242,$1412,$3232)
	%Player("P095_________", $0394,$3231,$3C10,$2323)
	%Player("P096_________", $3491,$2231,$3B11,$2225)
	%Player("P097________", $24A3,$2212,$3921,$1124)
	%Player("P098________", $0692,$3212,$3622,$1424)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Buffalo")
.ta:								; abbreviation
	%String("BUF")
.tm:								; nickname
	%String("N02___")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P099_______", $3043,$4444,$0000,$4433)
	%Player("P100______", $3542,$3442,$0000,$2233)
	%Player("P101__________", $2584,$4434,$3444,$4322)
	%Player("P102__________", $2664,$4434,$2444,$3242)
	%Player("P103_____", $29B4,$3352,$5734,$4124)
	%Player("P104________", $1074,$4544,$4845,$5134)
	%Player("P105________", $2884,$4343,$1343,$3431)
	%Player("P106________", $15A3,$3343,$4632,$4433)
	%Player("P107__________", $1173,$4232,$2433,$2321)
	%Player("P108________", $1692,$3112,$2A11,$1414)
	%Player("P109__________", $1435,$5454,$4743,$6133)
	%Player("P110__________", $4265,$4422,$1054,$3052)
	%Player("P111__________", $2372,$2313,$2134,$2220)
	%Player("P112________", $2282,$2212,$3723,$1324)
	%Player("P113______", $2075,$4454,$4642,$5243)
	%Player("P114_______", $0284,$4436,$3541,$5243)
	%Player("P115___________", $3474,$3222,$3431,$2332)
	%Player("P116________", $1873,$2242,$3630,$3133)
	%Player("P117_______", $0394,$4232,$3621,$3523)
	%Player("P118________", $0793,$3234,$3941,$3333)
	%Player("P119______", $0472,$3242,$3331,$3132)
	%Player("P120___________", $0583,$3143,$3431,$3523)
	%Player("P121______", $06A0,$0100,$1901,$1404)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Calgary")
.ta:								; abbreviation
	%String("CGY")
.tm:								; nickname
	%String("N03___")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P122______", $3066,$4665,$0000,$6655)
	%Player("P123_____", $2963,$3332,$0000,$2233)
	%Player("P124__________", $2745,$5445,$2355,$5253)
	%Player("P125___________", $2284,$4343,$4442,$4243)
	%Player("P126________", $1263,$2453,$4343,$5133)
	%Player("P127_______", $1984,$3242,$4331,$3533)
	%Player("P128_________", $1684,$3332,$2635,$3312)
	%Player("P129____________", $3282,$2321,$3623,$3213)
	%Player("P130________", $1472,$2332,$4633,$3112)
	%Player("P131___________", $2693,$4334,$2622,$2213)
	%Player("P132________", $2874,$4464,$4444,$6342)
	%Player("P133_______", $3384,$3353,$4732,$4534)
	%Player("P134________", $1073,$3334,$3343,$4533)
	%Player("P135__________", $2583,$3233,$2331,$3231)
	%Player("P136______", $1774,$4434,$3233,$4243)
	%Player("P137_____", $4464,$3322,$2841,$2024)
	%Player("P138_________", $0774,$4465,$4751,$6245)
	%Player("P139_______", $05B4,$4344,$4641,$5244)
	%Player("P140___________", $0283,$3242,$4621,$3215)
	%Player("P141___________", $0692,$2243,$1321,$3422)
	%Player("P142______", $0392,$2132,$4620,$4223)
	%Player("P143_______", $0472,$2232,$3931,$3433)
	%Player("P144_______", $0853,$3132,$3431,$3524)
	%Player("P145________", $4792,$2111,$2520,$1412)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Chicago")
.ta:								; abbreviation
	%String("CHI")
.tm:								; nickname
	%String("N04_______")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P146_________", $3264,$4444,$0000,$4344)
	%Player("P147____________", $3763,$3222,$0000,$3223)
	%Player("P148_________", $1966,$5644,$1155,$6152)
	%Player("P149__________", $9175,$4444,$3254,$4153)
	%Player("P150________", $2844,$4343,$2033,$4133)
	%Player("P151__________", $2373,$3332,$2332,$4021)
	%Player("P152___________", $1354,$3223,$1233,$3533)
	%Player("P153_________", $2174,$4443,$2644,$3342)
	%Player("P154______", $1162,$2332,$4622,$3123)
	%Player("P155_________", $55B3,$3343,$1624,$3124)
	%Player("P156__________", $1762,$2333,$4633,$3134)
	%Player("P157__________", $2593,$3333,$3234,$2130)
	%Player("P158___________", $2255,$4425,$2355,$4143)
	%Player("P159________", $2662,$2433,$3334,$3222)
	%Player("P160_______", $24B4,$3333,$4A22,$4235)
	%Player("P161___________", $1543,$3322,$2324,$2522)
	%Player("P162______", $1472,$2212,$3722,$1424)
	%Player("P163_______", $7796,$5434,$2461,$5153)
	%Player("P164__________", $0394,$3444,$3641,$4234)
	%Player("P165_______", $3363,$3344,$3431,$4233)
	%Player("P166____________", $0554,$3344,$3441,$4241)
	%Player("P167_____", $0463,$3343,$3231,$3031)
	%Player("P168_______________", $1663,$3243,$4731,$4233)
	%Player("P169_________", $0883,$3232,$4421,$3233)
	%Player("P170__________", $0283,$2242,$4610,$3133)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Detroit")
.ta:								; abbreviation
	%String("DET")
.tm:								; nickname
	%String("N05______")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P171________", $3044,$3334,$0000,$4454)
	%Player("P172_______", $3963,$3343,$3443,$3132)
	%Player("P173_____", $3473,$4332,$2433,$3123)
	%Player("P174___________", $1484,$3242,$4432,$5223)
	%Player("P175______", $1553,$4333,$3632,$3332)
	%Player("P176________", $2692,$2322,$2624,$2512)
	%Player("P177_______", $2093,$3242,$4820,$3233)
	%Player("P178_________", $0994,$4343,$4642,$4234)
	%Player("P179_________", $1883,$3434,$2345,$3132)
	%Player("P180_______", $0874,$3333,$2033,$3230)
	%Player("P181____________", $16A2,$2232,$4A13,$3213)
	%Player("P182__________", $0783,$3223,$2432,$2422)
	%Player("P183_________", $29C1,$1212,$3C14,$1515)
	%Player("P184______", $8575,$5324,$1355,$4533)
	%Player("P185_______", $12B2,$2212,$1321,$1223)
	%Player("P186_______", $2494,$4355,$4A41,$5434)
	%Player("P187_________", $2194,$3343,$3242,$4432)
	%Player("P188_________", $1982,$2343,$3622,$4234)
	%Player("P189_______", $2594,$3231,$1431,$3231)
	%Player("P190_______", $06B3,$3234,$3421,$4323)
	%Player("P191___________", $22B3,$3132,$4630,$2434)
	%Player("P192________", $02A3,$3313,$3531,$1233)
	%Player("P193________", $3693,$3223,$2633,$2523)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Edmonton")
.ta:								; abbreviation
	%String("EDM")
.tm:								; nickname
	%String("N06___")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P194______", $01A4,$3224,$0000,$4444)
	%Player("P195__________", $3132,$3442,$0000,$1122)
	%Player("P196____________", $4063,$3113,$0000,$2222)
	%Player("P197__________", $2173,$3442,$2034,$4032)
	%Player("P198___________", $3654,$3323,$2232,$3132)
	%Player("P199_______", $3853,$3342,$2233,$3432)
	%Player("P200_____________", $3954,$3223,$2231,$3433)
	%Player("P201___________", $0864,$4434,$2044,$4331)
	%Player("P202__________", $24A3,$3323,$3033,$3232)
	%Player("P203__________", $1182,$2232,$3812,$3311)
	%Player("P204________", $3392,$2112,$2422,$2314)
	%Player("P205____________", $0762,$3232,$3622,$3533)
	%Player("P206_______", $1673,$4434,$3744,$4244)
	%Player("P207_________", $22B3,$3333,$4633,$4124)
	%Player("P208________", $2082,$2221,$3624,$3415)
	%Player("P209______", $1771,$1210,$1511,$1013)
	%Player("P210_______", $3483,$3212,$3923,$1520)
	%Player("P211___________", $03A5,$4454,$4442,$5133)
	%Player("P212_________", $04A3,$4343,$3432,$4133)
	%Player("P213_____", $0674,$3234,$3441,$4334)
	%Player("P214_______", $3772,$2231,$1622,$2513)
	%Player("P215______", $2772,$2122,$2921,$2414)
	%Player("P216__________", $41A2,$3132,$3621,$2123)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Hartford")
.ta:								; abbreviation
	%String("HFD")
.tm:								; nickname
	%String("N07____")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P217________", $3263,$3444,$0000,$2223)
	%Player("P218________", $3562,$3553,$0000,$2222)
	%Player("P219________", $0122,$3332,$0000,$2221)
	%Player("P220_________", $9946,$4542,$2262,$6060)
	%Player("P221________", $1294,$4434,$2345,$4241)
	%Player("P222________", $2343,$4432,$1534,$3333)
	%Player("P223________", $1462,$2201,$2322,$0322)
	%Player("P224__________", $2074,$4534,$2456,$5243)
	%Player("P225________", $2164,$5443,$3334,$3334)
	%Player("P226________", $1572,$2222,$2423,$2431)
	%Player("P227_________", $1072,$2211,$3612,$1515)
	%Player("P228___________", $0794,$4535,$3845,$3233)
	%Player("P229______", $1784,$3444,$2143,$4132)
	%Player("P230_________", $1164,$4432,$3423,$4332)
	%Player("P231_______", $1873,$2233,$3532,$3323)
	%Player("P232_____", $04B4,$4444,$3341,$4344)
	%Player("P233__________", $33C3,$3343,$3932,$4436)
	%Player("P234__________", $0254,$4343,$3432,$4133)
	%Player("P235________", $2593,$3233,$3431,$3232)
	%Player("P236_________", $22A3,$2243,$3431,$3132)
	%Player("P237______", $2483,$3231,$3620,$2123)
	%Player("P238__________", $0352,$2121,$2820,$2114)
	%Player("P239_______", $0562,$2121,$2620,$2122)
	%Player("P240___________", $0881,$1010,$1510,$1313)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Los Angeles")
.ta:								; abbreviation
	%String("LA")
.tm:								; nickname
	%String("N08__")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P241_____", $3024,$3443,$0000,$2234)
	%Player("P242_________", $3562,$3333,$0000,$2232)
	%Player("P243_______", $0975,$5445,$2452,$5243)
	%Player("P244_______", $1564,$4443,$2444,$4244)
	%Player("P245_______", $0744,$4353,$3032,$4341)
	%Player("P246___________", $4164,$3223,$2042,$2532)
	%Player("P247_______", $1794,$3333,$4422,$4422)
	%Player("P248___________", $1093,$4232,$3423,$3511)
	%Player("P249_______", $1683,$3323,$3632,$2530)
	%Player("P250__________", $2665,$6424,$2133,$3432)
	%Player("P251______", $2283,$4433,$2044,$4330)
	%Player("P252______", $2063,$3333,$3743,$3223)
	%Player("P253_______", $2992,$2312,$1521,$1122)
	%Player("P254________", $2791,$2221,$2922,$2125)
	%Player("P255_________", $1273,$3221,$2022,$2513)
	%Player("P256________", $2493,$3344,$4433,$4224)
	%Player("P257________", $3364,$3334,$2131,$3331)
	%Player("P258_______", $0672,$3242,$3631,$4143)
	%Player("P259__________", $0293,$2232,$2421,$4224)
	%Player("P260________", $03C2,$2132,$3420,$3424)
	%Player("P261_____________", $0472,$3133,$3630,$3522)
	%Player("P262________", $2392,$2122,$2520,$1312)
	%Player("P263______", $0572,$2032,$3420,$3514)
	%Player("P264__________", $3991,$1022,$2820,$3525)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Dallas")
.ta:								; abbreviation
	%String("DAL")
.tm:								; nickname
	%String("N09__")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P265_______", $3366,$4446,$0000,$5566)
	%Player("P266_________", $3742,$3333,$0000,$2222)
	%Player("P267_______", $1194,$4444,$4444,$4143)
	%Player("P268__________", $4754,$4433,$2145,$4031)
	%Player("P269________", $1855,$4433,$2353,$3043)
	%Player("P270__________", $2164,$3242,$4141,$3341)
	%Player("P271______________", $2564,$4433,$2053,$4243)
	%Player("P272__________", $4583,$4333,$2433,$3232)
	%Player("P273________", $17B3,$4333,$3033,$3222)
	%Player("P274_________", $2262,$2322,$2223,$2222)
	%Player("P275_________", $3261,$1112,$3813,$1314)
	%Player("P276_________", $2384,$4434,$2344,$4242)
	%Player("P277______", $1253,$4432,$3323,$3033)
	%Player("P278_______", $2654,$4323,$2933,$3232)
	%Player("P279_____", $36B1,$1211,$3712,$2314)
	%Player("P280____", $3182,$2212,$3322,$1421)
	%Player("P281___________", $2894,$3343,$4342,$4233)
	%Player("P282__________", $2773,$4333,$3442,$4243)
	%Player("P283_____________", $4353,$3333,$3722,$4323)
	%Player("P284________", $1462,$2231,$2612,$4523)
	%Player("P285______", $0593,$2233,$4731,$3534)
	%Player("P286___________", $4864,$3244,$3432,$4422)
	%Player("P287________", $2493,$2242,$3620,$3324)
	%Player("P288___________", $3492,$2122,$3921,$2313)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Montreal")
.ta:								; abbreviation
	%String("MTL")
.tm:								; nickname
	%String("N10______")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P289_________", $3124,$4443,$0000,$3333)
	%Player("P290____________", $0143,$4221,$0000,$2222)
	%Player("P291__________", $2064,$3443,$3144,$3242)
	%Player("P292___________", $1963,$3433,$1342,$3043)
	%Player("P293_________", $2694,$3343,$3044,$3241)
	%Player("P294________", $3492,$2322,$2222,$2232)
	%Player("P295____________", $2564,$4433,$1043,$3143)
	%Player("P296________", $1593,$3344,$3733,$4423)
	%Player("P297_______", $16A3,$4333,$3333,$4533)
	%Player("P298_______", $0992,$2321,$2332,$2232)
	%Player("P299_________", $08A2,$2221,$1824,$1313)
	%Player("P300___________", $4494,$4435,$2143,$4432)
	%Player("P301__________", $22B4,$4434,$3732,$4334)
	%Player("P302_______", $1292,$2323,$2333,$2323)
	%Player("P303_______", $2162,$2222,$2922,$3424)
	%Player("P304__________", $1862,$3332,$2623,$2223)
	%Player("P305_____", $1183,$3233,$3323,$3222)
	%Player("P306_________", $04B4,$4344,$5642,$5043)
	%Player("P307____________", $02B4,$2244,$4441,$3044)
	%Player("P308________", $2363,$3342,$3432,$4232)
	%Player("P309____________", $2793,$3333,$3432,$3132)
	%Player("P310_______", $03A2,$2141,$4620,$4414)
	%Player("P311_________", $0673,$2232,$2230,$3322)
	%Player("P312__________", $0571,$1011,$1210,$1303)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("New Jersey")
.ta:								; abbreviation
	%String("NJ")
.tm:								; nickname
	%String("N11___")
.ar:								; arena
	%String("Meadowlands Arena")
NewYorkI:							; team record: New York (NYI), team 13
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P313_______", $3552,$4442,$0000,$2222)
	%Player("P314__________", $7794,$4534,$3445,$5141)
	%Player("P315________", $3374,$5433,$2445,$4143)
	%Player("P316_________", $1843,$3322,$2333,$3022)
	%Player("P317________", $3982,$2322,$3121,$2322)
	%Player("P318_______", $2063,$3334,$2643,$4333)
	%Player("P319___________", $1083,$2211,$3833,$1524)
	%Player("P320________", $3264,$4433,$4433,$4243)
	%Player("P321______", $2793,$2434,$1445,$4222)
	%Player("P322______", $2564,$4322,$1242,$4532)
	%Player("P323___________", $2683,$2432,$3342,$4042)
	%Player("P324________", $1663,$3333,$2433,$4531)
	%Player("P325_________", $15B1,$2321,$1524,$2123)
	%Player("P326_______", $1282,$3111,$1911,$2414)
	%Player("P327_____________", $23A3,$3434,$3432,$4233)
	%Player("P328_____________", $1174,$3233,$4431,$3234)
	%Player("P329_______", $0883,$3432,$2422,$4132)
	%Player("P330_____", $04E2,$2343,$3322,$4132)
	%Player("P331_______", $2883,$3434,$2631,$4132)
	%Player("P332__________", $0782,$2243,$3432,$4133)
	%Player("P333________", $37A1,$1212,$2611,$1113)
	%Player("P334_________", $4793,$3123,$3821,$2515)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("New York")
.ta:								; abbreviation
	%String("NYI")
.tm:								; nickname
	%String("N12______")
.ar:								; arena
	%String("Nassau Coliseum")
NewYorkR:							; team record: New York (NYR), team 14
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P335________", $3573,$4443,$0000,$4444)
	%Player("P336________", $11A5,$4443,$5453,$4053)
	%Player("P337____________", $1364,$3353,$4034,$5232)
	%Player("P338___________", $0864,$4433,$2443,$4432)
	%Player("P339_____", $1294,$3334,$2443,$3442)
	%Player("P340________", $1095,$5344,$5442,$4443)
	%Player("P341_______", $0964,$4432,$3633,$4534)
	%Player("P342________", $2982,$4232,$4832,$3222)
	%Player("P343______", $2083,$3232,$2233,$3031)
	%Player("P344________", $2275,$5445,$2353,$5552)
	%Player("P345_______", $3364,$4433,$1333,$4332)
	%Player("P346__________", $2774,$3333,$1034,$3433)
	%Player("P347_______", $3771,$1231,$2312,$2312)
	%Player("P348______", $2682,$1132,$3921,$2424)
	%Player("P349________", $1872,$3101,$3611,$1514)
	%Player("P350________", $0266,$3444,$2651,$5252)
	%Player("P351_________", $0394,$4344,$4341,$4243)
	%Player("P352________", $2173,$3343,$3332,$3130)
	%Player("P353__________", $23B2,$2242,$3720,$3024)
	%Player("P354______", $0484,$3243,$4241,$3133)
	%Player("P355___________", $0592,$3322,$2231,$2432)
	%Player("P356_____", $24A2,$2222,$3620,$2124)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("New York")
.ta:								; abbreviation
	%String("NYR")
.tm:								; nickname
	%String("N13____")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P357____________", $3162,$3112,$0000,$2222)
	%Player("P358_____________", $3213,$3112,$0000,$2222)
	%Player("P359_______", $1373,$3333,$2433,$4232)
	%Player("P360_____", $0764,$3242,$3031,$3333)
	%Player("P361______", $1292,$2332,$2622,$3133)
	%Player("P362______", $1162,$2332,$2423,$4322)
	%Player("P363___________", $1664,$2242,$3432,$3523)
	%Player("P364___________", $1572,$2232,$1622,$3522)
	%Player("P365______", $1891,$2222,$3621,$2412)
	%Player("P366___________", $6194,$4333,$2432,$3523)
	%Player("P367_______", $4492,$2232,$3A13,$3525)
	%Player("P368______", $0953,$3232,$2621,$2423)
	%Player("P369_______", $2863,$3312,$2833,$1522)
	%Player("P370________", $1062,$2122,$1612,$2424)
	%Player("P371________", $2693,$3333,$2334,$3432)
	%Player("P372_____", $1792,$2332,$3122,$3321)
	%Player("P373_________", $2092,$2332,$3522,$2122)
	%Player("P374_________", $2572,$2222,$1632,$2513)
	%Player("P375________", $2263,$3443,$3022,$4133)
	%Player("P376_____", $0473,$2333,$2331,$3232)
	%Player("P377_________", $3492,$2232,$3420,$3423)
	%Player("P378________", $2362,$2131,$1320,$2423)
	%Player("P379_______", $0573,$2132,$3621,$3513)
	%Player("P380_______", $0681,$1221,$2311,$2513)
	%Player("P381______", $14B2,$2031,$3610,$2522)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Ottawa")
.ta:								; abbreviation
	%String("OTW")
.tm:								; nickname
	%String("N14_____")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P382____________", $3034,$4554,$0000,$3434)
	%Player("P383___________", $3363,$3333,$0000,$3322)
	%Player("P384____________", $3572,$3001,$0100,$2222)
	%Player("P385________", $88C4,$3444,$5946,$5244)
	%Player("P386__________", $1794,$3444,$3444,$4243)
	%Player("P387________", $0955,$4433,$3243,$4041)
	%Player("P388_________", $4263,$3332,$1033,$3433)
	%Player("P389_______", $2542,$2243,$4032,$4232)
	%Player("P390_____________", $2262,$2222,$2620,$2123)
	%Player("P391_______", $1882,$2433,$3323,$3122)
	%Player("P392______", $1562,$2222,$2423,$2223)
	%Player("P393__________", $1473,$3222,$2631,$2531)
	%Player("P394_________", $1091,$1212,$2814,$1214)
	%Player("P395_______", $0865,$4534,$3445,$4143)
	%Player("P396________", $1174,$5342,$2733,$4534)
	%Player("P397______", $2191,$1021,$2910,$2513)
	%Player("P398________", $0372,$2342,$3631,$3233)
	%Player("P399______________", $0274,$3343,$2431,$4333)
	%Player("P400________", $2074,$3333,$2432,$3133)
	%Player("P401_________", $29A2,$2232,$3621,$3024)
	%Player("P402________", $05A2,$2332,$2523,$3322)
	%Player("P403_______", $2782,$2232,$2721,$3414)
	%Player("P404________", $44A1,$1111,$2C13,$1513)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Philadelphia")
.ta:								; abbreviation
	%String("PHI")
.tm:								; nickname
	%String("N15___")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P405________", $35A4,$4554,$0100,$4444)
	%Player("P406_______", $3182,$3442,$0000,$3232)
	%Player("P407_________", $66A5,$4644,$3366,$6062)
	%Player("P408_______", $1094,$3444,$4443,$4042)
	%Player("P409___________", $1573,$3333,$2433,$4332)
	%Player("P410__________", $2663,$2222,$2121,$2530)
	%Player("P411_________", $25B3,$4533,$3644,$5344)
	%Player("P412________", $1462,$3232,$2422,$3122)
	%Player("P413________", $2092,$2122,$2623,$2421)
	%Player("P414________", $68A5,$4433,$4453,$4142)
	%Player("P415________", $2292,$2544,$3735,$4134)
	%Player("P416______", $0764,$3433,$3145,$4230)
	%Player("P417_________", $8253,$3322,$2222,$2032)
	%Player("P418________", $3962,$2222,$2523,$2521)
	%Player("P419________", $16E1,$2011,$3B10,$1314)
	%Player("P420________", $55A4,$3454,$3342,$5143)
	%Player("P421__________", $0584,$4353,$5630,$4135)
	%Player("P422____", $0282,$3222,$2421,$3122)
	%Player("P423________", $2383,$3234,$3321,$3543)
	%Player("P424____________", $3292,$2233,$4430,$4324)
	%Player("P425_______", $0683,$2232,$3622,$3122)
	%Player("P426____________", $28E2,$2134,$4731,$4523)
	%Player("P427__________", $0392,$2132,$3820,$2313)
	%Player("P428_________", $3381,$1211,$2220,$1011)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Pittsburgh")
.ta:								; abbreviation
	%String("PIT")
.tm:								; nickname
	%String("N16_____")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P429_______", $2774,$4444,$0000,$4433)
	%Player("P430__________", $3553,$4332,$0000,$2222)
	%Player("P431_____", $1964,$4544,$2045,$5252)
	%Player("P432______", $0974,$4433,$3435,$3043)
	%Player("P433___________", $4753,$3342,$2432,$3123)
	%Player("P434___________", $2553,$2323,$1433,$3132)
	%Player("P435___________", $3184,$4435,$2543,$4142)
	%Player("P436__________", $44B1,$3222,$2423,$2222)
	%Player("P437_________", $2292,$2222,$3624,$3524)
	%Player("P438_______", $12D1,$1101,$2811,$0515)
	%Player("P439______", $15A1,$1101,$1C10,$1414)
	%Player("P440_______", $1374,$4544,$1345,$4043)
	%Player("P441______", $1184,$4434,$1744,$4334)
	%Player("P442____________", $5133,$4433,$3434,$4132)
	%Player("P443_______", $4873,$3343,$2133,$3431)
	%Player("P444__________", $2884,$4444,$2442,$4142)
	%Player("P445_____________", $0793,$4342,$3423,$4032)
	%Player("P446__________", $0563,$3333,$3033,$4032)
	%Player("P447_________", $0293,$3333,$3631,$3223)
	%Player("P448______", $5262,$2241,$3321,$3224)
	%Player("P449_______", $2982,$2233,$3622,$3424)
	%Player("P450_____________", $0483,$3225,$4641,$2443)
	%Player("P451_________", $0692,$2221,$2811,$2114)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Quebec")
.ta:								; abbreviation
	%String("QUE")
.tm:								; nickname
	%String("N17______")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P452_______", $3252,$4443,$0000,$3322)
	%Player("P453________", $3052,$3112,$0000,$2222)
	%Player("P454_________", $0162,$3002,$0000,$2222)
	%Player("P455_______", $1162,$2443,$3334,$4033)
	%Player("P456________", $3763,$3333,$2323,$4531)
	%Player("P457_______", $1261,$1232,$3323,$3323)
	%Player("P458_________", $4762,$3232,$1021,$4521)
	%Player("P459_________", $1674,$4222,$3322,$2533)
	%Player("P460___________", $1063,$3422,$1033,$3122)
	%Player("P461_______", $3691,$2322,$2623,$3415)
	%Player("P462_______", $2042,$2222,$2821,$2523)
	%Player("P463_______", $2581,$1112,$3820,$1414)
	%Player("P464_______", $1774,$4323,$1342,$4531)
	%Player("P465________", $3992,$2331,$1313,$2121)
	%Player("P466_________", $1882,$2322,$2623,$2522)
	%Player("P467_______", $2474,$3336,$3641,$3343)
	%Player("P468__________", $0573,$3132,$3530,$4443)
	%Player("P469___________", $0673,$3333,$3632,$4233)
	%Player("P470________", $4141,$2322,$2522,$2432)
	%Player("P471_______", $19C2,$2232,$3621,$3524)
	%Player("P472____", $0473,$2134,$3331,$3534)
	%Player("P473_______", $2192,$2132,$3621,$3422)
	%Player("P474_______", $0272,$2132,$2430,$3434)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("San Jose")
.ta:								; abbreviation
	%String("SJ")
.tm:								; nickname
	%String("N18___")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P475_________", $3164,$4664,$0000,$3344)
	%Player("P476________", $1574,$3543,$2044,$4040)
	%Player("P477__________", $0744,$4433,$2343,$4132)
	%Player("P478______", $2263,$3342,$4533,$4343)
	%Player("P479______", $1863,$3241,$2022,$4322)
	%Player("P480______", $2843,$4222,$4833,$2323)
	%Player("P481__________", $3662,$2222,$1621,$2513)
	%Player("P482________", $3872,$2232,$2021,$3021)
	%Player("P483_______", $1792,$2222,$2C21,$3415)
	%Player("P484____________", $19A3,$3544,$2745,$4244)
	%Player("P485______", $1694,$4536,$3353,$4432)
	%Player("P486________", $1474,$3343,$3733,$4333)
	%Player("P487_______", $2373,$3241,$2322,$4523)
	%Player("P488_______", $3981,$1121,$1911,$2315)
	%Player("P489______", $2193,$3445,$2343,$5142)
	%Player("P490_________", $0592,$3242,$4731,$4434)
	%Player("P491_________", $0672,$2332,$2623,$4032)
	%Player("P492______", $0482,$2233,$2320,$4023)
	%Player("P493____________", $33B2,$2142,$3730,$4433)
	%Player("P494_______", $2082,$2231,$3822,$3224)
	%Player("P495________", $4482,$2112,$3620,$1322)
	%Player("P496______", $0253,$2131,$2220,$3312)
	%Player("P497________", $34A3,$3122,$2621,$2513)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("St. Louis")
.ta:								; abbreviation
	%String("STL")
.tm:								; nickname
	%String("N19__")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P498_________", $0163,$3223,$0000,$3233)
	%Player("P499_________", $3552,$3222,$0100,$2222)
	%Player("P500_________", $3072,$3222,$0000,$1111)
	%Player("P501_________", $1944,$3434,$3335,$4233)
	%Player("P502________", $1683,$3433,$3035,$4330)
	%Player("P503__________", $10A3,$2322,$3422,$3433)
	%Player("P504_______", $2873,$3332,$2132,$3324)
	%Player("P505______", $1852,$3332,$2522,$3223)
	%Player("P506________", $1153,$3132,$4433,$3231)
	%Player("P507____________", $1762,$2332,$1324,$2212)
	%Player("P508____________", $3462,$4232,$1032,$4530)
	%Player("P509_______", $0792,$3322,$3432,$3322)
	%Player("P510_________", $37A2,$2232,$3021,$3422)
	%Player("P511_______", $1492,$3333,$2332,$3233)
	%Player("P512_______", $2473,$3332,$2122,$3421)
	%Player("P513________", $2182,$2132,$2321,$3522)
	%Player("P514_______", $2771,$2102,$2312,$0512)
	%Player("P515_____", $0293,$3332,$2322,$3323)
	%Player("P516_________", $4473,$2233,$2431,$3423)
	%Player("P517__________", $2292,$2332,$2221,$3222)
	%Player("P518_________", $2562,$2223,$3420,$3322)
	%Player("P519______", $29B3,$2223,$2630,$3223)
	%Player("P520________", $4061,$1211,$0210,$1114)
	%Player("P521_______", $2691,$1211,$2910,$1304)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Tampa Bay")
.ta:								; abbreviation
	%String("TB")
.tm:								; nickname
	%String("N20______")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P522________", $2964,$4664,$0000,$4444)
	%Player("P523_______", $0193,$4552,$0100,$2233)
	%Player("P524________", $9345,$4554,$4444,$6043)
	%Player("P525_______", $1974,$3433,$2344,$4143)
	%Player("P526___________", $2693,$3342,$3434,$4322)
	%Player("P527_______", $2593,$3333,$4033,$4141)
	%Player("P528_________", $0773,$2231,$3433,$3532)
	%Player("P529___________", $14B3,$3444,$4334,$5432)
	%Player("P530________", $1783,$3335,$4643,$4344)
	%Player("P531________", $2192,$2242,$3422,$4413)
	%Player("P532_____", $1072,$2232,$3423,$4523)
	%Player("P533______________", $1664,$4423,$2044,$4241)
	%Player("P534__________", $0974,$4433,$2643,$4143)
	%Player("P535_______", $1262,$2331,$1123,$4524)
	%Player("P536________", $7182,$2232,$5533,$3523)
	%Player("P537__________", $2292,$2021,$2A10,$2324)
	%Player("P538_____", $2363,$3332,$4422,$4123)
	%Player("P539_______", $0494,$4345,$4441,$4242)
	%Player("P540___________", $1573,$2333,$1232,$3132)
	%Player("P541____________", $55A2,$2332,$3522,$3023)
	%Player("P542________", $3483,$3244,$4431,$4442)
	%Player("P543_____", $03A3,$3242,$4320,$4423)
	%Player("P544____________", $0292,$2131,$3420,$4433)
	%Player("P545______", $0882,$2023,$3523,$2324)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Toronto")
.ta:								; abbreviation
	%String("TOR")
.tm:								; nickname
	%String("N21________")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P546_______", $0184,$4444,$0000,$4433)
	%Player("P547________", $3552,$3552,$0000,$2323)
	%Player("P548_________", $0755,$5432,$2043,$5141)
	%Player("P549_______", $1952,$2432,$1036,$4233)
	%Player("P550______", $15A2,$2332,$2223,$3022)
	%Player("P551___________", $1475,$5433,$1443,$3244)
	%Player("P552_________", $3263,$3433,$3434,$3031)
	%Player("P553______", $0873,$3443,$3235,$4131)
	%Player("P554__________", $27B4,$3333,$4623,$4424)
	%Player("P555_______", $29B2,$2232,$3A21,$3326)
	%Player("P556______", $2372,$2232,$3623,$3323)
	%Player("P557______", $1055,$6544,$2054,$4442)
	%Player("P558_________", $1694,$4444,$3344,$4342)
	%Player("P559______", $1792,$3333,$2125,$3123)
	%Player("P560_______", $25B1,$2333,$2922,$3324)
	%Player("P561______", $2692,$2122,$3923,$2324)
	%Player("P562_______", $2174,$3342,$3441,$4142)
	%Player("P563________", $0393,$3233,$4341,$4142)
	%Player("P564__________", $0672,$2332,$3622,$3023)
	%Player("P565______", $24A3,$3333,$2631,$4134)
	%Player("P566_________", $04A3,$3234,$4731,$3434)
	%Player("P567_______", $44B2,$2343,$2630,$4233)
	%Player("P568_______", $0592,$3234,$4621,$4424)
	%Player("P569_______", $22B2,$2132,$3632,$3324)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Vancouver")
.ta:								; abbreviation
	%String("VAN")
.tm:								; nickname
	%String("N22____")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P570_______", $3534,$4554,$0000,$4444)
	%Player("P571_______", $3062,$3222,$0000,$2222)
	%Player("P572__________", $1075,$3433,$3054,$4152)
	%Player("P573________", $2584,$3433,$3444,$4053)
	%Player("P574___________", $3843,$3332,$3134,$3232)
	%Player("P575_______", $3673,$3242,$5422,$5123)
	%Player("P576______", $1452,$3332,$2323,$3421)
	%Player("P577__________", $3492,$2343,$4034,$4033)
	%Player("P578_________", $0793,$2334,$3623,$4424)
	%Player("P579_____", $17A3,$3242,$3622,$4324)
	%Player("P580_________", $2163,$2122,$3623,$2522)
	%Player("P581_________", $2392,$2221,$3220,$2030)
	%Player("P582_________", $1365,$6534,$3345,$5442)
	%Player("P583__________", $1164,$4334,$1334,$3532)
	%Player("P584______", $1592,$2332,$3322,$3122)
	%Player("P585__________", $1852,$3332,$3322,$3121)
	%Player("P586____", $2092,$2232,$3923,$4126)
	%Player("P587________", $0666,$5433,$2462,$4062)
	%Player("P588__________", $2774,$3353,$3142,$4132)
	%Player("P589____________", $0494,$3434,$1142,$3141)
	%Player("P590_________", $0363,$3243,$4431,$4233)
	%Player("P591_______", $0592,$2242,$3621,$4024)
	%Player("P592______", $2293,$2132,$2420,$4523)
	%Player("P593________", $2692,$2132,$3320,$4423)
	%Player("P594_________", $0892,$2122,$3621,$2522)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Winnipeg")
.ta:								; abbreviation
	%String("WPG")
.tm:								; nickname
	%String("N23_")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P595_______", $3343,$4333,$0000,$3333)
	%Player("P596__________", $3162,$3112,$0000,$3322)
	%Player("P597_______", $1794,$4433,$2044,$4042)
	%Player("P598_____________", $0873,$3434,$3146,$4142)
	%Player("P599_______", $3282,$2443,$4624,$4044)
	%Player("P600__________", $2083,$3433,$3443,$4043)
	%Player("P601____________", $2262,$2222,$3222,$2222)
	%Player("P602_________", $1572,$2212,$2622,$1322)
	%Player("P603_________", $1174,$4333,$2432,$3443)
	%Player("P604________", $2162,$3232,$2422,$3512)
	%Player("P605____", $1692,$2233,$3722,$3425)
	%Player("P606________", $1264,$6433,$2044,$4232)
	%Player("P607_______", $1963,$3333,$2335,$3122)
	%Player("P608________", $1084,$4333,$2043,$3241)
	%Player("P609_______", $2672,$2222,$3323,$2234)
	%Player("P610__________", $2392,$2232,$4724,$3323)
	%Player("P611_________", $04C3,$3445,$4342,$4443)
	%Player("P612______", $34B4,$4446,$4642,$4444)
	%Player("P613________", $0363,$3343,$3132,$4432)
	%Player("P614___________", $0694,$3344,$3441,$4142)
	%Player("P615__________", $14A3,$3233,$3431,$3532)
	%Player("P616__________", $3692,$2122,$3621,$2331)
	%Player("P617_________", $2562,$2111,$2220,$1212)
	%Player("P618_______", $05B3,$2022,$3230,$2323)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Washington")
.ta:								; abbreviation
	%String("WSH")
.tm:								; nickname
	%String("N24_____")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P619___________", $3453,$4553,$0000,$3434)
	%Player("P620___________", $3072,$4223,$0000,$2222)
	%Player("P621__________", $1482,$2232,$2122,$3222)
	%Player("P622__________", $2791,$1333,$4723,$3324)
	%Player("P623___________", $3984,$2242,$4633,$4434)
	%Player("P624______", $1873,$2333,$2432,$3233)
	%Player("P625______", $1082,$2232,$3622,$3424)
	%Player("P626__________", $2374,$3323,$1233,$3242)
	%Player("P627________", $2072,$2132,$3221,$3521)
	%Player("P628__________", $2941,$2312,$2022,$1421)
	%Player("P629________", $2271,$2222,$2022,$2421)
	%Player("P630_______", $06A3,$3223,$2922,$3323)
	%Player("P631_____________", $21A2,$3222,$3822,$3512)
	%Player("P632_______", $2885,$4234,$4931,$3333)
	%Player("P633______", $2642,$2221,$3222,$2522)
	%Player("P634_______", $4383,$2112,$3821,$2224)
	%Player("P635___________", $2593,$3333,$3332,$3322)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Florida")
.ta:								; abbreviation
	%String("FLA")
.tm:								; nickname
	%String("N25_____")
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
.pld:								; player data: one player per row, ended by an empty String
	%Player("P636______", $2962,$3332,$0000,$2222)
	%Player("P637_______", $0122,$3331,$0000,$1112)
	%Player("P638_______", $2772,$2322,$1323,$3422)
	%Player("P639______", $24A2,$3232,$4621,$3213)
	%Player("P640_______", $23B1,$1021,$3A11,$2514)
	%Player("P641______", $2563,$3433,$3334,$4032)
	%Player("P642______", $30A2,$2132,$2322,$3522)
	%Player("P643___________", $2073,$3343,$2033,$4032)
	%Player("P644________", $2862,$3322,$2623,$2222)
	%Player("P645______", $26B2,$2112,$1514,$1323)
	%Player("P646_______", $4152,$2322,$1022,$1411)
	%Player("P647____________", $07B4,$3234,$4441,$3142)
	%Player("P648_____", $3882,$2222,$3521,$2314)
	%Player("P649___________", $39B3,$3131,$2421,$3514)
	%Player("P650__________", $0382,$2222,$2520,$2213)
	%Player("P651________", $33B3,$2332,$3422,$2421)
	%Player("P652________", $32B2,$1121,$2110,$2111)
	%Player("P653_______", $17B1,$1121,$3810,$2113)
	dw 2							; end of player data: empty String
.tn:								; city
	%String("Anaheim")
.ta:								; abbreviation
	%String("ANH")
.tm:								; nickname
	%String("N26_________")
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
