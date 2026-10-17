; More frames of SpriteFrames. A frame is the piece count, flags (bit 7: 16x16 tiles), tile
; count, the box of its pixels (left, right, top, bottom; nothing reads it), the two transfer
; sizes, the tile offset, the hot spot x / y (signed bytes, GetHot), the stick point x / y
; (GetFrameHot), the pieces, then the tiles. Frame labels are SpriteFrame_<group>_<n>.

SpriteFrame_fallback_24:
	db $04,$80
	dw $000D
	dw -15,11,-13,16
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_fallback_24
	db $F3,$0C,$02,$0B
	dw -15,-13,$0800 : db $FF
	dw 1,-13,$0802 : db $FF
	dw -14,3,$0804 : db $FF
	dw 2,3,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":50..466
SpriteFrame_fallback_25:
	db $07,$80
	dw $0010
	dw -16,13,-29,12
	dw $0100,$0100
	dw .tiles-SpriteFrame_fallback_25
	db $F9,$08,$00,$07
	dw -16,-13,$0800 : db $FF
	dw 0,-13,$0802 : db $FF
	dw -16,3,$0804 : db $FF
	dw -9,-29,$0806 : db $00
	dw -9,-21,$0807 : db $00
	dw 0,3,$0816 : db $00
	dw 8,3,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":537..1049
SpriteFrame_fallback_26:
	db $07,$80
	dw $0010
	dw -18,33,-10,9
	dw $0100,$0100
	dw .tiles-SpriteFrame_fallback_26
	db $1D,$00,$00,$02
	dw 18,-8,$0800 : db $FF
	dw 2,-10,$0802 : db $FF
	dw -14,-4,$0804 : db $FF
	dw 2,6,$0806 : db $00
	dw 10,6,$0807 : db $00
	dw -22,-5,$0816 : db $00
	dw -22,3,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":1120..1632
SpriteFrame_fallback_27:
	db $06,$80
	dw $000C
	dw -15,6,-21,13
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_fallback_27
	db $04,$08,$FE,$06
	dw -9,-21,$0800 : db $FF
	dw -15,-5,$0802 : db $FF
	dw 1,-5,$0804 : db $00
	dw 1,3,$0805 : db $00
	dw -14,11,$0814 : db $00
	dw -6,11,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":1696..2080
SpriteFrame_fallback_28:
	db $04,$80
	dw $000A
	dw -12,11,-14,10
	dw $00C0,$0080
	dw .tiles-SpriteFrame_fallback_28
	db $F7,$09,$01,$0C
	dw -12,-14,$0800 : db $FF
	dw -12,2,$0802 : db $FF
	dw 4,-8,$0804 : db $00
	dw 4,0,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":2130..2450
SpriteFrame_fallback_29:
	db $06,$80
	dw $0012
	dw -15,15,-30,10
	dw $0140,$0100
	dw .tiles-SpriteFrame_fallback_29
	db $08,$07,$02,$07
	dw -15,-14,$0800 : db $FF
	dw 1,-14,$0802 : db $FF
	dw -11,2,$0804 : db $FF
	dw 5,2,$0806 : db $FF
	dw 3,-30,$0808 : db $00
	dw 3,-22,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":2514..3090
SpriteFrame_fallback_30:
	db $07,$80
	dw $0010
	dw -15,31,-15,21
	dw $0100,$0100
	dw .tiles-SpriteFrame_fallback_30
	db $1E,$14,$01,$00
	dw -15,-15,$0800 : db $FF
	dw -5,1,$0802 : db $FF
	dw 11,1,$0804 : db $FF
	dw 1,-15,$0806 : db $00
	dw 1,-7,$0807 : db $00
	dw 27,9,$0816 : db $00
	dw 26,17,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":3161..3673
SpriteFrame_fallback_31:
	db $07,$80
	dw $000A
	dw -14,9,-33,7
	dw $00C0,$0080
	dw .tiles-SpriteFrame_fallback_31
	db $04,$05,$F9,$FF
	dw -14,-8,$0800 : db $FF
	dw 2,-8,$0802 : db $00
	dw 2,0,$0803 : db $00
	dw -1,-24,$0812 : db $00
	dw -1,-16,$0813 : db $00
	dw -2,-40,$0804 : db $00
	dw -2,-32,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":3744..4064
