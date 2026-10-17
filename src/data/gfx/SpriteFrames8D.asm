; More frames of SpriteFrames. A frame is the piece count, flags (bit 7: 16x16 tiles), tile
; count, the box of its pixels (left, right, top, bottom; nothing reads it), the two transfer
; sizes, the tile offset, the hot spot x / y (signed bytes, GetHot), the stick point x / y
; (GetFrameHot), the pieces, then the tiles. Frame labels are SpriteFrame_<group>_<n>.

SpriteFrame_boardfront_0:
	db $07,$80
	dw $0010
	dw -6,22,-30,5
	dw $0100,$0100
	dw .tiles-SpriteFrame_boardfront_0
	db $16,$03,$00,$00
	dw -6,-30,$0800 : db $FF
	dw 10,-30,$0802 : db $FF
	dw -6,-14,$0804 : db $FF
	dw 10,-14,$0806 : db $00
	dw -6,2,$0807 : db $00
	dw 2,2,$0816 : db $00
	dw 10,2,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":71..583
SpriteFrame_boardfront_1:
	db $04,$80
	dw $000D
	dw -9,26,-20,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_boardfront_1
	db $17,$04,$00,$00
	dw -7,-10,$0800 : db $FF
	dw 9,-10,$0802 : db $FF
	dw -9,-26,$0804 : db $FF
	dw 25,-2,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":633..1049
SpriteFrame_boardfront_2:
	db $06,$80
	dw $000C
	dw -10,36,-12,9
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_boardfront_2
	db $21,$06,$00,$00
	dw -10,-6,$0800 : db $FF
	dw 6,-6,$0802 : db $FF
	dw 22,2,$0804 : db $00
	dw 30,2,$0805 : db $00
	dw -7,-14,$0814 : db $00
	dw 1,-14,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":1113..1497
SpriteFrame_boardfront_3:
	db $06,$80
	dw $000C
	dw -11,37,-5,12
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_boardfront_3
	db $20,$0B,$00,$00
	dw -11,-3,$0800 : db $FF
	dw 5,-3,$0802 : db $FF
	dw 21,5,$0804 : db $00
	dw 29,5,$0805 : db $00
	dw 37,5,$0814 : db $00
	dw 1,-11,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":1561..1945
SpriteFrame_boardfront_4:
	db $04,$80
	dw $000D
	dw -8,26,-30,2
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_boardfront_4
	db $1B,$01,$00,$00
	dw -1,-30,$0800 : db $FF
	dw 15,-30,$0802 : db $FF
	dw -8,-14,$0804 : db $FF
	dw 0,2,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":1995..2411
SpriteFrame_boardfront_5:
	db $05,$80
	dw $000E
	dw -10,24,-24,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardfront_5
	db $16,$01,$00,$00
	dw 0,-24,$0800 : db $FF
	dw 16,-24,$0802 : db $FF
	dw -10,-8,$0804 : db $FF
	dw 6,-8,$0806 : db $00
	dw 6,0,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":2468..2916
SpriteFrame_boardfront_6:
	db $07,$80
	dw $000D
	dw -15,26,-22,8
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_boardfront_6
	db $18,$06,$00,$02
	dw -15,-6,$0800 : db $FF
	dw 1,-6,$0802 : db $FF
	dw 6,-14,$0804 : db $00
	dw 22,-22,$0805 : db $00
	dw 22,-14,$0814 : db $00
	dw 17,-6,$0815 : db $00
	dw 17,2,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":2987..3403
SpriteFrame_boardfront_7:
	db $04,$80
	dw $000D
	dw -15,38,-1,14
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_boardfront_7
	db $28,$0A,$FF,$02
	dw -15,-1,$0800 : db $FF
	dw 1,-1,$0802 : db $FF
	dw 17,-1,$0804 : db $FF
	dw 33,7,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":3453..3869
SpriteFrame_boardfront_8:
	db $06,$80
	dw $000F
	dw -9,21,-30,5
	dw $0100,$00E0
	dw .tiles-SpriteFrame_boardfront_8
	db $14,$04,$00,$00
	dw -9,-30,$0800 : db $FF
	dw -9,-14,$0802 : db $FF
	dw 7,-28,$0804 : db $FF
	dw -9,2,$0806 : db $00
	dw -1,2,$0807 : db $00
	dw 7,1,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":3933..4413

