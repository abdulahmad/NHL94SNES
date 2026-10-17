; More frames of SpriteFrames. A frame is the piece count, flags (bit 7: 16x16 tiles), tile
; count, the box of its pixels (left, right, top, bottom; nothing reads it), the two transfer
; sizes, the tile offset, the hot spot x / y (signed bytes, GetHot), the stick point x / y
; (GetFrameHot), the pieces, then the tiles. Frame labels are SpriteFrame_<group>_<n>.

SpriteFrame_stop_15:
	db $03,$80
	dw $000C
	dw -14,11,-23,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_stop_15
	db $F7,$F6,$03,$04
	dw -4,-23,$0800 : db $FF
	dw -4,-7,$0802 : db $FF
	dw -20,-11,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":43..427
SpriteFrame_skateb_0:
	db $02,$80
	dw $0008
	dw -7,8,-26,4
	dw $0080,$0080
	dw .tiles-SpriteFrame_skateb_0
	db $01,$F4,$03,$05
	dw -7,-26,$0800 : db $FF
	dw -7,-10,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":463..719
SpriteFrame_skateb_1:
	db $04,$80
	dw $000A
	dw -11,9,-25,6
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skateb_1
	db $F8,$F3,$03,$05
	dw -6,-25,$0800 : db $FF
	dw -6,-9,$0802 : db $FF
	dw -14,-15,$0804 : db $00
	dw -14,-7,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":769..1089
SpriteFrame_skateb_2:
	db $03,$80
	dw $0009
	dw -9,10,-24,7
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skateb_2
	db $01,$F5,$04,$04
	dw -8,-24,$0800 : db $FF
	dw -9,-8,$0802 : db $FF
	dw 7,-8,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":1132..1420
SpriteFrame_skateb_3:
	db $03,$80
	dw $000C
	dw -8,17,-26,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_3
	db $10,$F2,$02,$06
	dw -8,-26,$0800 : db $FF
	dw -8,-10,$0802 : db $FF
	dw 8,-17,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":1463..1847
SpriteFrame_skateb_4:
	db $03,$80
	dw $0009
	dw -7,14,-24,7
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skateb_4
	db $0D,$F8,$03,$04
	dw -7,-24,$0800 : db $FF
	dw -7,-8,$0802 : db $FF
	dw 9,-12,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":1890..2178
SpriteFrame_skateb_5:
	db $04,$80
	dw $000A
	dw -9,11,-26,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skateb_5
	db $08,$F5,$07,$04
	dw -9,-26,$0800 : db $FF
	dw -9,-10,$0802 : db $FF
	dw 7,-12,$0804 : db $00
	dw 7,-4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":2228..2548
SpriteFrame_skateb_6:
	db $03,$80
	dw $000C
	dw -6,25,-29,2
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_6
	db $15,$02,$03,$04
	dw -6,-29,$0800 : db $FF
	dw -6,-13,$0802 : db $FF
	dw 10,-13,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":2591..2975
SpriteFrame_skateb_7:
	db $05,$80
	dw $000E
	dw -10,26,-27,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_skateb_7
	db $16,$FD,$03,$04
	dw -10,-27,$0800 : db $FF
	dw -9,-11,$0802 : db $FF
	dw 7,-11,$0804 : db $FF
	dw 23,-11,$0806 : db $00
	dw 23,-3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":3032..3480
SpriteFrame_skateb_8:
	db $04,$80
	dw $000D
	dw -7,23,-27,6
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_skateb_8
	db $12,$FE,$05,$07
	dw -7,-27,$0800 : db $FF
	dw -7,-11,$0802 : db $FF
	dw 9,-11,$0804 : db $FF
	dw 2,5,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":3530..3946
SpriteFrame_skateb_9:
	db $04,$80
	dw $000A
	dw -8,12,-27,9
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skateb_9
	db $09,$08,$03,$04
	dw -8,-27,$0800 : db $FF
	dw -7,-11,$0802 : db $FF
	dw 4,5,$0804 : db $00
	dw 12,5,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":3996..4316

SpriteFrame_skateb_10:
	db $04,$80
	dw $000A
	dw -10,17,-26,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skateb_10
	db $0D,$04,$04,$03
	dw -10,-26,$0800 : db $FF
	dw -9,-10,$0802 : db $FF
	dw 7,-2,$0804 : db $00
	dw 15,-2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":4366..4686