SpriteFrame_fallfwd_0:
	db $04,$80
	dw $000A
	dw -7,8,-17,17
	dw $00C0,$0080
	dw .tiles-SpriteFrame_fallfwd_0
	db $02,$FB,$04,$0F
	dw -7,-17,$0800 : db $FF
	dw -6,-1,$0802 : db $FF
	dw -7,15,$0804 : db $00
	dw 1,15,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":4114..4434

SpriteFrame_fallfwd_1:
	db $05,$80
	dw $000B
	dw -9,12,-18,18
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_fallfwd_1
	db $F8,$F4,$05,$0D
	dw -6,3,$0800 : db $FF
	dw -9,-13,$0802 : db $FF
	dw 10,11,$0804 : db $00
	dw 7,-5,$0805 : db $00
	dw -9,-21,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":4491..4843
SpriteFrame_fallfwd_2:
	db $04,$80
	dw $000D
	dw -12,10,-23,17
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_fallfwd_2
	db $F8,$ED,$05,$07
	dw -6,2,$0800 : db $FF
	dw -9,-14,$0802 : db $FF
	dw -12,-30,$0804 : db $FF
	dw 7,-6,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":4893..5309
SpriteFrame_fallfwd_3:
	db $03,$80
	dw $0009
	dw -11,8,-16,13
	dw $00A0,$0080
	dw .tiles-SpriteFrame_fallfwd_3
	db $F8,$F4,$04,$08
	dw -11,-16,$0800 : db $FF
	dw -7,0,$0802 : db $FF
	dw 5,-8,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":5352..5640
SpriteFrame_fallfwd_4:
	db $05,$80
	dw $000E
	dw -12,15,-14,16
	dw $0100,$00C0
	dw .tiles-SpriteFrame_fallfwd_4
	db $0F,$00,$06,$0E
	dw -4,-14,$0800 : db $FF
	dw -12,2,$0802 : db $FF
	dw 4,2,$0804 : db $FF
	dw 12,-14,$0806 : db $00
	dw 12,-6,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":5697..6145
SpriteFrame_fallfwd_5:
	db $05,$80
	dw $0011
	dw -15,24,-19,19
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallfwd_5
	db $14,$F1,$06,$0B
	dw -15,4,$0800 : db $FF
	dw 1,4,$0802 : db $FF
	dw -7,-12,$0804 : db $FF
	dw 9,-12,$0806 : db $FF
	dw 18,-20,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":6202..6746
SpriteFrame_fallfwd_6:
	db $06,$80
	dw $000F
	dw -16,20,-30,17
	dw $0100,$00E0
	dw .tiles-SpriteFrame_fallfwd_6
	db $10,$E6,$03,$08
	dw -7,-14,$0800 : db $FF
	dw 9,-14,$0802 : db $FF
	dw -16,2,$0804 : db $FF
	dw 14,-30,$0806 : db $00
	dw 14,-22,$0807 : db $00
	dw 0,2,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":6810..7290
SpriteFrame_fallfwd_7:
	db $03,$80
	dw $000C
	dw -9,20,-11,16
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_fallfwd_7
	db $10,$F7,$04,$0A
	dw -4,-11,$0800 : db $FF
	dw 12,-11,$0802 : db $FF
	dw -9,5,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":7333..7717
SpriteFrame_fallfwd_8:
	db $05,$80
	dw $0011
	dw -12,32,-11,17
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallfwd_8
	db $1D,$0F,$05,$0F
	dw -12,2,$0800 : db $FF
	dw 4,2,$0802 : db $FF
	dw 20,2,$0804 : db $FF
	dw -4,-14,$0806 : db $FF
	dw 12,-6,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":7774..8318