SpriteFrame_boardfront_9:
	db $04,$80
	dw $0010
	dw -15,13,-23,4
	dw $0100,$0100
	dw .tiles-SpriteFrame_boardfront_9
	db $0D,$03,$00,$00
	dw -14,-23,$0800 : db $FF
	dw 2,-23,$0802 : db $FF
	dw -15,-7,$0804 : db $FF
	dw 1,-7,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":4463..4975
SpriteFrame_boardfront_10:
	db $04,$80
	dw $000A
	dw -11,16,-9,11
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardfront_10
	db $0D,$0B,$00,$00
	dw -11,-4,$0800 : db $FF
	dw 5,-4,$0802 : db $FF
	dw -5,-12,$0804 : db $00
	dw 3,-12,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":5025..5345
SpriteFrame_boardfront_11:
	db $04,$80
	dw $000A
	dw -10,18,0,18
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardfront_11
	db $0E,$10,$00,$00
	dw -10,3,$0800 : db $FF
	dw 6,3,$0802 : db $FF
	dw -5,-5,$0804 : db $00
	dw 3,-5,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":5395..5715
SpriteFrame_boardfront_12:
	db $06,$80
	dw $000C
	dw -15,11,-38,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_boardfront_12
	db $F3,$01,$00,$00
	dw -5,-12,$0800 : db $FF
	dw -10,-28,$0802 : db $FF
	dw 11,-12,$0804 : db $00
	dw -15,-44,$0805 : db $00
	dw -15,-36,$0814 : db $00
	dw 1,-36,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":5779..6163
SpriteFrame_boardfront_13:
	db $05,$80
	dw $000E
	dw -18,12,-28,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardfront_13
	db $EC,$03,$00,$00
	dw -18,-28,$0800 : db $FF
	dw -13,-12,$0802 : db $FF
	dw 3,-12,$0804 : db $FF
	dw -2,-20,$0806 : db $00
	dw -8,4,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":6220..6668
SpriteFrame_boardfront_14:
	db $07,$80
	dw $0010
	dw -36,16,-23,8
	dw $0100,$0100
	dw .tiles-SpriteFrame_boardfront_14
	db $DB,$01,$00,$00
	dw -20,-23,$0800 : db $FF
	dw -19,-7,$0802 : db $FF
	dw -3,-7,$0804 : db $FF
	dw -36,-23,$0806 : db $00
	dw -28,-23,$0807 : db $00
	dw 13,-7,$0816 : db $00
	dw 13,1,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":6739..7251
SpriteFrame_boardfront_15:
	db $05,$80
	dw $000E
	dw -46,12,-1,16
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardfront_15
	db $D2,$04,$00,$00
	dw -30,2,$0800 : db $FF
	dw -14,2,$0802 : db $FF
	dw 2,1,$0804 : db $FF
	dw -46,-1,$0806 : db $00
	dw -38,-1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":7308..7756
SpriteFrame_boardright_0:
	db $04,$80
	dw $000A
	dw -1,19,-37,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardright_0
	db $00,$00,$02,$00
	dw 5,-37,$0800 : db $FF
	dw 1,-21,$0802 : db $FF
	dw -1,-5,$0804 : db $00
	dw 7,-5,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":7806..8126
SpriteFrame_boardright_1:
	db $03,$80
	dw $0009
	dw -14,3,-28,-2
	dw $00A0,$0080
	dw .tiles-SpriteFrame_boardright_1
	db $00,$00,$00,$00
	dw -14,-28,$0800 : db $FF
	dw -10,-12,$0802 : db $FF
	dw 2,-20,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":8169..8457

SpriteFrame_boardright_2:
	db $04,$80
	dw $000A
	dw -36,-3,-10,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardright_2
	db $00,$00,$00,$07
	dw -36,-10,$0800 : db $FF
	dw -20,-10,$0802 : db $FF
	dw -4,-10,$0804 : db $00
	dw -4,-2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":8507..8827
