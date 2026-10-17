; More frames of SpriteFrames. A frame is the piece count, flags (bit 7: 16x16 tiles), tile
; count, the box of its pixels (left, right, top, bottom; nothing reads it), the two transfer
; sizes, the tile offset, the hot spot x / y (signed bytes, GetHot), the stick point x / y
; (GetFrameHot), the pieces, then the tiles. Frame labels are SpriteFrame_<group>_<n>.

SpriteFrame_Goalie_79:
	db $05,$80
	dw $000E
	dw -15,10,-27,10
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_79
	db $F9,$06,$F3,$04
	dw -10,-27,$0800 : db $FF
	dw -15,-11,$0802 : db $FF
	dw 1,-11,$0804 : db $FF
	dw -12,5,$0806 : db $00
	dw -4,5,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":57..505
SpriteFrame_Goalie_80:
	db $05,$80
	dw $000B
	dw -10,12,-25,6
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_80
	db $FE,$F8,$FE,$F8
	dw -10,-25,$0800 : db $FF
	dw -7,-9,$0802 : db $FF
	dw 6,-25,$0804 : db $00
	dw 6,-17,$0805 : db $00
	dw 9,-1,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":562..914
SpriteFrame_Goalie_81:
	db $03,$80
	dw $0009
	dw -8,9,-26,5
	dw $00A0,$0080
	dw .tiles-SpriteFrame_Goalie_81
	db $01,$F9,$01,$F9
	dw -8,-26,$0800 : db $FF
	dw -6,-10,$0802 : db $FF
	dw 8,-18,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":957..1245
SpriteFrame_Goalie_82:
	db $06,$80
	dw $000C
	dw -11,9,-25,7
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_82
	db $07,$FD,$07,$FD
	dw -6,-25,$0800 : db $FF
	dw -6,-9,$0802 : db $FF
	dw -14,-18,$0804 : db $00
	dw -14,-10,$0805 : db $00
	dw -14,-2,$0814 : db $00
	dw -14,6,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":1309..1693
SpriteFrame_Goalie_83:
	db $05,$80
	dw $000B
	dw -8,12,-26,6
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_83
	db $01,$00,$01,$00
	dw -8,-26,$0800 : db $FF
	dw -8,-10,$0802 : db $FF
	dw -8,6,$0804 : db $00
	dw 8,-15,$0805 : db $00
	dw 8,-7,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":1750..2102
SpriteFrame_Goalie_84:
	db $03,$80
	dw $000C
	dw -5,20,-27,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_84
	db $13,$FF,$13,$FF
	dw -5,-27,$0800 : db $FF
	dw -4,-11,$0802 : db $FF
	dw 12,-11,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":2145..2529
SpriteFrame_Goalie_85:
	db $04,$80
	dw $000A
	dw -5,16,-26,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_85
	db $0E,$00,$0E,$00
	dw -5,-26,$0800 : db $FF
	dw -5,-10,$0802 : db $FF
	dw 11,-10,$0804 : db $00
	dw 11,-2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":2579..2899
SpriteFrame_Goalie_86:
	db $03,$80
	dw $000C
	dw -9,20,-27,2
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_86
	db $13,$FC,$13,$FC
	dw -5,-27,$0800 : db $FF
	dw -9,-11,$0802 : db $FF
	dw 7,-11,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":2942..3326
SpriteFrame_Goalie_87:
	db $03,$80
	dw $000C
	dw -6,19,-27,1
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_87
	db $10,$FF,$10,$FF
	dw -4,-27,$0800 : db $FF
	dw -6,-11,$0802 : db $FF
	dw 10,-11,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":3369..3753
SpriteFrame_Goalie_88:
	db $05,$80
	dw $000E
	dw -9,20,-23,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_88
	db $11,$03,$11,$03
	dw -4,-23,$0800 : db $FF
	dw -9,-7,$0802 : db $FF
	dw 7,-7,$0804 : db $FF
	dw 12,-23,$0806 : db $00
	dw 12,-15,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":3810..4258