SpriteFrame_fallfwd_9:
	db $08,$80
	dw $0014
	dw -17,40,-9,14
	dw $0140,$0140
	dw .tiles-SpriteFrame_fallfwd_9
	db $26,$0B,$05,$0D
	dw -17,-1,$0800 : db $FF
	dw -1,-1,$0802 : db $FF
	dw 15,-1,$0804 : db $FF
	dw 31,-1,$0806 : db $FF
	dw -14,-9,$0808 : db $00
	dw -6,-9,$0809 : db $00
	dw 2,-9,$0818 : db $00
	dw 10,-9,$0819 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":8396..9036
SpriteFrame_fallfwd_10:
	db $05,$80
	dw $0011
	dw -20,46,-6,9
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallfwd_10
	db $2B,$06,$05,$07
	dw -20,-6,$0800 : db $FF
	dw -4,-6,$0802 : db $FF
	dw 12,-6,$0804 : db $FF
	dw 28,-6,$0806 : db $FF
	dw 44,2,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":9093..9637
SpriteFrame_fallfwd_11:
	db $06,$80
	dw $000F
	dw -15,34,-10,12
	dw $0100,$00E0
	dw .tiles-SpriteFrame_fallfwd_11
	db $1F,$04,$07,$0A
	dw -15,-3,$0800 : db $FF
	dw 1,-3,$0802 : db $FF
	dw 17,-3,$0804 : db $FF
	dw 33,-3,$0806 : db $00
	dw -3,-11,$0807 : db $00
	dw 5,-11,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":9701..10181
SpriteFrame_fallfwd_12:
	db $05,$80
	dw $0011
	dw -11,27,-9,20
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallfwd_12
	db $18,$17,$05,$11
	dw -8,-9,$0800 : db $FF
	dw 8,-9,$0802 : db $FF
	dw -11,7,$0804 : db $FF
	dw 5,7,$0806 : db $FF
	dw 21,7,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":10238..10782
SpriteFrame_fallfwd_13:
	db $07,$80
	dw $0013
	dw -14,32,-10,24
	dw $0140,$0120
	dw .tiles-SpriteFrame_fallfwd_13
	db $1E,$17,$05,$0A
	dw -14,-10,$0800 : db $FF
	dw 2,-3,$0802 : db $FF
	dw 2,13,$0804 : db $FF
	dw 18,4,$0806 : db $FF
	dw -6,6,$0808 : db $00
	dw 18,20,$0809 : db $00
	dw 26,20,$0818 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":10853..11461
SpriteFrame_fallfwd_14:
	db $05,$80
	dw $0011
	dw -15,37,-11,19
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallfwd_14
	db $23,$12,$07,$06
	dw -15,-11,$0800 : db $FF
	dw 1,-11,$0802 : db $FF
	dw 0,5,$0804 : db $FF
	dw 16,5,$0806 : db $FF
	dw 32,13,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":11518..12062
SpriteFrame_fallfwd_15:
	db $04,$80
	dw $000D
	dw -13,23,-4,25
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_fallfwd_15
	db $15,$18,$05,$0A
	dw -13,-4,$0800 : db $FF
	dw 3,-4,$0802 : db $FF
	dw 3,12,$0804 : db $FF
	dw 19,20,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":12112..12528

SpriteFrame_fallfwd_16:
	db $04,$80
	dw $000A
	dw -11,10,-4,26
	dw $00C0,$0080
	dw .tiles-SpriteFrame_fallfwd_16
	db $FD,$19,$03,$0E
	dw -11,-4,$0800 : db $FF
	dw -8,12,$0802 : db $FF
	dw 5,-4,$0804 : db $00
	dw 5,4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":12578..12898
SpriteFrame_fallfwd_17:
	db $06,$80
	dw $000F
	dw -13,12,-11,43
	dw $0100,$00E0
	dw .tiles-SpriteFrame_fallfwd_17
	db $00,$2A,$04,$0D
	dw -7,-11,$0800 : db $FF
	dw -13,5,$0802 : db $FF
	dw 3,5,$0804 : db $FF
	dw -11,21,$0806 : db $00
	dw -11,29,$0807 : db $00
	dw -5,37,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":12962..13442