SpriteFrame_skateb_11:
	db $06,$80
	dw $000C
	dw -9,13,-28,8
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_11
	db $0A,$03,$00,$06
	dw -9,-28,$0800 : db $FF
	dw -8,-12,$0802 : db $FF
	dw 7,-20,$0804 : db $00
	dw -9,4,$0805 : db $00
	dw -1,4,$0814 : db $00
	dw 7,4,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":4750..5134
SpriteFrame_skateb_12:
	db $03,$80
	dw $000C
	dw -7,8,-29,12
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_12
	db $FF,$07,$03,$04
	dw -7,-29,$0800 : db $FF
	dw -7,-13,$0802 : db $FF
	dw -4,3,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":5177..5561
SpriteFrame_skateb_13:
	db $03,$80
	dw $000C
	dw -10,7,-30,12
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_13
	db $01,$08,$03,$04
	dw -10,-30,$0800 : db $FF
	dw -8,-14,$0802 : db $FF
	dw -3,2,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":5604..5988
SpriteFrame_skateb_14:
	db $06,$80
	dw $000C
	dw -10,7,-29,10
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_14
	db $02,$08,$FF,$05
	dw -7,-29,$0800 : db $FF
	dw -10,-13,$0802 : db $FF
	dw 6,-13,$0804 : db $00
	dw 6,-5,$0805 : db $00
	dw -7,3,$0814 : db $00
	dw 1,3,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":6052..6436
SpriteFrame_skateb_15:
	db $04,$80
	dw $000D
	dw -20,7,-29,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_skateb_15
	db $F1,$05,$03,$04
	dw -20,-10,$0800 : db $FF
	dw -4,-10,$0802 : db $FF
	dw -8,-26,$0804 : db $FF
	dw 0,-34,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":6486..6902
SpriteFrame_skateb_16:
	db $05,$80
	dw $000B
	dw -13,7,-29,9
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_skateb_16
	db $F3,$06,$06,$06
	dw -13,-6,$0800 : db $FF
	dw -8,-22,$0802 : db $FF
	dw 3,-6,$0804 : db $00
	dw 3,2,$0805 : db $00
	dw -3,-30,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":6959..7311
SpriteFrame_skateb_17:
	db $03,$80
	dw $0009
	dw -10,8,-26,7
	dw $00A0,$0080
	dw .tiles-SpriteFrame_skateb_17
	db $FA,$06,$02,$04
	dw -7,-26,$0800 : db $FF
	dw -7,-10,$0802 : db $FF
	dw -15,3,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":7354..7642
SpriteFrame_skateb_18:
	db $03,$80
	dw $000C
	dw -24,6,-28,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_18
	db $EB,$FF,$05,$04
	dw -7,-28,$0800 : db $FF
	dw -24,-12,$0802 : db $FF
	dw -8,-12,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":7685..8069
SpriteFrame_skateb_19:
	db $04,$80
	dw $000D
	dw -21,8,-27,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_skateb_19
	db $EE,$00,$01,$06
	dw -7,-27,$0800 : db $FF
	dw -21,-11,$0802 : db $FF
	dw -5,-11,$0804 : db $FF
	dw -5,5,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":8119..8535

SpriteFrame_skateb_20:
	db $03,$80
	dw $000C
	dw -17,8,-27,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_20
	db $F2,$00,$02,$03
	dw -4,-27,$0800 : db $FF
	dw -17,-11,$0802 : db $FF
	dw -1,-11,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":8578..8962
SpriteFrame_skateb_21:
	db $04,$80
	dw $000A
	dw -19,8,-26,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skateb_21
	db $EF,$F6,$06,$06
	dw -7,-26,$0800 : db $FF
	dw -7,-10,$0802 : db $FF
	dw -23,-13,$0804 : db $00
	dw -15,-13,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":9012..9332
SpriteFrame_skateb_22:
	db $03,$80
	dw $000C
	dw -17,10,-26,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_skateb_22
	db $F3,$F7,$02,$05
	dw -5,-26,$0800 : db $FF
	dw -17,-10,$0802 : db $FF
	dw -1,-10,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":9375..9759