SpriteFrame_Goalie_89:
	db $04,$80
	dw $000A
	dw -10,14,-24,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_89
	db $0D,$04,$0D,$04
	dw -6,-24,$0800 : db $FF
	dw -10,-8,$0802 : db $FF
	dw 6,0,$0804 : db $00
	dw 14,0,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":4308..4628
SpriteFrame_Goalie_90:
	db $04,$80
	dw $000D
	dw -12,20,-25,6
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_90
	db $11,$04,$11,$04
	dw -6,-25,$0800 : db $FF
	dw -12,-9,$0802 : db $FF
	dw 4,-9,$0804 : db $FF
	dw 20,-1,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":4678..5094
SpriteFrame_Goalie_91:
	db $03,$80
	dw $000C
	dw -8,18,-25,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_91
	db $10,$02,$10,$02
	dw -6,-25,$0800 : db $FF
	dw -8,-9,$0802 : db $FF
	dw 8,-9,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":5137..5521
SpriteFrame_Goalie_92:
	db $05,$80
	dw $000B
	dw -11,10,-21,9
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_92
	db $01,$09,$01,$08
	dw -10,-21,$0800 : db $FF
	dw -11,-5,$0802 : db $FF
	dw 6,-21,$0804 : db $00
	dw 6,-13,$0805 : db $00
	dw 5,-5,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":5578..5930
SpriteFrame_Goalie_93:
	db $04,$80
	dw $000A
	dw -11,8,-25,9
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_93
	db $03,$09,$03,$09
	dw -10,-25,$0800 : db $FF
	dw -11,-9,$0802 : db $FF
	dw 6,-17,$0804 : db $00
	dw 1,7,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":5980..6300
SpriteFrame_Goalie_94:
	db $03,$80
	dw $0009
	dw -7,8,-24,9
	dw $00A0,$0080
	dw .tiles-SpriteFrame_Goalie_94
	db $06,$09,$06,$09
	dw -6,-24,$0800 : db $FF
	dw -7,-8,$0802 : db $FF
	dw 5,8,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":6343..6631
SpriteFrame_Goalie_95:
	db $04,$80
	dw $000A
	dw -5,11,-22,10
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_95
	db $07,$0A,$07,$0A
	dw -5,-22,$0800 : db $FF
	dw -4,-6,$0802 : db $FF
	dw 11,-14,$0804 : db $00
	dw 7,10,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":6681..7001
SpriteFrame_Goalie_96:
	db $06,$80
	dw $000C
	dw -12,10,-18,15
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_96
	db $F6,$0D,$F6,$0D
	dw -5,-18,$0800 : db $FF
	dw -5,-2,$0802 : db $FF
	dw -13,-16,$0804 : db $00
	dw -13,-8,$0805 : db $00
	dw -13,0,$0814 : db $00
	dw -13,8,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":7065..7449
SpriteFrame_Goalie_97:
	db $07,$80
	dw $000D
	dw -10,9,-23,14
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_97
	db $F7,$0D,$F7,$0D
	dw -10,-23,$0800 : db $FF
	dw -10,-7,$0802 : db $FF
	dw 6,-23,$0804 : db $00
	dw 6,-15,$0805 : db $00
	dw 6,-7,$0814 : db $00
	dw 6,1,$0815 : db $00
	dw -10,9,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":7520..7936
SpriteFrame_Goalie_98:
	db $05,$80
	dw $000B
	dw -12,9,-23,11
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_98
	db $F7,$0A,$F7,$0A
	dw -12,-23,$0800 : db $FF
	dw -12,-7,$0802 : db $FF
	dw -12,9,$0804 : db $00
	dw 4,-15,$0805 : db $00
	dw 4,-7,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":7993..8345

SpriteFrame_Goalie_99:
	db $07,$80
	dw $000D
	dw -13,7,-22,15
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_99
	db $F5,$0D,$F5,$0D
	dw -12,-22,$0800 : db $FF
	dw -12,-6,$0802 : db $FF
	dw 4,-22,$0804 : db $00
	dw 4,-14,$0805 : db $00
	dw 4,-6,$0814 : db $00
	dw 4,2,$0815 : db $00
	dw -13,10,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":8416..8832