SpriteFrame_fallfwd_18:
	db $07,$80
	dw $000D
	dw -10,10,-13,41
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_fallfwd_18
	db $05,$27,$04,$08
	dw -6,-13,$0800 : db $FF
	dw -10,3,$0802 : db $FF
	dw 6,3,$0804 : db $00
	dw 6,11,$0805 : db $00
	dw -6,19,$0814 : db $00
	dw -6,27,$0815 : db $00
	dw 0,35,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":13513..13929
SpriteFrame_fallfwd_19:
	db $04,$80
	dw $000D
	dw -7,11,-7,35
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_fallfwd_19
	db $03,$22,$05,$07
	dw -7,-7,$0800 : db $FF
	dw -7,9,$0802 : db $FF
	dw -3,25,$0804 : db $FF
	dw 9,9,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":13979..14395
SpriteFrame_fallfwd_20:
	db $05,$80
	dw $0011
	dw -30,11,-9,19
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallfwd_20
	db $E7,$12,$02,$0D
	dw -18,-9,$0800 : db $FF
	dw -2,-9,$0802 : db $FF
	dw -30,7,$0804 : db $FF
	dw -12,7,$0806 : db $FF
	dw 4,7,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":14452..14996
SpriteFrame_fallfwd_21:
	db $08,$80
	dw $0011
	dw -30,16,-10,29
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallfwd_21
	db $E6,$1C,$04,$0B
	dw -30,4,$0800 : db $FF
	dw -14,-4,$0802 : db $FF
	dw 2,-10,$0804 : db $FF
	dw -30,20,$0806 : db $00
	dw -30,28,$0807 : db $00
	dw -14,12,$0816 : db $00
	dw -6,12,$0817 : db $00
	dw 2,6,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":15074..15618
SpriteFrame_fallfwd_22:
	db $07,$80
	dw $0010
	dw -31,17,-11,25
	dw $0100,$0100
	dw .tiles-SpriteFrame_fallfwd_22
	db $E3,$18,$02,$07
	dw -31,10,$0800 : db $FF
	dw -21,-6,$0802 : db $FF
	dw -5,-6,$0804 : db $FF
	dw -10,10,$0806 : db $00
	dw 11,-6,$0807 : db $00
	dw 1,-14,$0816 : db $00
	dw 9,-14,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":15689..16201
SpriteFrame_fallfwd_23:
	db $04,$80
	dw $000D
	dw -22,12,-5,26
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_fallfwd_23
	db $EC,$19,$03,$0A
	dw -14,-5,$0800 : db $FF
	dw 2,-5,$0802 : db $FF
	dw -22,11,$0804 : db $FF
	dw -6,11,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":16251..16667

SpriteFrame_fallfwd_24:
	db $04,$80
	dw $0010
	dw -29,16,-10,16
	dw $0100,$0100
	dw .tiles-SpriteFrame_fallfwd_24
	db $EA,$0E,$09,$10
	dw -29,1,$0800 : db $FF
	dw -13,1,$0802 : db $FF
	dw 3,1,$0804 : db $FF
	dw -9,-15,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":16717..17229
SpriteFrame_fallfwd_25:
	db $08,$80
	dw $0014
	dw -41,16,-9,14
	dw $0140,$0140
	dw .tiles-SpriteFrame_fallfwd_25
	db $DB,$0D,$05,$0D
	dw -41,-1,$0800 : db $FF
	dw -25,-1,$0802 : db $FF
	dw -9,-1,$0804 : db $FF
	dw 7,-1,$0806 : db $FF
	dw -12,-9,$0808 : db $00
	dw -4,-9,$0809 : db $00
	dw 4,-9,$0818 : db $00
	dw 12,-9,$0819 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":17307..17947
SpriteFrame_fallfwd_26:
	db $06,$80
	dw $0012
	dw -46,20,-7,8
	dw $0140,$0100
	dw .tiles-SpriteFrame_fallfwd_26
	db $D6,$06,$01,$05
	dw -46,-7,$0800 : db $FF
	dw -30,-7,$0802 : db $FF
	dw -14,-7,$0804 : db $FF
	dw 2,-7,$0806 : db $FF
	dw 18,-7,$0808 : db $00
	dw 18,1,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":18011..18587