SpriteFrame_skateb_23:
	db $04,$80
	dw $000A
	dw -14,9,-24,7
	dw $00C0,$0080
	dw .tiles-SpriteFrame_skateb_23
	db $F5,$FB,$04,$03
	dw -6,-24,$0800 : db $FF
	dw -6,-8,$0802 : db $FF
	dw -14,-10,$0804 : db $00
	dw -14,-2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":9809..10129
SpriteFrame_celebrate_0:
	db $05,$80
	dw $000E
	dw -9,9,-42,1
	dw $0100,$00C0
	dw .tiles-SpriteFrame_celebrate_0
	db $00,$00,$00,$00
	dw -7,-14,$0800 : db $FF
	dw -9,-30,$0802 : db $FF
	dw -6,-46,$0804 : db $FF
	dw 7,-30,$0806 : db $00
	dw 7,-22,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":10186..10634
SpriteFrame_celebrate_1:
	db $08,$80
	dw $000E
	dw -8,14,-54,1
	dw $0100,$00C0
	dw .tiles-SpriteFrame_celebrate_1
	db $00,$00,$00,$00
	dw -8,-38,$0800 : db $FF
	dw -4,-22,$0802 : db $FF
	dw 9,-54,$0804 : db $00
	dw 9,-46,$0805 : db $00
	dw 8,-38,$0814 : db $00
	dw 8,-30,$0815 : db $00
	dw -7,-6,$0806 : db $00
	dw 1,-6,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":10712..11160
SpriteFrame_celebrate_2:
	db $06,$80
	dw $000F
	dw -7,17,-43,2
	dw $0100,$00E0
	dw .tiles-SpriteFrame_celebrate_2
	db $00,$FF,$00,$00
	dw 2,-43,$0800 : db $FF
	dw -6,-27,$0802 : db $FF
	dw -7,-11,$0804 : db $FF
	dw -6,-35,$0806 : db $00
	dw 10,-27,$0807 : db $00
	dw 9,-3,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":11224..11704
SpriteFrame_celebrate_3:
	db $05,$80
	dw $000E
	dw -6,9,-50,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_celebrate_3
	db $00,$FF,$00,$00
	dw -5,-50,$0800 : db $FF
	dw -6,-34,$0802 : db $FF
	dw -6,-18,$0804 : db $FF
	dw -6,-2,$0806 : db $00
	dw 2,-2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":11761..12209
SpriteFrame_celebrate_4:
	db $05,$80
	dw $000E
	dw -7,10,-48,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_celebrate_4
	db $01,$FF,$00,$00
	dw -1,-48,$0800 : db $FF
	dw -7,-32,$0802 : db $FF
	dw -4,-16,$0804 : db $FF
	dw -3,0,$0806 : db $00
	dw 5,0,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":12266..12714

SpriteFrame_celebrate_5:
	db $05,$80
	dw $000E
	dw -6,9,-53,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_celebrate_5
	db $01,$FF,$00,$00
	dw -6,-37,$0800 : db $FF
	dw -5,-21,$0802 : db $FF
	dw -2,-5,$0804 : db $FF
	dw -1,-53,$0806 : db $00
	dw -1,-45,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":12771..13219
SpriteFrame_celebrate_6:
	db $08,$80
	dw $000E
	dw -9,10,-48,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_celebrate_6
	db $00,$FF,$00,$00
	dw -9,-32,$0800 : db $FF
	dw -9,-16,$0802 : db $FF
	dw -9,-48,$0804 : db $00
	dw -9,-40,$0805 : db $00
	dw -9,0,$0814 : db $00
	dw -1,0,$0815 : db $00
	dw 7,-29,$0806 : db $00
	dw 7,-1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":13297..13745
SpriteFrame_celebrate_7:
	db $05,$80
	dw $000E
	dw -8,9,-52,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_celebrate_7
	db $01,$00,$00,$00
	dw -8,-36,$0800 : db $FF
	dw -4,-20,$0802 : db $FF
	dw -6,-4,$0804 : db $FF
	dw -8,-52,$0806 : db $00
	dw -8,-44,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":13802..14250
SpriteFrame_celebrate_8:
	db $07,$80
	dw $0010
	dw -10,10,-44,6
	dw $0100,$0100
	dw .tiles-SpriteFrame_celebrate_8
	db $FF,$01,$00,$00
	dw -8,-44,$0800 : db $FF
	dw -10,-28,$0802 : db $FF
	dw -10,-12,$0804 : db $FF
	dw 6,-28,$0806 : db $00
	dw 6,-20,$0807 : db $00
	dw 6,-4,$0816 : db $00
	dw -8,4,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":14321..14833