SpriteFrame_Goalie_100:
	db $05,$80
	dw $000E
	dw -21,6,-18,10
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_100
	db $EC,$0A,$EC,$0A
	dw -13,-18,$0800 : db $FF
	dw -21,-2,$0802 : db $FF
	dw -5,-2,$0804 : db $FF
	dw 3,-18,$0806 : db $00
	dw 3,-10,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":8889..9337
SpriteFrame_Goalie_101:
	db $04,$80
	dw $000D
	dw -19,5,-22,11
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_101
	db $EE,$0A,$EE,$0A
	dw -10,-22,$0800 : db $FF
	dw -10,-6,$0802 : db $FF
	dw -26,-3,$0804 : db $FF
	dw -18,-11,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":9387..9803
SpriteFrame_Goalie_102:
	db $07,$80
	dw $0010
	dw -25,10,-21,10
	dw $0100,$0100
	dw .tiles-SpriteFrame_Goalie_102
	db $E8,$09,$E8,$09
	dw -18,-21,$0800 : db $FF
	dw -25,-5,$0802 : db $FF
	dw -9,-5,$0804 : db $FF
	dw -2,-21,$0806 : db $00
	dw -2,-13,$0807 : db $00
	dw 7,-5,$0816 : db $00
	dw 7,3,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":9874..10386
SpriteFrame_Goalie_103:
	db $04,$80
	dw $000D
	dw -23,6,-22,9
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_103
	db $EA,$09,$EA,$09
	dw -15,-22,$0800 : db $FF
	dw -23,-6,$0802 : db $FF
	dw -7,-6,$0804 : db $FF
	dw 1,-14,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":10436..10852
SpriteFrame_Goalie_104:
	db $03,$80
	dw $000C
	dw -24,7,-21,6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_104
	db $E9,$03,$E9,$03
	dw -24,-9,$0800 : db $FF
	dw -8,-9,$0802 : db $FF
	dw -14,-25,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":10895..11279
SpriteFrame_Goalie_105:
	db $03,$80
	dw $000C
	dw -25,4,-23,6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_105
	db $E8,$03,$E8,$03
	dw -15,-23,$0800 : db $FF
	dw -25,-7,$0802 : db $FF
	dw -9,-7,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":11322..11706
SpriteFrame_Goalie_106:
	db $06,$80
	dw $000F
	dw -25,10,-22,7
	dw $0100,$00E0
	dw .tiles-SpriteFrame_Goalie_106
	db $E8,$02,$E8,$02
	dw -14,-22,$0800 : db $FF
	dw -25,-6,$0802 : db $FF
	dw -9,-6,$0804 : db $FF
	dw 2,-14,$0806 : db $00
	dw 7,-6,$0807 : db $00
	dw 7,2,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":11770..12250
SpriteFrame_Goalie_107:
	db $03,$80
	dw $000C
	dw -23,8,-24,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_107
	db $EA,$FE,$EA,$FE
	dw -23,-11,$0800 : db $FF
	dw -7,-11,$0802 : db $FF
	dw -11,-27,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":12293..12677

SpriteFrame_Goalie_108:
	db $04,$80
	dw $0010
	dw -21,9,-25,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_Goalie_108
	db $F0,$FA,$F0,$FA
	dw -21,-25,$0800 : db $FF
	dw -5,-25,$0802 : db $FF
	dw -17,-9,$0804 : db $FF
	dw -1,-9,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":12727..13239
SpriteFrame_Goalie_109:
	db $04,$80
	dw $000A
	dw -17,3,-27,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_109
	db $F1,$F9,$F0,$F9
	dw -12,-27,$0800 : db $FF
	dw -12,-11,$0802 : db $FF
	dw -20,-19,$0804 : db $00
	dw -20,-11,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":13289..13609