SpriteFrame_boardright_3:
	db $06,$80
	dw $000F
	dw -40,-3,-18,12
	dw $0100,$00E0
	dw .tiles-SpriteFrame_boardright_3
	db $00,$00,$00,$06
	dw -21,-18,$0800 : db $FF
	dw -40,-2,$0802 : db $FF
	dw -24,-2,$0804 : db $FF
	dw -5,-10,$0806 : db $00
	dw -8,-2,$0807 : db $00
	dw -8,6,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":8891..9371
SpriteFrame_boardright_4:
	db $05,$80
	dw $000B
	dw 0,19,-27,7
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_boardright_4
	db $FE,$05,$09,$05
	dw 3,-27,$0800 : db $FF
	dw 0,-11,$0802 : db $FF
	dw 16,-11,$0804 : db $00
	dw 16,-3,$0805 : db $00
	dw 2,5,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":9428..9780
SpriteFrame_boardright_5:
	db $07,$80
	dw $0013
	dw -36,9,-36,6
	dw $0140,$0120
	dw .tiles-SpriteFrame_boardright_5
	db $FF,$00,$05,$00
	dw -19,-9,$0800 : db $FF
	dw -3,-9,$0802 : db $FF
	dw -31,-25,$0804 : db $FF
	dw -15,-25,$0806 : db $FF
	dw 1,-17,$0808 : db $00
	dw -36,-41,$0809 : db $00
	dw -36,-33,$0818 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":9851..10459
SpriteFrame_boardright_6:
	db $05,$80
	dw $000E
	dw -36,2,-9,16
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardright_6
	db $00,$00,$00,$00
	dw -36,-9,$0800 : db $FF
	dw -36,7,$0802 : db $FF
	dw -20,-6,$0804 : db $FF
	dw -4,-5,$0806 : db $00
	dw -4,3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":10516..10964
SpriteFrame_boardright_7:
	db $05,$80
	dw $000E
	dw -40,-1,-6,20
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardright_7
	db $00,$FF,$FD,$00
	dw -34,-6,$0800 : db $FF
	dw -18,-6,$0802 : db $FF
	dw -40,10,$0804 : db $FF
	dw -2,-6,$0806 : db $00
	dw -2,2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":11021..11469
SpriteFrame_boardright_8:
	db $05,$80
	dw $000E
	dw -15,9,-27,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardright_8
	db $FD,$03,$03,$03
	dw -15,-27,$0800 : db $FF
	dw 1,-27,$0802 : db $FF
	dw -10,-11,$0804 : db $FF
	dw 6,-11,$0806 : db $00
	dw 6,-3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":11526..11974
SpriteFrame_boardright_9:
	db $04,$80
	dw $000A
	dw -9,6,-38,0
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardright_9
	db $00,$00,$00,$00
	dw -6,-38,$0800 : db $FF
	dw -5,-22,$0802 : db $FF
	dw -9,-6,$0804 : db $00
	dw -1,-6,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":12024..12344

SpriteFrame_boardright_10:
	db $04,$80
	dw $0010
	dw -25,5,-21,9
	dw $0100,$0100
	dw .tiles-SpriteFrame_boardright_10
	db $FF,$00,$00,$00
	dw -19,-21,$0800 : db $FF
	dw -3,-21,$0802 : db $FF
	dw -25,-5,$0804 : db $FF
	dw -9,-5,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":12394..12906
SpriteFrame_boardright_11:
	db $05,$80
	dw $000B
	dw -28,1,-9,14
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_boardright_11
	db $00,$01,$00,$00
	dw -28,-9,$0800 : db $FF
	dw -12,-9,$0802 : db $FF
	dw -22,7,$0804 : db $00
	dw -14,7,$0805 : db $00
	dw -6,7,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":12963..13315
SpriteFrame_boardright_12:
	db $05,$80
	dw $000B
	dw 1,18,-35,8
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_boardright_12
	db $FA,$02,$FA,$05
	dw 1,-19,$0800 : db $FF
	dw 1,-3,$0802 : db $FF
	dw 12,-35,$0804 : db $00
	dw 12,-27,$0805 : db $00
	dw 17,-19,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":13372..13724