SpriteFrame_celebrate_9:
	db $09,$80
	dw $0012
	dw -11,10,-47,4
	dw $0140,$0100
	dw .tiles-SpriteFrame_celebrate_9
	db $00,$01,$00,$00
	dw -11,-47,$0800 : db $FF
	dw -11,-31,$0802 : db $FF
	dw -11,-15,$0804 : db $FF
	dw -11,1,$0806 : db $00
	dw -3,1,$0807 : db $00
	dw 5,-32,$0816 : db $00
	dw 5,-24,$0817 : db $00
	dw 5,-11,$0808 : db $00
	dw 5,-3,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":14918..15494
SpriteFrame_celebrate_10:
	db $04,$80
	dw $000D
	dw -9,8,-43,4
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_celebrate_10
	db $00,$00,$00,$00
	dw -7,-43,$0800 : db $FF
	dw -9,-27,$0802 : db $FF
	dw -9,-11,$0804 : db $FF
	dw 7,-27,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":15544..15960
SpriteFrame_celebrate_11:
	db $04,$80
	dw $0010
	dw -7,9,-54,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_celebrate_11
	db $00,$00,$00,$00
	dw -3,-54,$0800 : db $FF
	dw -6,-38,$0802 : db $FF
	dw -6,-22,$0804 : db $FF
	dw -7,-6,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":16010..16522

SpriteFrame_celebrate_12:
	db $05,$80
	dw $000E
	dw -5,8,-48,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_celebrate_12
	db $01,$FF,$00,$00
	dw -2,-48,$0800 : db $FF
	dw -4,-32,$0802 : db $FF
	dw -4,-16,$0804 : db $FF
	dw -5,0,$0806 : db $00
	dw 3,0,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":16579..17027
SpriteFrame_celebrate_13:
	db $06,$80
	dw $000C
	dw -5,5,-51,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_celebrate_13
	db $01,$FF,$00,$00
	dw -4,-51,$0800 : db $FF
	dw -5,-35,$0802 : db $FF
	dw -4,-19,$0804 : db $00
	dw -4,-11,$0805 : db $00
	dw -5,-3,$0814 : db $00
	dw 3,-3,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":17091..17475
SpriteFrame_celebrate_14:
	db $05,$80
	dw $000B
	dw -10,7,-44,4
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_celebrate_14
	db $00,$00,$00,$00
	dw -8,-28,$0800 : db $FF
	dw -10,-12,$0802 : db $FF
	dw -1,-44,$0804 : db $00
	dw -1,-36,$0805 : db $00
	dw -4,4,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":17532..17884
SpriteFrame_celebrate_15:
	db $06,$80
	dw $000C
	dw -7,7,-49,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_celebrate_15
	db $00,$00,$00,$00
	dw -3,-33,$0800 : db $FF
	dw -4,-17,$0802 : db $FF
	dw -1,-49,$0804 : db $00
	dw -1,-41,$0805 : db $00
	dw -7,-1,$0814 : db $00
	dw 1,-1,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":17948..18332
SpriteFrame_pump_0:
	db $05,$80
	dw $000E
	dw -7,13,-40,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_pump_0
	db $00,$00,$00,$00
	dw -7,-13,$0800 : db $FF
	dw -6,-29,$0802 : db $FF
	dw 0,-45,$0804 : db $FF
	dw 10,-29,$0806 : db $00
	dw 10,-21,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":18389..18837
SpriteFrame_pump_1:
	db $04,$80
	dw $000A
	dw -4,7,-46,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_pump_1
	db $00,$00,$00,$00
	dw -4,-30,$0800 : db $FF
	dw -4,-14,$0802 : db $FF
	dw -2,-46,$0804 : db $00
	dw -2,-38,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":18887..19207
SpriteFrame_pump_2:
	db $05,$80
	dw $000B
	dw -6,19,-30,2
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_pump_2
	db $00,$00,$00,$00
	dw -6,-29,$0800 : db $FF
	dw -6,-13,$0802 : db $FF
	dw 18,-30,$0804 : db $00
	dw 10,-22,$0805 : db $00
	dw 10,-2,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":19264..19616