SpriteFrame_Goalie_110:
	db $05,$80
	dw $000E
	dw -16,9,-25,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_110
	db $F1,$FB,$F1,$FB
	dw -14,-25,$0800 : db $FF
	dw -16,-9,$0802 : db $FF
	dw 0,-9,$0804 : db $FF
	dw 2,-25,$0806 : db $00
	dw 2,-17,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":13666..14114
SpriteFrame_Goalie_111:
	db $05,$80
	dw $000E
	dw -15,10,-26,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_111
	db $F3,$FB,$F3,$FB
	dw -15,-26,$0800 : db $FF
	dw 1,-26,$0802 : db $FF
	dw -14,-10,$0804 : db $FF
	dw 2,-10,$0806 : db $00
	dw 2,-2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":14171..14619
SpriteFrame_gready_0:
	db $04,$80
	dw $000D
	dw -13,12,-24,2
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gready_0
	db $00,$FB,$00,$FB
	dw -13,-24,$0800 : db $FF
	dw 3,-24,$0802 : db $FF
	dw -8,-8,$0804 : db $FF
	dw 8,0,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":14669..15085
SpriteFrame_gready_1:
	db $05,$80
	dw $000E
	dw -13,13,-26,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gready_1
	db $00,$FB,$00,$FB
	dw -13,-26,$0800 : db $FF
	dw 3,-26,$0802 : db $FF
	dw -12,-10,$0804 : db $FF
	dw 4,-10,$0806 : db $00
	dw 4,-2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":15142..15590
SpriteFrame_gready_2:
	db $03,$80
	dw $0009
	dw -5,15,-26,4
	dw $00A0,$0080
	dw .tiles-SpriteFrame_gready_2
	db $03,$FC,$03,$FC
	dw -3,-26,$0800 : db $FF
	dw -5,-10,$0802 : db $FF
	dw 13,-18,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":15633..15921
SpriteFrame_gready_3:
	db $03,$80
	dw $0009
	dw -5,15,-26,4
	dw $00A0,$0080
	dw .tiles-SpriteFrame_gready_3
	db $03,$FD,$03,$FD
	dw -3,-26,$0800 : db $FF
	dw -5,-10,$0802 : db $FF
	dw 13,-18,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":15964..16252
SpriteFrame_gready_4:
	db $04,$80
	dw $000A
	dw -10,10,-25,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gready_4
	db $08,$FE,$08,$FE
	dw -9,-25,$0800 : db $FF
	dw -10,-9,$0802 : db $FF
	dw 6,-9,$0804 : db $00
	dw 6,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":16302..16622

SpriteFrame_gready_5:
	db $04,$80
	dw $000A
	dw -10,10,-23,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gready_5
	db $08,$FE,$08,$FE
	dw -9,-23,$0800 : db $FF
	dw -10,-7,$0802 : db $FF
	dw 6,-7,$0804 : db $00
	dw 6,1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":16672..16992
SpriteFrame_gready_6:
	db $06,$80
	dw $000C
	dw -10,13,-27,1
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gready_6
	db $09,$00,$09,$00
	dw -10,-27,$0800 : db $FF
	dw -8,-11,$0802 : db $FF
	dw 6,-27,$0804 : db $00
	dw 6,-19,$0805 : db $00
	dw 8,-11,$0814 : db $00
	dw 8,-3,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":17056..17440
SpriteFrame_gready_7:
	db $05,$80
	dw $000B
	dw -9,14,-27,1
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_gready_7
	db $0A,$FF,$0A,$FF
	dw -9,-27,$0800 : db $FF
	dw -7,-11,$0802 : db $FF
	dw 7,-19,$0804 : db $00
	dw 9,-11,$0805 : db $00
	dw 9,-3,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":17497..17849
SpriteFrame_gready_8:
	db $05,$80
	dw $000E
	dw -14,11,-22,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gready_8
	db $04,$05,$04,$05
	dw -14,-22,$0800 : db $FF
	dw 2,-22,$0802 : db $FF
	dw -9,-6,$0804 : db $FF
	dw 7,-6,$0806 : db $00
	dw 7,2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":17906..18354