SpriteFrame_boardright_13:
	db $06,$80
	dw $000C
	dw -14,5,-31,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_boardright_13
	db $FD,$00,$FB,$01
	dw -10,-11,$0800 : db $FF
	dw -14,-27,$0802 : db $FF
	dw 2,-27,$0804 : db $00
	dw 2,-19,$0805 : db $00
	dw -13,-35,$0814 : db $00
	dw -5,-35,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":13788..14172
SpriteFrame_boardright_14:
	db $04,$80
	dw $000A
	dw -23,2,-14,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardright_14
	db $00,$00,$FC,$01
	dw -23,-14,$0800 : db $FF
	dw -7,-14,$0802 : db $FF
	dw -15,2,$0804 : db $00
	dw -7,2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":14222..14542
SpriteFrame_boardright_15:
	db $06,$80
	dw $0012
	dw -32,3,-16,20
	dw $0140,$0100
	dw .tiles-SpriteFrame_boardright_15
	db $00,$00,$F2,$FF
	dw -30,5,$0800 : db $FF
	dw -14,5,$0802 : db $FF
	dw -32,-11,$0804 : db $FF
	dw -16,-11,$0806 : db $FF
	dw 2,5,$0808 : db $00
	dw -6,-19,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":14606..15182
SpriteFrame_boardback_0:
	db $06,$80
	dw $000F
	dw -8,21,-32,1
	dw $0100,$00E0
	dw .tiles-SpriteFrame_boardback_0
	db $17,$01,$00,$00
	dw -8,-32,$0800 : db $FF
	dw 8,-32,$0802 : db $FF
	dw -6,-16,$0804 : db $FF
	dw 10,-16,$0806 : db $00
	dw -6,0,$0807 : db $00
	dw 2,0,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":15246..15726
SpriteFrame_boardback_1:
	db $05,$80
	dw $000B
	dw -11,21,-24,-1
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_boardback_1
	db $14,$F8,$00,$00
	dw -11,-16,$0800 : db $FF
	dw 5,-16,$0802 : db $FF
	dw 21,-16,$0804 : db $00
	dw -11,-24,$0805 : db $00
	dw -3,-24,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":15783..16135
SpriteFrame_boardback_2:
	db $03,$80
	dw $0006
	dw -8,19,-16,-1
	dw $0080,$0040
	dw .tiles-SpriteFrame_boardback_2
	db $17,$FD,$00,$00
	dw -8,-16,$0800 : db $FF
	dw 8,-8,$0802 : db $00
	dw 16,-8,$0803 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":16178..16370
SpriteFrame_boardback_3:
	db $06,$80
	dw $000C
	dw -16,25,-17,0
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_boardback_3
	db $1A,$FB,$00,$00
	dw -16,-17,$0800 : db $FF
	dw 0,-17,$0802 : db $FF
	dw 16,-9,$0804 : db $00
	dw 24,-9,$0805 : db $00
	dw 4,-1,$0814 : db $00
	dw 12,-1,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":16434..16818

SpriteFrame_boardback_4:
	db $05,$80
	dw $0014
	dw -18,28,-29,0
	dw $0140,$0140
	dw .tiles-SpriteFrame_boardback_4
	db $1C,$FE,$00,$00
	dw -18,-29,$0800 : db $FF
	dw -2,-29,$0802 : db $FF
	dw -18,-13,$0804 : db $FF
	dw -2,-13,$0806 : db $FF
	dw 14,-13,$0808 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":16875..17515
SpriteFrame_boardback_5:
	db $07,$80
	dw $0013
	dw -19,23,-25,-1
	dw $0140,$0120
	dw .tiles-SpriteFrame_boardback_5
	db $15,$FD,$00,$00
	dw -19,-25,$0800 : db $FF
	dw -3,-25,$0802 : db $FF
	dw -19,-9,$0804 : db $FF
	dw -3,-9,$0806 : db $FF
	dw 17,-25,$0808 : db $00
	dw 17,-17,$0809 : db $00
	dw 13,-9,$0818 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":17586..18194