SpriteFrame_pump_3:
	db $05,$80
	dw $000E
	dw -4,16,-44,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_pump_3
	db $02,$00,$00,$00
	dw 2,-44,$0800 : db $FF
	dw -4,-28,$0802 : db $FF
	dw -2,-12,$0804 : db $FF
	dw 12,-28,$0806 : db $00
	dw 12,-20,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":19673..20121
SpriteFrame_pump_4:
	db $06,$80
	dw $000F
	dw -6,18,-31,4
	dw $0100,$00E0
	dw .tiles-SpriteFrame_pump_4
	db $00,$00,$00,$00
	dw -6,-31,$0800 : db $FF
	dw 10,-31,$0802 : db $FF
	dw -4,-15,$0804 : db $FF
	dw -5,1,$0806 : db $00
	dw 3,1,$0807 : db $00
	dw 11,1,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":20185..20665

SpriteFrame_pump_5:
	db $05,$80
	dw $000E
	dw -12,15,-39,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_pump_5
	db $FD,$00,$00,$00
	dw -9,-13,$0800 : db $FF
	dw -12,-29,$0802 : db $FF
	dw 4,-29,$0804 : db $FF
	dw 13,-45,$0806 : db $00
	dw 13,-37,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":20722..21170
SpriteFrame_pump_6:
	db $07,$80
	dw $000D
	dw -9,16,-28,10
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_pump_6
	db $00,$00,$00,$00
	dw -9,-28,$0800 : db $FF
	dw -8,-12,$0802 : db $FF
	dw 7,-20,$0804 : db $00
	dw 15,-20,$0805 : db $00
	dw -7,4,$0814 : db $00
	dw 1,4,$0815 : db $00
	dw 9,4,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":21241..21657
SpriteFrame_pump_7:
	db $05,$80
	dw $000E
	dw -8,21,-27,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_pump_7
	db $02,$01,$00,$00
	dw -8,-27,$0800 : db $FF
	dw 8,-27,$0802 : db $FF
	dw -7,-11,$0804 : db $FF
	dw 9,-11,$0806 : db $00
	dw 9,-3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":21714..22162
SpriteFrame_pump_8:
	db $07,$80
	dw $000D
	dw -15,8,-30,4
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_pump_8
	db $00,$00,$00,$00
	dw -14,-11,$0800 : db $FF
	dw -15,-27,$0802 : db $FF
	dw 2,-11,$0804 : db $00
	dw 2,-3,$0805 : db $00
	dw 1,-27,$0814 : db $00
	dw 1,-19,$0815 : db $00
	dw 0,-35,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":22233..22649
SpriteFrame_pump_9:
	db $04,$80
	dw $000A
	dw -7,8,-35,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_pump_9
	db $00,$00,$00,$00
	dw -7,-35,$0800 : db $FF
	dw -6,-19,$0802 : db $FF
	dw -4,-3,$0804 : db $00
	dw 4,-3,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":22699..23019
SpriteFrame_pump_10:
	db $07,$80
	dw $0010
	dw -19,8,-30,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_pump_10
	db $00,$00,$00,$00
	dw -18,-30,$0800 : db $FF
	dw -19,-14,$0802 : db $FF
	dw -3,-14,$0804 : db $FF
	dw -2,-30,$0806 : db $00
	dw -2,-22,$0807 : db $00
	dw -6,2,$0816 : db $00
	dw 2,2,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":23090..23602
SpriteFrame_pump_11:
	db $07,$80
	dw $0010
	dw -15,11,-30,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_pump_11
	db $02,$00,$00,$00
	dw -14,-12,$0800 : db $FF
	dw -15,-28,$0802 : db $FF
	dw 1,-28,$0804 : db $FF
	dw 2,-12,$0806 : db $00
	dw 2,-4,$0807 : db $00
	dw -12,-36,$0816 : db $00
	dw -4,-36,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":23673..24185
SpriteFrame_pump_12:
	db $04,$80
	dw $000A
	dw -16,3,-30,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_pump_12
	db $00,$00,$00,$00
	dw -16,-30,$0800 : db $FF
	dw -11,-14,$0802 : db $FF
	dw 0,-22,$0804 : db $00
	dw -4,2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":24235..24555
