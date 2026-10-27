; per team (TeamList order) 26 long pointers to packed player photos
PlayerPhotoTable:					; per team (TeamList order) 26 long pointers to packed player photos
	dd Card108,NoPicGoalie,NoPicSkater1,Card006,NoPicSkater2,Card063,NoPicSkater3	; Anaheim
	dd Card071,NoPicSkater1,NoPicSkater3,NoPicSkater2,Card069,NoPicSkater3,Card115
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card036,NoPicGoalie,Card087,NoPicSkater1,NoPicSkater3,NoPicSkater2,Card078	; Boston
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card101,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,Card090,Card119,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd Card096,NoPicGoalie,NoPicGoalie,Card111,Card049,NoPicSkater1,NoPicSkater3	; Buffalo
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card116,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,Card053,Card058,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card017,NoPicGoalie,Card118,NoPicSkater1,NoPicSkater3,Card107,NoPicSkater2	; Calgary
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,Card033,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card004,Card032,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card011,NoPicGoalie,Card081,NoPicSkater2,NoPicSkater1,NoPicSkater3,Card054	; Chicago
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,Card024,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,Card112,Card095,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card003,NoPicGoalie,Card014,Card145,NoPicSkater3,NoPicSkater2,NoPicSkater1	; Dallas
	dd NoPicSkater3,NoPicSkater2,Card035,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,Card082,Card051,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd Card086,NoPicGoalie,Card117,Card002,NoPicSkater3,NoPicSkater2,NoPicSkater1	; Detroit
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,Card007,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2
org $9DD003
	dd NoPicSkater1,Card149,Card137,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd Card099,Card074,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2	; Edmonton
	dd Card018,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,Card022
	dd NoPicSkater2,Card043,Card110,NoPicSkater1,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card020,NoPicGoalie,NoPicSkater1,Card092,Card050,NoPicSkater1,NoPicSkater3	; Florida
	dd Card009,NoPicSkater1,NoPicSkater3,NoPicSkater2,Card038,NoPicSkater3,Card025
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card076,NoPicGoalie,NoPicGoalie,Card131,NoPicSkater1,NoPicSkater3,NoPicSkater2	; Hartford
	dd Card056,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card060,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,Card102,Card057,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card031,NoPicGoalie,NoPicGoalie,Card030,NoPicSkater3,NoPicSkater2,NoPicSkater1	; LosAngeles
	dd Card073,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card028,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,Card012,Card023,NoPicSkater3,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd Card142,NoPicGoalie,Card136,NoPicSkater1,NoPicSkater3,NoPicSkater2,Card027	; Montreal
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card068,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,Card094,Card125,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card153,NoPicGoalie,Card121,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2	; NewJersey
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card155,Card013,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,Card084,Card040,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card093,Card140,Card098,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1	; NewYorkI
	dd Card052,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card132,Card021,NoPicSkater3,NoPicSkater2,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card146,Card064,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card016,NoPicSkater3	; NewYorkR
	dd NoPicSkater2,NoPicSkater1,Card070,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,Card005,Card041,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card001,NoPicGoalie,Card127,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1	; Ottawa
	dd NoPicSkater3,NoPicSkater2,Card109,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card134,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card129,Card123,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card045,NoPicGoalie,NoPicGoalie,Card075,Card089,NoPicSkater1,NoPicSkater3	; Philadelphia
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,Card048
	dd NoPicSkater2,NoPicSkater1,Card065,Card128,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card135,NoPicGoalie,Card154,NoPicSkater1,NoPicSkater3,NoPicSkater2,Card079	; Pittsburgh
	dd NoPicSkater1,NoPicSkater3,Card152,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,Card144,Card047,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card083,NoPicGoalie,Card105,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3	; Quebec
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,Card147,Card139,NoPicSkater1
	dd NoPicSkater3,Card120,Card010,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd Card055,NoPicGoalie,NoPicGoalie,Card059,NoPicSkater2,NoPicSkater1,NoPicSkater3	; SanJose
	dd NoPicSkater2,Card088,NoPicSkater1,NoPicSkater3,NoPicSkater2,Card046,NoPicSkater1
	dd NoPicSkater3,Card042,Card037,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd Card148,Card150,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1	; StLouis
	dd NoPicSkater3,NoPicSkater2,Card104,Card085,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card077,Card126,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card034,NoPicGoalie,NoPicGoalie,Card114,Card103,NoPicSkater2,NoPicSkater1	; TampaBay
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,Card133,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,Card039,Card143,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd Card097,NoPicGoalie,Card156,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1	; Toronto
	dd Card138,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card008,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,Card072,Card122,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card066,NoPicGoalie,Card113,NoPicSkater3,NoPicSkater1,Card062,NoPicSkater2	; Vancouver
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card061,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,Card124,Card019,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card029,NoPicGoalie,Card015,Card044,NoPicSkater1,NoPicSkater3,NoPicSkater2	; Washington
	dd NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card130,NoPicSkater3,NoPicSkater2
	dd NoPicSkater1,NoPicSkater3,Card080,Card067,NoPicSkater2,NoPicSkater1,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1
	dd Card100,NoPicGoalie,Card106,Card026,NoPicSkater2,NoPicSkater1,NoPicSkater3	; Winnipeg
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2,NoPicSkater1,Card141,NoPicSkater3
	dd NoPicSkater2,NoPicSkater1,NoPicSkater3,Card151,Card091,NoPicSkater2,NoPicSkater1
	dd NoPicSkater3,NoPicSkater2,NoPicSkater1,NoPicSkater3,NoPicSkater2
	dd Card142,Card096,Card135,Card154,Card064,Card136,Card087	; AllStarsEast
	dd Card105,Card140,Card111,Card079,Card152,Card130,Card070
	dd NoPicSkater1,Card116,Card048,Card144,Card090,Card005,Card120
	dd Card067,Card084,Card102,NoPicSkater3,NoPicSkater2
	dd Card011,Card086,Card097,Card117,Card014,Card081,Card114	; AllStarsWest
	dd Card156,Card030,Card107,Card073,Card033,Card085,Card061
	dd Card141,Card046,NoPicSkater1,Card004,Card077,Card149,Card112
	dd Card151,Card043,Card095,Card137,NoPicSkater3