SpriteFrame_fallfwd_27:
	db $06,$80
	dw $000F
	dw -33,16,-9,13
	dw $0100,$00E0
	dw .tiles-SpriteFrame_fallfwd_27
	db $E4,$0B,$01,$0A
	dw -33,-2,$0800 : db $FF
	dw -17,-2,$0802 : db $FF
	dw -1,-2,$0804 : db $FF
	dw 15,6,$0806 : db $00
	dw -12,-10,$0807 : db $00
	dw -4,-10,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":18651..19131
SpriteFrame_fallfwd_28:
	db $04,$80
	dw $0010
	dw -22,11,-13,18
	dw $0100,$0100
	dw .tiles-SpriteFrame_fallfwd_28
	db $EE,$08,$00,$10
	dw -22,-13,$0800 : db $FF
	dw -6,-13,$0802 : db $FF
	dw -16,3,$0804 : db $FF
	dw 0,3,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":19181..19693
SpriteFrame_fallfwd_29:
	db $06,$80
	dw $000F
	dw -34,16,-11,19
	dw $0100,$00E0
	dw .tiles-SpriteFrame_fallfwd_29
	db $E2,$F9,$01,$09
	dw -18,-11,$0800 : db $FF
	dw -2,-11,$0802 : db $FF
	dw -6,5,$0804 : db $FF
	dw -34,-11,$0806 : db $00
	dw -26,-11,$0807 : db $00
	dw 10,5,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":19757..20237
SpriteFrame_fallfwd_30:
	db $07,$80
	dw $0013
	dw -33,16,-16,17
	dw $0140,$0120
	dw .tiles-SpriteFrame_fallfwd_30
	db $E3,$F3,$00,$06
	dw -33,-16,$0800 : db $FF
	dw -17,-16,$0802 : db $FF
	dw -13,0,$0804 : db $FF
	dw 3,0,$0806 : db $FF
	dw -1,-16,$0808 : db $00
	dw -1,-8,$0809 : db $00
	dw 4,16,$0818 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":20308..20916

SpriteFrame_fallfwd_31:
	db $05,$80
	dw $000E
	dw -23,11,-16,15
	dw $0100,$00C0
	dw .tiles-SpriteFrame_fallfwd_31
	db $EB,$F4,$02,$08
	dw -23,-16,$0800 : db $FF
	dw -7,-16,$0802 : db $FF
	dw -12,0,$0804 : db $FF
	dw 4,0,$0806 : db $00
	dw 4,8,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":20973..21421
SpriteFrame_duck_0:
	db $07,$80
	dw $000A
	dw -10,13,-25,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_duck_0
	db $0D,$FA,$05,$0D
	dw -10,-9,$0800 : db $FF
	dw -7,-17,$0802 : db $00
	dw 1,-17,$0803 : db $00
	dw 10,-25,$0812 : db $00
	dw 10,-17,$0813 : db $00
	dw 6,-9,$0804 : db $00
	dw 6,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":21492..21812
SpriteFrame_duck_1:
	db $05,$80
	dw $000E
	dw -9,19,-26,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_duck_1
	db $12,$FE,$04,$0A
	dw -9,-21,$0800 : db $FF
	dw -9,-5,$0802 : db $FF
	dw 7,-26,$0804 : db $FF
	dw 7,-10,$0806 : db $00
	dw 7,-2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":21869..22317
SpriteFrame_duck_2:
	db $05,$80
	dw $000E
	dw -12,15,-23,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_duck_2
	db $0E,$06,$05,$07
	dw -9,-23,$0800 : db $FF
	dw 7,-23,$0802 : db $FF
	dw -12,-7,$0804 : db $FF
	dw 4,-7,$0806 : db $00
	dw 4,1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":22374..22822
SpriteFrame_duck_3:
	db $05,$80
	dw $000E
	dw -11,14,-24,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_duck_3
	db $0E,$06,$03,$07
	dw -11,-24,$0800 : db $FF
	dw 5,-24,$0802 : db $FF
	dw -10,-8,$0804 : db $FF
	dw 6,-8,$0806 : db $00
	dw 6,0,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":22879..23327