SpriteFrame_pump_13:
	db $06,$80
	dw $000F
	dw -18,10,-38,1
	dw $0100,$00E0
	dw .tiles-SpriteFrame_pump_13
	db $01,$FF,$00,$00
	dw -13,-14,$0800 : db $FF
	dw -17,-30,$0802 : db $FF
	dw -1,-30,$0804 : db $FF
	dw 3,-14,$0806 : db $00
	dw 3,-6,$0807 : db $00
	dw -18,-38,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":24619..25099

SpriteFrame_pump_14:
	db $06,$80
	dw $000C
	dw -10,7,-34,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_pump_14
	db $00,$00,$00,$00
	dw -10,-11,$0800 : db $FF
	dw -10,-27,$0802 : db $FF
	dw 6,-3,$0804 : db $00
	dw 6,-27,$0805 : db $00
	dw 6,-19,$0814 : db $00
	dw -7,-35,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":25163..25547
SpriteFrame_pump_15:
	db $03,$80
	dw $000C
	dw -9,7,-37,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_pump_15
	db $00,$00,$00,$00
	dw -9,-37,$0800 : db $FF
	dw -7,-21,$0802 : db $FF
	dw -6,-5,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":25590..25974
SpriteFrame_cup_0:
	db $05,$80
	dw $000E
	dw -11,13,-33,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_cup_0
	db $00,$01,$00,$00
	dw -11,-33,$0800 : db $FF
	dw 5,-33,$0802 : db $FF
	dw -4,-17,$0804 : db $FF
	dw -7,-1,$0806 : db $00
	dw 1,-1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":26031..26479
SpriteFrame_cup_1:
	db $04,$80
	dw $000A
	dw -5,8,-36,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_cup_1
	db $00,$00,$00,$00
	dw -4,-36,$0800 : db $FF
	dw -4,-20,$0802 : db $FF
	dw -5,-4,$0804 : db $00
	dw 3,-4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":26529..26849
SpriteFrame_cup_2:
	db $05,$80
	dw $0008
	dw -4,8,-31,3
	dw $0080,$0080
	dw .tiles-SpriteFrame_cup_2
	db $01,$01,$00,$00
	dw -4,-15,$0800 : db $FF
	dw -4,-31,$0802 : db $00
	dw -4,-23,$0803 : db $00
	dw -4,1,$0812 : db $00
	dw 4,1,$0813 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":26906..27162
SpriteFrame_cup_3:
	db $04,$80
	dw $000A
	dw -6,9,-36,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_cup_3
	db $01,$01,$00,$00
	dw -6,-36,$0800 : db $FF
	dw -4,-20,$0802 : db $FF
	dw -5,-4,$0804 : db $00
	dw 3,-4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":27212..27532
SpriteFrame_cup_4:
	db $06,$80
	dw $000C
	dw -12,11,-33,2
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_cup_4
	db $00,$00,$00,$00
	dw -12,-33,$0800 : db $FF
	dw -5,-17,$0802 : db $FF
	dw 4,-33,$0804 : db $00
	dw 4,-25,$0805 : db $00
	dw -8,-1,$0814 : db $00
	dw 0,-1,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":27596..27980
SpriteFrame_cup_5:
	db $06,$80
	dw $000C
	dw -7,9,-33,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_cup_5
	db $01,$00,$00,$00
	dw -7,-33,$0800 : db $FF
	dw -6,-17,$0802 : db $FF
	dw 9,-33,$0804 : db $00
	dw 9,-25,$0805 : db $00
	dw -6,-1,$0814 : db $00
	dw 2,-1,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":28044..28428
SpriteFrame_cup_6:
	db $05,$80
	dw $0008
	dw -6,6,-30,3
	dw $0080,$0080
	dw .tiles-SpriteFrame_cup_6
	db $01,$01,$00,$00
	dw -5,-14,$0800 : db $FF
	dw -1,-30,$0802 : db $00
	dw -1,-22,$0803 : db $00
	dw -6,2,$0812 : db $00
	dw 2,2,$0813 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":28485..28741

SpriteFrame_cup_7:
	db $04,$80
	dw $000A
	dw -9,7,-33,2
	dw $00C0,$0080
	dw .tiles-SpriteFrame_cup_7
	db $01,$00,$00,$00
	dw -9,-33,$0800 : db $FF
	dw -5,-17,$0802 : db $FF
	dw -5,-1,$0804 : db $00
	dw 3,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":28791..29111