SpriteFrame_boardback_6:
	db $05,$80
	dw $000E
	dw -14,10,-32,0
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardback_6
	db $FA,$FE,$00,$00
	dw -12,-32,$0800 : db $FF
	dw -14,-16,$0802 : db $FF
	dw 2,-16,$0804 : db $FF
	dw 4,-24,$0806 : db $00
	dw -9,0,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":18251..18699
SpriteFrame_boardback_7:
	db $04,$80
	dw $000A
	dw -15,13,-23,0
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardback_7
	db $F8,$ED,$00,$FD
	dw -15,-15,$0800 : db $FF
	dw 1,-15,$0802 : db $FF
	dw -14,-23,$0804 : db $00
	dw -6,-23,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":18749..19069
SpriteFrame_boardback_8:
	db $05,$80
	dw $0011
	dw -23,12,-39,0
	dw $0120,$0100
	dw .tiles-SpriteFrame_boardback_8
	db $EA,$FF,$00,$00
	dw -17,-15,$0800 : db $FF
	dw -1,-15,$0802 : db $FF
	dw -19,-31,$0804 : db $FF
	dw -3,-31,$0806 : db $FF
	dw -23,-39,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":19126..19670
SpriteFrame_boardback_9:
	db $05,$80
	dw $0011
	dw -13,14,-40,0
	dw $0120,$0100
	dw .tiles-SpriteFrame_boardback_9
	db $F5,$FF,$00,$00
	dw -11,-40,$0800 : db $FF
	dw -12,-24,$0802 : db $FF
	dw 4,-24,$0804 : db $FF
	dw -13,-8,$0806 : db $FF
	dw 3,-8,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":19727..20271
SpriteFrame_boardback_10:
	db $04,$80
	dw $0010
	dw -15,12,-28,0
	dw $0100,$0100
	dw .tiles-SpriteFrame_boardback_10
	db $0C,$00,$00,$00
	dw -14,-28,$0800 : db $FF
	dw 2,-28,$0802 : db $FF
	dw -15,-12,$0804 : db $FF
	dw 1,-12,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":20321..20833

SpriteFrame_boardback_11:
	db $07,$80
	dw $000D
	dw -19,20,-26,-3
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_boardback_11
	db $11,$FA,$00,$00
	dw -19,-26,$0800 : db $FF
	dw -3,-26,$0802 : db $FF
	dw -14,-10,$0804 : db $00
	dw -6,-10,$0805 : db $00
	dw 2,-10,$0814 : db $00
	dw 10,-10,$0815 : db $00
	dw 18,-10,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":20904..21320
SpriteFrame_boardback_12:
	db $06,$80
	dw $0015
	dw -16,16,-43,0
	dw $0160,$0140
	dw .tiles-SpriteFrame_boardback_12
	db $F5,$FF,$00,$00
	dw -16,-43,$0800 : db $FF
	dw -12,-27,$0802 : db $FF
	dw 4,-27,$0804 : db $FF
	dw -14,-11,$0806 : db $FF
	dw 2,-11,$0808 : db $FF
	dw 0,-35,$080A : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":21384..22056
SpriteFrame_boardback_13:
	db $09,$80
	dw $0012
	dw -18,18,-45,0
	dw $0140,$0100
	dw .tiles-SpriteFrame_boardback_13
	db $07,$FF,$00,$00
	dw -11,-29,$0800 : db $FF
	dw -18,-13,$0802 : db $FF
	dw -2,-13,$0804 : db $FF
	dw 0,-45,$0806 : db $00
	dw 0,-37,$0807 : db $00
	dw 5,-29,$0816 : db $00
	dw 5,-21,$0817 : db $00
	dw 14,-13,$0808 : db $00
	dw 14,-5,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":22141..22717
SpriteFrame_boardback_14:
	db $05,$80
	dw $0011
	dw -12,29,-25,-1
	dw $0120,$0100
	dw .tiles-SpriteFrame_boardback_14
	db $1E,$FE,$00,$00
	dw -9,-25,$0800 : db $FF
	dw 7,-25,$0802 : db $FF
	dw -12,-9,$0804 : db $FF
	dw 4,-9,$0806 : db $FF
	dw 23,-25,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":22774..23318