SpriteFrame_gready_9:
	db $05,$80
	dw $000E
	dw -14,11,-22,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gready_9
	db $04,$05,$04,$05
	dw -14,-22,$0800 : db $FF
	dw 2,-22,$0802 : db $FF
	dw -9,-6,$0804 : db $FF
	dw 7,-6,$0806 : db $00
	dw 7,2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":18411..18859
SpriteFrame_gready_10:
	db $05,$80
	dw $000B
	dw -14,9,-21,8
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_gready_10
	db $FE,$06,$FE,$06
	dw -14,-21,$0800 : db $FF
	dw -8,-5,$0802 : db $FF
	dw 2,-21,$0804 : db $00
	dw 2,-13,$0805 : db $00
	dw 8,-5,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":18916..19268
SpriteFrame_gready_11:
	db $06,$80
	dw $000C
	dw -15,9,-21,8
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gready_11
	db $FD,$06,$FD,$06
	dw -15,-21,$0800 : db $FF
	dw -9,-5,$0802 : db $FF
	dw 1,-21,$0804 : db $00
	dw 1,-13,$0805 : db $00
	dw 7,-5,$0814 : db $00
	dw 7,3,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":19332..19716
SpriteFrame_gready_12:
	db $02,$80
	dw $0008
	dw -8,7,-26,5
	dw $0080,$0080
	dw .tiles-SpriteFrame_gready_12
	db $FA,$03,$FA,$03
	dw -8,-26,$0800 : db $FF
	dw -8,-10,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":19752..20008
SpriteFrame_gready_13:
	db $02,$80
	dw $0008
	dw -8,7,-26,5
	dw $0080,$0080
	dw .tiles-SpriteFrame_gready_13
	db $FA,$03,$FA,$03
	dw -8,-26,$0800 : db $FF
	dw -8,-10,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":20044..20300
SpriteFrame_gready_14:
	db $05,$80
	dw $000B
	dw -13,8,-25,3
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_gready_14
	db $F7,$FA,$F7,$FA
	dw -9,-25,$0800 : db $FF
	dw -13,-9,$0802 : db $FF
	dw 7,-25,$0804 : db $00
	dw 3,-9,$0805 : db $00
	dw 3,-1,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":20357..20709

SpriteFrame_gready_15:
	db $05,$80
	dw $000B
	dw -13,8,-25,3
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_gready_15
	db $F7,$FA,$F7,$FA
	dw -9,-25,$0800 : db $FF
	dw -13,-9,$0802 : db $FF
	dw 7,-25,$0804 : db $00
	dw 3,-9,$0805 : db $00
	dw 3,-1,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":20766..21118
SpriteFrame_gdive_0:
	db $05,$80
	dw $000E
	dw -12,14,-25,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gdive_0
	db $F5,$F7,$F3,$F0
	dw -12,-25,$0800 : db $FF
	dw 4,-25,$0802 : db $FF
	dw -11,-9,$0804 : db $FF
	dw 5,-9,$0806 : db $00
	dw 5,-1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":21175..21623
SpriteFrame_gdive_1:
	db $08,$80
	dw $000E
	dw -12,11,-32,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gdive_1
	db $FD,$E8,$08,$EB
	dw -9,-13,$0800 : db $FF
	dw -12,-29,$0802 : db $FF
	dw 7,-13,$0804 : db $00
	dw 7,-5,$0805 : db $00
	dw 4,-29,$0814 : db $00
	dw 4,-21,$0815 : db $00
	dw -11,-37,$0806 : db $00
	dw -3,-37,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":21701..22149
SpriteFrame_gdive_2:
	db $06,$80
	dw $000C
	dw -7,18,-24,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gdive_2
	db $0D,$F7,$13,$EF
	dw 0,-24,$0800 : db $FF
	dw -7,-8,$0802 : db $FF
	dw 16,-24,$0804 : db $00
	dw 16,-16,$0805 : db $00
	dw 9,-8,$0814 : db $00
	dw 17,-8,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":22213..22597