SpriteFrame_duck_4:
	db $07,$80
	dw $000D
	dw -15,11,-32,2
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_duck_4
	db $F2,$04,$05,$07
	dw -11,-13,$0800 : db $FF
	dw -15,-29,$0802 : db $FF
	dw 5,-13,$0804 : db $00
	dw 5,-5,$0805 : db $00
	dw 1,-29,$0814 : db $00
	dw 1,-21,$0815 : db $00
	dw -14,-37,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":23398..23814
SpriteFrame_duck_5:
	db $05,$80
	dw $000E
	dw -21,10,-27,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_duck_5
	db $ED,$FF,$07,$06
	dw -21,-27,$0800 : db $FF
	dw -5,-27,$0802 : db $FF
	dw -10,-11,$0804 : db $FF
	dw 6,-11,$0806 : db $00
	dw 6,-3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":23871..24319
SpriteFrame_duck_6:
	db $03,$80
	dw $000C
	dw -18,10,-27,2
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_duck_6
	db $EE,$FE,$07,$07
	dw -18,-27,$0800 : db $FF
	dw -2,-27,$0802 : db $FF
	dw -5,-11,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":24362..24746

SpriteFrame_duck_7:
	db $05,$80
	dw $000B
	dw -9,10,-27,8
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_duck_7
	db $FC,$F4,$08,$0B
	dw -5,-27,$0800 : db $FF
	dw -9,-11,$0802 : db $FF
	dw 7,-11,$0804 : db $00
	dw 7,-3,$0805 : db $00
	dw -5,5,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":24803..25155
SpriteFrame_hold_0:
	db $05,$80
	dw $000B
	dw -7,12,-27,5
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_hold_0
	db $0E,$02,$05,$0A
	dw -6,-27,$0800 : db $FF
	dw -7,-11,$0802 : db $FF
	dw 9,-11,$0804 : db $00
	dw 9,-3,$0805 : db $00
	dw -1,5,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":25212..25564
SpriteFrame_hold_1:
	db $04,$80
	dw $000D
	dw -7,18,-27,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_hold_1
	db $12,$01,$04,$08
	dw -3,-27,$0800 : db $FF
	dw -7,-11,$0802 : db $FF
	dw 9,-11,$0804 : db $FF
	dw 3,5,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":25614..26030
SpriteFrame_hold_2:
	db $06,$80
	dw $000C
	dw -10,11,-26,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_hold_2
	db $13,$02,$00,$07
	dw -9,-26,$0800 : db $FF
	dw -10,-10,$0802 : db $FF
	dw 7,-26,$0804 : db $00
	dw 7,-18,$0805 : db $00
	dw 6,-10,$0814 : db $00
	dw 6,-2,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":26094..26478
SpriteFrame_hold_3:
	db $03,$80
	dw $0009
	dw -9,10,-27,4
	dw $00A0,$0080
	dw .tiles-SpriteFrame_hold_3
	db $0B,$0B,$03,$07
	dw -9,-27,$0800 : db $FF
	dw -9,-11,$0802 : db $FF
	dw 7,-19,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":26521..26809
SpriteFrame_hold_4:
	db $05,$80
	dw $000B
	dw -9,9,-25,2
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_hold_4
	db $F5,$04,$05,$07
	dw -9,-25,$0800 : db $FF
	dw -9,-9,$0802 : db $FF
	dw 7,-25,$0804 : db $00
	dw 7,-17,$0805 : db $00
	dw 7,-1,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":26866..27218
SpriteFrame_hold_5:
	db $04,$80
	dw $000A
	dw -7,9,-28,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_hold_5
	db $F2,$FE,$06,$01
	dw -5,-28,$0800 : db $FF
	dw -7,-12,$0802 : db $FF
	dw 9,-4,$0804 : db $00
	dw -2,4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":27268..27588
SpriteFrame_hold_6:
	db $06,$80
	dw $000C
	dw -11,12,-27,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_hold_6
	db $F3,$FB,$09,$05
	dw -11,-27,$0800 : db $FF
	dw -10,-11,$0802 : db $FF
	dw 5,-27,$0804 : db $00
	dw 5,-19,$0805 : db $00
	dw 6,-11,$0814 : db $00
	dw 6,-3,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":27652..28036