SpriteFrame_boardback_15:
	db $06,$80
	dw $000C
	dw -12,24,-23,-1
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_boardback_15
	db $1A,$F8,$00,$00
	dw -12,-20,$0800 : db $FF
	dw 4,-23,$0802 : db $FF
	dw 4,-7,$0804 : db $00
	dw 12,-7,$0805 : db $00
	dw 20,-14,$0814 : db $00
	dw 20,-6,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":23382..23766
SpriteFrame_boardleft_0:
	db $04,$80
	dw $000A
	dw -14,2,-43,2
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardleft_0
	db $03,$00,$01,$05
	dw -14,-27,$0800 : db $FF
	dw -11,-11,$0802 : db $FF
	dw -8,-43,$0804 : db $00
	dw -8,-35,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":23816..24136
SpriteFrame_boardleft_1:
	db $04,$80
	dw $000D
	dw -3,27,-32,-2
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_boardleft_1
	db $00,$00,$00,$00
	dw -3,-32,$0800 : db $FF
	dw 13,-32,$0802 : db $FF
	dw -3,-16,$0804 : db $FF
	dw 13,-16,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":24186..24602

SpriteFrame_boardleft_2:
	db $05,$80
	dw $000E
	dw -2,32,-28,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardleft_2
	db $00,$00,$00,$00
	dw 19,-28,$0800 : db $FF
	dw -2,-12,$0802 : db $FF
	dw 14,-12,$0804 : db $FF
	dw 3,-20,$0806 : db $00
	dw 11,-20,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":24659..25107
SpriteFrame_boardleft_3:
	db $04,$80
	dw $000D
	dw -4,37,-14,3
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_boardleft_3
	db $00,$00,$00,$00
	dw -4,-14,$0800 : db $FF
	dw 12,-14,$0802 : db $FF
	dw 28,-14,$0804 : db $FF
	dw 11,2,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":25157..25573
SpriteFrame_boardleft_4:
	db $04,$80
	dw $000A
	dw -18,-1,-21,16
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardleft_4
	db $FB,$04,$00,$06
	dw -18,-21,$0800 : db $FF
	dw -16,-5,$0802 : db $FF
	dw -2,-13,$0804 : db $00
	dw -10,11,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":25623..25943
SpriteFrame_boardleft_5:
	db $04,$80
	dw $000A
	dw -4,15,-33,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardleft_5
	db $00,$00,$FD,$00
	dw -3,-14,$0800 : db $FF
	dw -4,-30,$0802 : db $FF
	dw 12,-22,$0804 : db $00
	dw 4,-38,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":25993..26313
SpriteFrame_boardleft_6:
	db $05,$80
	dw $0008
	dw 1,21,-18,4
	dw $0080,$0080
	dw .tiles-SpriteFrame_boardleft_6
	db $00,$FF,$FC,$01
	dw 1,-18,$0800 : db $FF
	dw 17,-18,$0802 : db $00
	dw 17,-10,$0803 : db $00
	dw 3,-2,$0812 : db $00
	dw 11,-2,$0813 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":26370..26626
SpriteFrame_boardleft_7:
	db $05,$80
	dw $000E
	dw -3,28,-17,20
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardleft_7
	db $00,$00,$FA,$FF
	dw -3,5,$0800 : db $FF
	dw 13,5,$0802 : db $FF
	dw 6,-11,$0804 : db $FF
	dw 22,-11,$0806 : db $00
	dw 2,-19,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":26683..27131
SpriteFrame_boardleft_8:
	db $06,$80
	dw $000C
	dw -9,10,-35,2
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_boardleft_8
	db $02,$00,$01,$01
	dw -8,-35,$0800 : db $FF
	dw -9,-19,$0802 : db $FF
	dw 7,-19,$0804 : db $00
	dw 7,-11,$0805 : db $00
	dw -7,-3,$0814 : db $00
	dw 1,-3,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":27195..27579
SpriteFrame_boardleft_9:
	db $04,$80
	dw $000A
	dw -5,17,-24,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_boardleft_9
	db $0D,$00,$04,$FF
	dw -5,-14,$0800 : db $FF
	dw -5,-30,$0802 : db $FF
	dw 11,-14,$0804 : db $00
	dw 11,-6,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":27629..27949