SpriteFrame_cupover_0:
	db $03,$80
	dw $0006
	dw -11,12,-39,-31
	dw $0080,$0040
	dw .tiles-SpriteFrame_cupover_0
	db $00,$01,$00,$00
	dw -11,-39,$0200 : db $FF
	dw 5,-39,$0202 : db $00
	dw 5,-31,$0203 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":29154..29346
SpriteFrame_cupover_1:
	db $01,$80
	dw $0004
	dw -2,10,-39,-30
	dw $0040,$0040
	dw .tiles-SpriteFrame_cupover_1
	db $00,$00,$00,$00
	dw -2,-39,$0200 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":29375..29503
SpriteFrame_cupover_2:
	db $01,$80
	dw $0004
	dw -3,5,-39,-30
	dw $0040,$0040
	dw .tiles-SpriteFrame_cupover_2
	db $01,$01,$00,$00
	dw -3,-39,$0200 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":29532..29660
SpriteFrame_cupover_3:
	db $01,$80
	dw $0004
	dw -6,6,-39,-30
	dw $0040,$0040
	dw .tiles-SpriteFrame_cupover_3
	db $01,$01,$00,$00
	dw -6,-39,$0200 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":29689..29817
SpriteFrame_cupover_4:
	db $02,$80
	dw $0005
	dw -12,11,-39,-31
	dw $0060,$0040
	dw .tiles-SpriteFrame_cupover_4
	db $00,$00,$00,$00
	dw -12,-39,$0200 : db $FF
	dw 4,-39,$0202 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":29853..30013
SpriteFrame_cupover_5:
	db $01,$80
	dw $0004
	dw -7,8,-39,-29
	dw $0040,$0040
	dw .tiles-SpriteFrame_cupover_5
	db $01,$00,$00,$00
	dw -7,-39,$0200 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":30042..30170
SpriteFrame_cupover_6:
	db $02,$00
	dw $0002
	dw -4,3,-39,-30
	dw $0040,$0000
	dw .tiles-SpriteFrame_cupover_6
	db $01,$01,$00,$00
	dw -4,-39,$0200 : db $00
	dw -4,-31,$0201 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":30206..30270
SpriteFrame_cupover_7:
	db $01,$80
	dw $0004
	dw -9,6,-40,-29
	dw $0040,$0040
	dw .tiles-SpriteFrame_cupover_7
	db $01,$00,$00,$00
	dw -9,-40,$0200 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":30299..30427
SpriteFrame_hipl_0:
	db $05,$80
	dw $000E
	dw -19,10,-26,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_hipl_0
	db $EF,$FF,$03,$04
	dw -3,-26,$0800 : db $FF
	dw -19,-10,$0802 : db $FF
	dw -3,-10,$0804 : db $FF
	dw -19,-18,$0806 : db $00
	dw -11,-18,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":30484..30932
SpriteFrame_hipl_1:
	db $06,$80
	dw $000C
	dw -11,14,-26,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_hipl_1
	db $F8,$FC,$03,$04
	dw -9,-26,$0800 : db $FF
	dw -11,-10,$0802 : db $FF
	dw 7,-26,$0804 : db $00
	dw 7,-18,$0805 : db $00
	dw 5,-10,$0814 : db $00
	dw 5,-2,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":30996..31380
SpriteFrame_hipl_2:
	db $05,$80
	dw $000B
	dw -5,29,-17,4
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_hipl_2
	db $1B,$02,$03,$04
	dw -5,-11,$0800 : db $FF
	dw 11,-11,$0802 : db $FF
	dw 27,-11,$0804 : db $00
	dw -1,-19,$0805 : db $00
	dw 7,-19,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":31437..31789
SpriteFrame_hipl_3:
	db $05,$80
	dw $000B
	dw -10,23,-16,7
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_hipl_3
	db $15,$05,$03,$04
	dw -9,-8,$0800 : db $FF
	dw 7,-8,$0802 : db $FF
	dw 23,-8,$0804 : db $00
	dw -10,-16,$0805 : db $00
	dw -2,-16,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":31846..32198
SpriteFrame_hipl_4:
	db $04,$80
	dw $000A
	dw -10,13,-14,13
	dw $00C0,$0080
	dw .tiles-SpriteFrame_hipl_4
	db $09,$0D,$03,$04
	dw -10,-14,$0800 : db $FF
	dw -10,2,$0802 : db $FF
	dw 6,2,$0804 : db $00
	dw 6,10,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames84.bin":32248..32568