SpriteFrame_hold_7:
	db $05,$80
	dw $000E
	dw -12,14,-25,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_hold_7
	db $F6,$F9,$07,$09
	dw -12,-25,$0800 : db $FF
	dw 4,-25,$0802 : db $FF
	dw -10,-9,$0804 : db $FF
	dw 6,-9,$0806 : db $00
	dw 6,-1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":28093..28541
SpriteFrame_Pen_0:
	db $07,$80
	dw $000D
	dw -18,2,-32,2
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Pen_0
	db $00,$00,$1D,$00
	dw -16,-32,$0800 : db $FF
	dw -18,-16,$0802 : db $FF
	dw 0,-24,$0804 : db $00
	dw -2,-16,$0805 : db $00
	dw -2,-8,$0814 : db $00
	dw -16,0,$0815 : db $00
	dw -8,0,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":28612..29028

SpriteFrame_Pen_1:
	db $03,$80
	dw $000C
	dw -15,9,-37,-6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Pen_1
	db $00,$00,$00,$00
	dw -15,-37,$0800 : db $FF
	dw -15,-21,$0802 : db $FF
	dw 1,-26,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":29071..29455
SpriteFrame_Pen_2:
	db $04,$80
	dw $000A
	dw -12,12,-29,-6
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Pen_2
	db $0C,$00,$1D,$00
	dw -12,-29,$0800 : db $FF
	dw 4,-29,$0802 : db $FF
	dw -3,-13,$0804 : db $00
	dw 5,-13,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":29505..29825
SpriteFrame_Pen_3:
	db $04,$80
	dw $000A
	dw -2,19,-26,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Pen_3
	db $02,$00,$1A,$00
	dw -2,-26,$0800 : db $FF
	dw 0,-10,$0802 : db $FF
	dw 14,-26,$0804 : db $00
	dw 14,-18,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":29875..30195
SpriteFrame_Pen_4:
	db $03,$80
	dw $000C
	dw -27,4,-25,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Pen_4
	db $1B,$00,$19,$00
	dw -27,-25,$0800 : db $FF
	dw -11,-25,$0802 : db $FF
	dw -8,-9,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":30238..30622
SpriteFrame_Pen_5:
	db $05,$80
	dw $000B
	dw -20,6,-28,-7
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Pen_5
	db $14,$00,$1C,$00
	dw -20,-28,$0800 : db $FF
	dw -4,-28,$0802 : db $FF
	dw -17,-12,$0804 : db $00
	dw -9,-12,$0805 : db $00
	dw -1,-12,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":30679..31031
SpriteFrame_Pen_6:
	db $04,$80
	dw $0007
	dw -15,5,-27,-8
	dw $0080,$0060
	dw .tiles-SpriteFrame_Pen_6
	db $12,$00,$1D,$00
	dw -15,-27,$0800 : db $FF
	dw 1,-27,$0802 : db $00
	dw 1,-19,$0803 : db $00
	dw 0,-11,$0812 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":31081..31305
SpriteFrame_Pen_7:
	db $04,$80
	dw $0007
	dw -9,7,-25,-9
	dw $0080,$0060
	dw .tiles-SpriteFrame_Pen_7
	db $F2,$04,$F2,$04
	dw -9,-25,$0800 : db $FF
	dw 7,-17,$0802 : db $00
	dw -6,-9,$0803 : db $00
	dw 2,-9,$0812 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":31355..31579
SpriteFrame_Pen_8:
	db $02,$80
	dw $0008
	dw 8,23,-25,-1
	dw $0080,$0080
	dw .tiles-SpriteFrame_Pen_8
	db $E4,$DE,$E4,$DE
	dw 12,-25,$0800 : db $FF
	dw 8,-9,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":31615..31871
SpriteFrame_gwall_0:
	db $05,$80
	dw $000E
	dw -19,6,-32,0
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gwall_0
	db $00,$00,$1D,$00
	dw -17,-32,$0800 : db $FF
	dw -19,-16,$0802 : db $FF
	dw -3,-16,$0804 : db $FF
	dw -1,-24,$0806 : db $00
	dw -11,0,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames86.bin":31928..32376