SpriteFrame_gdive_3:
	db $04,$80
	dw $0010
	dw -5,28,-26,5
	dw $0100,$0100
	dw .tiles-SpriteFrame_gdive_3
	db $10,$EF,$19,$EF
	dw 3,-26,$0800 : db $FF
	dw 19,-26,$0802 : db $FF
	dw -5,-10,$0804 : db $FF
	dw 11,-10,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":22647..23159
SpriteFrame_gdive_4:
	db $05,$80
	dw $0011
	dw -4,31,-21,5
	dw $0120,$0100
	dw .tiles-SpriteFrame_gdive_4
	db $15,$04,$1A,$F5
	dw 0,-21,$0800 : db $FF
	dw 16,-21,$0802 : db $FF
	dw -4,-5,$0804 : db $FF
	dw 12,-5,$0806 : db $FF
	dw 28,-5,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":23216..23760
SpriteFrame_gdive_5:
	db $04,$80
	dw $000D
	dw 2,48,-11,8
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gdive_5
	db $22,$FD,$2B,$FE
	dw 33,-11,$0800 : db $FF
	dw 17,-9,$0802 : db $FF
	dw 1,-6,$0804 : db $FF
	dw 33,5,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":23810..24226
SpriteFrame_gdive_6:
	db $05,$80
	dw $0011
	dw -6,28,-22,7
	dw $0120,$0100
	dw .tiles-SpriteFrame_gdive_6
	db $0E,$04,$16,$F4
	dw -3,-22,$0800 : db $FF
	dw 13,-22,$0802 : db $FF
	dw -6,-6,$0804 : db $FF
	dw 10,-6,$0806 : db $FF
	dw 26,-6,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":24283..24827

SpriteFrame_gdive_7:
	db $04,$80
	dw $0010
	dw -8,33,-6,20
	dw $0100,$0100
	dw .tiles-SpriteFrame_gdive_7
	db $12,$0A,$1A,$0D
	dw 18,5,$0800 : db $FF
	dw 2,-6,$0802 : db $FF
	dw 2,10,$0804 : db $FF
	dw -14,-6,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":24877..25389
SpriteFrame_gdive_8:
	db $06,$80
	dw $000F
	dw -14,8,-5,35
	dw $0100,$00E0
	dw .tiles-SpriteFrame_gdive_8
	db $FE,$12,$09,$14
	dw -8,-5,$0800 : db $FF
	dw -14,11,$0802 : db $FF
	dw -11,27,$0804 : db $FF
	dw 2,11,$0806 : db $00
	dw 2,19,$0807 : db $00
	dw 5,27,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":25453..25933
SpriteFrame_gdive_9:
	db $05,$80
	dw $000E
	dw -16,10,-1,34
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gdive_9
	db $FF,$17,$07,$1B
	dw -16,19,$0800 : db $FF
	dw 0,19,$0802 : db $FF
	dw -8,3,$0804 : db $FF
	dw -8,-5,$0806 : db $00
	dw 0,-5,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":25990..26438
SpriteFrame_gdive_10:
	db $05,$80
	dw $0011
	dw -21,8,-22,13
	dw $0120,$0100
	dw .tiles-SpriteFrame_gdive_10
	db $F5,$04,$EC,$F5
	dw -20,-22,$0800 : db $FF
	dw -4,-22,$0802 : db $FF
	dw -21,-6,$0804 : db $FF
	dw -5,-6,$0806 : db $FF
	dw -13,10,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":26495..27039
SpriteFrame_gdive_11:
	db $07,$80
	dw $0010
	dw -34,6,-5,26
	dw $0100,$0100
	dw .tiles-SpriteFrame_gdive_11
	db $EE,$0C,$F6,$0C
	dw -17,-5,$0800 : db $FF
	dw -34,11,$0802 : db $FF
	dw -18,11,$0804 : db $FF
	dw -33,3,$0806 : db $00
	dw -25,3,$0807 : db $00
	dw -1,-5,$0816 : db $00
	dw -1,3,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":27110..27622