SpriteFrame_boardleft_10:
	db $04,$80
	dw $0007
	dw 0,28,-13,6
	dw $0080,$0060
	dw .tiles-SpriteFrame_boardleft_10
	db $18,$06,$08,$FE
	dw 0,-13,$0800 : db $FF
	dw 6,3,$0802 : db $00
	dw 14,3,$0803 : db $00
	dw 22,3,$0812 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":27999..28223
SpriteFrame_boardleft_11:
	db $04,$80
	dw $0010
	dw 0,30,-14,16
	dw $0100,$0100
	dw .tiles-SpriteFrame_boardleft_11
	db $1A,$10,$05,$00
	dw 1,-14,$0800 : db $FF
	dw 17,-14,$0802 : db $FF
	dw 0,2,$0804 : db $FF
	dw 16,2,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":28273..28785

SpriteFrame_boardleft_12:
	db $03,$80
	dw $000C
	dw -15,0,-35,7
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_boardleft_12
	db $02,$04,$FB,$05
	dw -15,-35,$0800 : db $FF
	dw -14,-19,$0802 : db $FF
	dw -11,-3,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":28828..29212
SpriteFrame_boardleft_13:
	db $06,$80
	dw $0015
	dw -8,30,-37,8
	dw $0160,$0140
	dw .tiles-SpriteFrame_boardleft_13
	db $00,$00,$FA,$02
	dw 4,-37,$0800 : db $FF
	dw -8,-21,$0802 : db $FF
	dw 8,-21,$0804 : db $FF
	dw -6,-5,$0806 : db $FF
	dw 10,-5,$0808 : db $FF
	dw 24,-21,$080A : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":29276..29948
SpriteFrame_boardleft_14:
	db $05,$80
	dw $000E
	dw -1,29,-30,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardleft_14
	db $00,$00,$F8,$FF
	dw 15,-30,$0800 : db $FF
	dw -1,-14,$0802 : db $FF
	dw 15,-14,$0804 : db $FF
	dw 18,2,$0806 : db $00
	dw 26,2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":30005..30453
SpriteFrame_boardleft_15:
	db $05,$80
	dw $000E
	dw 4,44,-9,11
	dw $0100,$00C0
	dw .tiles-SpriteFrame_boardleft_15
	db $00,$00,$FB,$FF
	dw 4,-9,$0800 : db $FF
	dw 20,-9,$0802 : db $FF
	dw 36,-9,$0804 : db $FF
	dw 34,7,$0806 : db $00
	dw 42,7,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":30510..30958
SpriteFrame_benchcheck_0:
	db $06,$80
	dw $000C
	dw -11,9,-36,1
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_benchcheck_0
	db $00,$00,$03,$E4
	dw -11,-36,$0800 : db $FF
	dw -11,-20,$0802 : db $FF
	dw 5,-20,$0804 : db $00
	dw 5,-12,$0805 : db $00
	dw -10,-4,$0814 : db $00
	dw -2,-4,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":31022..31406
SpriteFrame_benchcheck_1:
	db $04,$80
	dw $000A
	dw -35,-3,-32,-10
	dw $00C0,$0080
	dw .tiles-SpriteFrame_benchcheck_1
	db $00,$00,$F6,$DF
	dw -35,-25,$0800 : db $FF
	dw -19,-25,$0802 : db $FF
	dw -3,-17,$0804 : db $00
	dw -25,-33,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":31456..31776
SpriteFrame_benchcheck_2:
	db $04,$80
	dw $000D
	dw -11,5,-39,1
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_benchcheck_2
	db $00,$00,$EB,$EA
	dw -11,-39,$0800 : db $FF
	dw -11,-23,$0802 : db $FF
	dw -10,-7,$0804 : db $FF
	dw 5,-15,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":31826..32242
SpriteFrame_benchcheck_3:
	db $03,$80
	dw $0009
	dw -35,-5,-33,-10
	dw $00A0,$0080
	dw .tiles-SpriteFrame_benchcheck_3
	db $00,$00,$DC,$E5
	dw -35,-25,$0800 : db $FF
	dw -19,-25,$0802 : db $FF
	dw -34,-33,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8D.bin":32285..32573