SpriteFrame_gdive_12:
	db $05,$80
	dw $0011
	dw -25,11,-23,6
	dw $0120,$0100
	dw .tiles-SpriteFrame_gdive_12
	db $F4,$FE,$EF,$F2
	dw -23,-23,$0800 : db $FF
	dw -7,-23,$0802 : db $FF
	dw -25,-7,$0804 : db $FF
	dw -9,-7,$0806 : db $FF
	dw 7,-7,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":27679..28223
SpriteFrame_gdive_13:
	db $04,$80
	dw $000D
	dw -44,3,-13,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gdive_13
	db $E3,$FC,$EC,$FB
	dw -44,-10,$0800 : db $FF
	dw -28,-10,$0802 : db $FF
	dw -12,-10,$0804 : db $FF
	dw -29,-18,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":28273..28689

SpriteFrame_gdive_14:
	db $05,$80
	dw $000E
	dw -20,8,-23,7
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gdive_14
	db $F9,$F7,$00,$F0
	dw -20,-23,$0800 : db $FF
	dw -4,-23,$0802 : db $FF
	dw -15,-7,$0804 : db $FF
	dw 1,-7,$0806 : db $00
	dw 1,1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":28746..29194
SpriteFrame_gdive_15:
	db $05,$80
	dw $0011
	dw -31,6,-25,5
	dw $0120,$0100
	dw .tiles-SpriteFrame_gdive_15
	db $F2,$EF,$FA,$EA
	dw -31,-25,$0800 : db $FF
	dw -15,-25,$0802 : db $FF
	dw -23,-9,$0804 : db $FF
	dw -7,-9,$0806 : db $FF
	dw 1,-17,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":29251..29795
SpriteFrame_gpoke_0:
	db $04,$80
	dw $000A
	dw -12,10,-23,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gpoke_0
	db $FE,$F7,$00,$F5
	dw -12,-14,$0800 : db $FF
	dw -6,-30,$0802 : db $FF
	dw 4,-14,$0804 : db $00
	dw 4,-6,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":29845..30165
SpriteFrame_gpoke_1:
	db $02,$80
	dw $0008
	dw -11,7,-22,2
	dw $0080,$0080
	dw .tiles-SpriteFrame_gpoke_1
	db $FF,$F5,$01,$F4
	dw -11,-22,$0800 : db $FF
	dw -8,-6,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":30201..30457
SpriteFrame_gpoke_2:
	db $04,$80
	dw $000A
	dw -8,15,-24,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gpoke_2
	db $0D,$FB,$0F,$F9
	dw -8,-24,$0800 : db $FF
	dw -8,-8,$0802 : db $FF
	dw 8,-16,$0804 : db $00
	dw 8,-8,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":30507..30827
SpriteFrame_gpoke_3:
	db $05,$80
	dw $000E
	dw -7,22,-24,1
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gpoke_3
	db $14,$FA,$16,$F8
	dw -7,-24,$0800 : db $FF
	dw 9,-24,$0802 : db $FF
	dw -6,-8,$0804 : db $FF
	dw 10,-8,$0806 : db $00
	dw 18,-8,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":30884..31332
SpriteFrame_gpoke_4:
	db $03,$80
	dw $000C
	dw -4,26,-24,2
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gpoke_4
	db $18,$00,$1A,$FE
	dw -2,-24,$0800 : db $FF
	dw -4,-8,$0802 : db $FF
	dw 12,-8,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":31375..31759
SpriteFrame_gpoke_5:
	db $05,$80
	dw $000E
	dw -5,39,-23,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gpoke_5
	db $23,$02,$26,$00
	dw -5,-13,$0800 : db $FF
	dw 11,-13,$0802 : db $FF
	dw -5,-29,$0804 : db $FF
	dw 27,-5,$0806 : db $00
	dw 35,-5,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":31816..32264
SpriteFrame_gpoke_6:
	db $04,$80
	dw $000A
	dw -9,15,-22,6
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gpoke_6
	db $0B,$06,$0D,$04
	dw -7,-22,$0800 : db $FF
	dw -9,-6,$0802 : db $FF
	dw 7,2,$0804 : db $00
	dw 15,2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8A.bin":32314..32634
