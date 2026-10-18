; More frames of SpriteFrames (format at SpriteFrames82). Frame labels are SpriteFrame_<group>_<n>.

SpriteFrame_Goalie_8:
	db $05,$80
	dw $000B
	dw -9,11,-21,7
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_8
	db $05,$F6,$09,$EE
	dw -9,-21,$0800 : db $FF
	dw -9,-5,$0802 : db $FF
	dw 7,-21,$0804 : db $00
	dw 7,-13,$0805 : db $00
	dw 7,-5,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":57..409
SpriteFrame_Goalie_9:
	db $06,$80
	dw $000C
	dw -12,11,-23,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_9
	db $09,$03,$09,$03
	dw -12,-23,$0800 : db $FF
	dw -10,-7,$0802 : db $FF
	dw 4,-23,$0804 : db $00
	dw 4,-15,$0805 : db $00
	dw 6,-7,$0814 : db $00
	dw 6,1,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":473..857
SpriteFrame_Goalie_10:
	db $04,$80
	dw $000D
	dw -18,9,-17,7
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_10
	db $F8,$07,$F2,$F8
	dw -18,-17,$0800 : db $FF
	dw -2,-17,$0802 : db $FF
	dw -9,-1,$0804 : db $FF
	dw 7,-1,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":907..1323
SpriteFrame_Goalie_11:
	db $04,$80
	dw $0010
	dw -11,18,-19,6
	dw $0100,$0100
	dw .tiles-SpriteFrame_Goalie_11
	db $0D,$02,$11,$F1
	dw -10,-19,$0800 : db $FF
	dw 6,-19,$0802 : db $FF
	dw -11,-3,$0804 : db $FF
	dw 5,-3,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":1373..1885
SpriteFrame_Goalie_12:
	db $04,$80
	dw $000D
	dw -15,15,-20,7
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_12
	db $02,$06,$02,$06
	dw -15,-20,$0800 : db $FF
	dw 1,-20,$0802 : db $FF
	dw -9,-4,$0804 : db $FF
	dw 7,-4,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":1935..2351
SpriteFrame_Goalie_13:
	db $06,$80
	dw $000C
	dw -16,11,-22,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_13
	db $F8,$03,$F2,$F3
	dw -16,-22,$0800 : db $FF
	dw -8,-6,$0802 : db $FF
	dw 0,-22,$0804 : db $00
	dw 0,-14,$0805 : db $00
	dw 8,-6,$0814 : db $00
	dw 8,2,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":2415..2799
SpriteFrame_Goalie_14:
	db $04,$80
	dw $0010
	dw -14,18,-18,8
	dw $0100,$0100
	dw .tiles-SpriteFrame_Goalie_14
	db $0C,$04,$11,$F8
	dw -14,-18,$0800 : db $FF
	dw 2,-18,$0802 : db $FF
	dw -8,-2,$0804 : db $FF
	dw 8,-2,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":2849..3361
SpriteFrame_Goalie_15:
	db $06,$80
	dw $000C
	dw -16,8,-20,9
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_15
	db $FB,$07,$FB,$06
	dw -16,-20,$0800 : db $FF
	dw -10,-4,$0802 : db $FF
	dw 0,-20,$0804 : db $00
	dw 0,-12,$0805 : db $00
	dw 6,-4,$0814 : db $00
	dw 6,4,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":3425..3809
SpriteFrame_Goalie_16:
	db $05,$80
	dw $000B
	dw -11,11,-23,9
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_16
	db $FA,$FD,$F6,$F2
	dw -11,-23,$0800 : db $FF
	dw -11,-7,$0802 : db $FF
	dw 5,-11,$0804 : db $00
	dw 5,-3,$0805 : db $00
	dw 5,5,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":3866..4218

SpriteFrame_Goalie_17:
	db $06,$80
	dw $000C
	dw -14,9,-20,13
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_17
	db $02,$0A,$06,$FF
	dw -6,-16,$0800 : db $FF
	dw -6,0,$0802 : db $FF
	dw -14,-20,$0804 : db $00
	dw -14,-12,$0805 : db $00
	dw -14,-4,$0814 : db $00
	dw -14,4,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":4282..4666
SpriteFrame_Goalie_18:
	db $02,$80
	dw $0008
	dw -9,6,-27,4
	dw $0080,$0080
	dw .tiles-SpriteFrame_Goalie_18
	db $F7,$01,$F7,$01
	dw -9,-27,$0800 : db $FF
	dw -8,-11,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":4702..4958
SpriteFrame_Goalie_19:
	db $04,$80
	dw $000A
	dw -9,5,-28,8
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_19
	db $FD,$F7,$00,$EC
	dw -9,-28,$0800 : db $FF
	dw -9,-12,$0802 : db $FF
	dw -7,4,$0804 : db $00
	dw 1,4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":5008..5328
SpriteFrame_Goalie_20:
	db $05,$80
	dw $000E
	dw -16,8,-22,13
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_20
	db $F5,$0B,$F0,$FD
	dw -16,-22,$0800 : db $FF
	dw -16,-6,$0802 : db $FF
	dw 0,-10,$0804 : db $FF
	dw -16,10,$0806 : db $00
	dw -8,10,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":5385..5833
SpriteFrame_Goalie_21:
	db $06,$80
	dw $000C
	dw -12,8,-25,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_21
	db $F7,$FD,$F7,$FD
	dw -12,-25,$0800 : db $FF
	dw -12,-9,$0802 : db $FF
	dw 4,-25,$0804 : db $00
	dw 4,-17,$0805 : db $00
	dw 4,-9,$0814 : db $00
	dw 4,-1,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":5897..6281
SpriteFrame_Goalie_22:
	db $05,$80
	dw $000B
	dw -14,9,-24,6
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_22
	db $F6,$07,$F2,$F8
	dw -14,-24,$0800 : db $FF
	dw -13,-8,$0802 : db $FF
	dw 2,-24,$0804 : db $00
	dw 2,-16,$0805 : db $00
	dw 3,-8,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":6338..6690
SpriteFrame_Goalie_23:
	db $03,$80
	dw $000C
	dw -17,7,-17,8
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_23
	db $F2,$07,$EE,$F6
	dw -17,-17,$0800 : db $FF
	dw -17,-1,$0802 : db $FF
	dw -1,-15,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":6733..7117
SpriteFrame_Goalie_24:
	db $03,$80
	dw $0009
	dw -7,11,-26,5
	dw $00A0,$0080
	dw .tiles-SpriteFrame_Goalie_24
	db $FE,$FA,$FE,$FA
	dw -5,-26,$0800 : db $FF
	dw -7,-10,$0802 : db $FF
	dw 9,-2,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":7160..7448
SpriteFrame_Goalie_25:
	db $04,$80
	dw $000A
	dw -7,11,-35,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_25
	db $08,$F3,$08,$F3
	dw -7,-11,$0800 : db $FF
	dw -4,-27,$0802 : db $FF
	dw 9,-3,$0804 : db $00
	dw 8,-35,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":7498..7818
SpriteFrame_Goalie_26:
	db $03,$80
	dw $000C
	dw -10,14,-27,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_26
	db $0B,$F8,$0B,$F8
	dw -10,-27,$0800 : db $FF
	dw -10,-11,$0802 : db $FF
	dw 6,-12,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":7861..8245

SpriteFrame_Goalie_27:
	db $05,$80
	dw $0011
	dw -9,25,-27,4
	dw $0120,$0100
	dw .tiles-SpriteFrame_Goalie_27
	db $17,$FC,$17,$FC
	dw -9,-27,$0800 : db $FF
	dw 15,-27,$0802 : db $FF
	dw -9,-11,$0804 : db $FF
	dw 8,-11,$0806 : db $FF
	dw 7,-19,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":8302..8846
SpriteFrame_Goalie_28:
	db $05,$80
	dw $000E
	dw -11,22,-25,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_28
	db $13,$01,$13,$01
	dw -11,-25,$0800 : db $FF
	dw -10,-9,$0802 : db $FF
	dw 6,-9,$0804 : db $FF
	dw 22,-9,$0806 : db $00
	dw 22,-1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":8903..9351
SpriteFrame_Goalie_29:
	db $03,$80
	dw $000C
	dw -9,21,-24,8
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_29
	db $13,$07,$13,$07
	dw -9,-24,$0800 : db $FF
	dw -9,-8,$0802 : db $FF
	dw 7,-7,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":9394..9778
SpriteFrame_Goalie_30:
	db $03,$80
	dw $000C
	dw -11,18,-27,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_30
	db $0E,$03,$0E,$03
	dw -11,-27,$0800 : db $FF
	dw -10,-11,$0802 : db $FF
	dw 6,-11,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":9821..10205
SpriteFrame_Goalie_31:
	db $04,$80
	dw $000A
	dw -8,7,-26,14
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_31
	db $FF,$0B,$FF,$0C
	dw -8,-26,$0800 : db $FF
	dw -8,-10,$0802 : db $FF
	dw -5,6,$0804 : db $00
	dw -5,14,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":10255..10575
SpriteFrame_Goalie_32:
	db $06,$80
	dw $000F
	dw -11,9,-26,13
	dw $0100,$00E0
	dw .tiles-SpriteFrame_Goalie_32
	db $03,$0B,$03,$0B
	dw -11,-26,$0800 : db $FF
	dw -9,-10,$0802 : db $FF
	dw -1,-2,$0804 : db $FF
	dw 5,-26,$0806 : db $00
	dw 5,-18,$0807 : db $00
	dw 7,-10,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":10639..11119
SpriteFrame_Goalie_33:
	db $07,$80
	dw $0010
	dw -20,11,-28,9
	dw $0100,$0100
	dw .tiles-SpriteFrame_Goalie_33
	db $EF,$08,$EF,$08
	dw -20,-6,$0800 : db $FF
	dw -4,-6,$0802 : db $FF
	dw -9,-22,$0804 : db $FF
	dw 7,-22,$0806 : db $00
	dw 7,-14,$0807 : db $00
	dw -5,-30,$0816 : db $00
	dw 3,-30,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":11190..11702
SpriteFrame_Goalie_34:
	db $05,$80
	dw $000B
	dw -16,9,-22,13
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_34
	db $F0,$0A,$F0,$0A
	dw -6,-22,$0800 : db $FF
	dw -13,-6,$0802 : db $FF
	dw 3,-6,$0804 : db $00
	dw 3,2,$0805 : db $00
	dw -16,10,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":11759..12111
SpriteFrame_Goalie_35:
	db $06,$80
	dw $000F
	dw -25,8,-25,5
	dw $0100,$00E0
	dw .tiles-SpriteFrame_Goalie_35
	db $EB,$05,$EB,$05
	dw -15,-25,$0800 : db $FF
	dw -25,-9,$0802 : db $FF
	dw -8,-9,$0804 : db $FF
	dw 1,-25,$0806 : db $00
	dw 1,-17,$0807 : db $00
	dw 8,-1,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":12175..12655

SpriteFrame_Goalie_36:
	db $04,$80
	dw $000D
	dw -21,9,-23,7
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_36
	db $ED,$01,$ED,$01
	dw -9,-23,$0800 : db $FF
	dw -21,-7,$0802 : db $FF
	dw -5,-7,$0804 : db $FF
	dw 7,-15,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":12705..13121
SpriteFrame_Goalie_37:
	db $04,$80
	dw $000D
	dw -33,6,-24,6
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_37
	db $E1,$FD,$E1,$FD
	dw -9,-24,$0800 : db $FF
	dw -9,-8,$0802 : db $FF
	dw -25,-19,$0804 : db $FF
	dw -33,-21,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":13171..13587
SpriteFrame_Goalie_38:
	db $03,$80
	dw $000C
	dw -15,10,-24,6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_38
	db $F5,$FB,$F5,$FB
	dw -7,-24,$0800 : db $FF
	dw -15,-8,$0802 : db $FF
	dw 1,-8,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":13630..14014
SpriteFrame_Goalie_39:
	db $06,$80
	dw $000C
	dw -15,10,-34,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_39
	db $F1,$EF,$F1,$EF
	dw -7,-10,$0800 : db $FF
	dw -15,-26,$0802 : db $FF
	dw 9,-2,$0804 : db $00
	dw 1,-26,$0805 : db $00
	dw 1,-18,$0814 : db $00
	dw -14,-34,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":14078..14462
SpriteFrame_Goalie_40:
	db $06,$80
	dw $000C
	dw -9,18,-25,1
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_40
	db $0B,$FF,$0F,$F1
	dw -8,-25,$0800 : db $FF
	dw -9,-9,$0802 : db $FF
	dw 8,-17,$0804 : db $00
	dw 16,-17,$0805 : db $00
	dw 7,-9,$0814 : db $00
	dw 7,-1,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":14526..14910
SpriteFrame_Goalie_41:
	db $06,$80
	dw $000C
	dw -9,21,-20,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_41
	db $0F,$FE,$15,$FA
	dw -9,-20,$0800 : db $FF
	dw 7,-20,$0802 : db $FF
	dw -9,-4,$0804 : db $00
	dw -1,-4,$0805 : db $00
	dw 7,-4,$0814 : db $00
	dw 15,-4,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":14974..15358
SpriteFrame_Goalie_42:
	db $03,$80
	dw $000C
	dw -8,18,-22,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_42
	db $0A,$02,$0D,$F8
	dw -8,-22,$0800 : db $FF
	dw -8,-6,$0802 : db $FF
	dw 8,-13,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":15401..15785
SpriteFrame_Goalie_43:
	db $07,$80
	dw $000D
	dw -6,26,-14,9
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_43
	db $0E,$04,$16,$03
	dw -6,-14,$0800 : db $FF
	dw 10,-14,$0802 : db $FF
	dw 26,-6,$0804 : db $00
	dw -6,2,$0805 : db $00
	dw 2,2,$0814 : db $00
	dw 10,2,$0815 : db $00
	dw 18,2,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":15856..16272
SpriteFrame_Goalie_44:
	db $05,$80
	dw $000B
	dw -16,11,-18,5
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_44
	db $F8,$03,$F3,$01
	dw -16,-18,$0800 : db $FF
	dw 0,-18,$0802 : db $FF
	dw -15,-2,$0804 : db $00
	dw -7,-2,$0805 : db $00
	dw 1,-2,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":16329..16681

SpriteFrame_Goalie_45:
	db $05,$80
	dw $000E
	dw -15,16,-13,16
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_45
	db $FA,$0A,$03,$09
	dw -13,-13,$0800 : db $FF
	dw 3,-13,$0802 : db $FF
	dw -15,3,$0804 : db $FF
	dw 1,3,$0806 : db $00
	dw 9,3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":16738..17186
SpriteFrame_Goalie_46:
	db $05,$80
	dw $000E
	dw -16,13,-19,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_46
	db $F9,$03,$F4,$FA
	dw -16,-19,$0800 : db $FF
	dw 0,-19,$0802 : db $FF
	dw -12,-3,$0804 : db $FF
	dw 4,-3,$0806 : db $00
	dw 4,5,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":17243..17691
SpriteFrame_Goalie_47:
	db $05,$80
	dw $000B
	dw -24,12,-12,11
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_47
	db $F1,$02,$E9,$01
	dw -3,-12,$0800 : db $FF
	dw -19,-10,$0802 : db $FF
	dw 5,4,$0804 : db $00
	dw -27,-8,$0805 : db $00
	dw -27,0,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":17748..18100
SpriteFrame_Goalie_48:
	db $04,$80
	dw $000D
	dw -17,7,-21,8
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_48
	db $F3,$00,$F0,$F6
	dw -17,-21,$0800 : db $FF
	dw -1,-21,$0802 : db $FF
	dw -11,-5,$0804 : db $FF
	dw 5,-5,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":18150..18566
SpriteFrame_Goalie_49:
	db $04,$80
	dw $000D
	dw -26,8,-20,8
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_49
	db $F3,$F9,$EC,$F7
	dw -7,-16,$0800 : db $FF
	dw -7,0,$0802 : db $FF
	dw -23,-17,$0804 : db $FF
	dw -31,-20,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":18616..19032
SpriteFrame_Goalie_50:
	db $04,$80
	dw $000A
	dw -9,11,-25,2
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_50
	db $F9,$00,$F6,$F1
	dw -9,-25,$0800 : db $FF
	dw -7,-9,$0802 : db $FF
	dw 7,-25,$0804 : db $00
	dw 7,-17,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":19082..19402
SpriteFrame_Goalie_51:
	db $03,$80
	dw $000C
	dw -11,20,-25,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_51
	db $0C,$F9,$14,$F7
	dw 4,-25,$0800 : db $FF
	dw -11,-9,$0802 : db $FF
	dw 5,-9,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":19445..19829
SpriteFrame_Goalie_52:
	db $04,$80
	dw $000A
	dw -6,17,-23,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_52
	db $FF,$00,$FA,$FC
	dw -6,-23,$0800 : db $FF
	dw -6,-7,$0802 : db $FF
	dw 10,-17,$0804 : db $00
	dw 10,-9,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":19879..20199
SpriteFrame_Goalie_53:
	db $05,$80
	dw $000E
	dw -23,14,-19,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_53
	db $F1,$FF,$EA,$FC
	dw -23,-9,$0800 : db $FF
	dw -7,-9,$0802 : db $FF
	dw -10,-25,$0804 : db $FF
	dw 9,-9,$0806 : db $00
	dw 9,-1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":20256..20704

SpriteFrame_Goalie_54:
	db $04,$80
	dw $000A
	dw -5,13,-22,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_54
	db $FE,$FF,$FB,$FC
	dw -5,-12,$0800 : db $FF
	dw -3,-28,$0802 : db $FF
	dw 11,-12,$0804 : db $00
	dw 11,-4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":20754..21074
SpriteFrame_Goalie_55:
	db $04,$80
	dw $000D
	dw -16,15,-16,10
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_55
	db $F6,$F8,$EF,$F6
	dw -16,-16,$0800 : db $FF
	dw 0,-16,$0802 : db $FF
	dw 0,0,$0804 : db $FF
	dw -8,0,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":21124..21540
SpriteFrame_Goalie_56:
	db $03,$80
	dw $000C
	dw -17,12,-18,8
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_56
	db $07,$00,$0B,$FE
	dw -17,-7,$0800 : db $FF
	dw -1,-7,$0802 : db $FF
	dw -8,-23,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":21583..21967
SpriteFrame_Goalie_57:
	db $08,$80
	dw $000E
	dw -15,20,-14,7
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_57
	db $0C,$FA,$13,$F8
	dw -15,-8,$0800 : db $FF
	dw 1,-8,$0802 : db $FF
	dw 17,-8,$0804 : db $00
	dw 17,0,$0805 : db $00
	dw -6,-16,$0814 : db $00
	dw 2,-16,$0815 : db $00
	dw 10,-16,$0806 : db $00
	dw 18,-16,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":22045..22493
SpriteFrame_Goalie_58:
	db $04,$80
	dw $0010
	dw -20,12,-22,7
	dw $0100,$0100
	dw .tiles-SpriteFrame_Goalie_58
	db $09,$00,$0B,$FA
	dw -20,-22,$0800 : db $FF
	dw -4,-22,$0802 : db $FF
	dw -16,-6,$0804 : db $FF
	dw 0,-6,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":22543..23055
SpriteFrame_Goalie_59:
	db $05,$80
	dw $0011
	dw -20,24,-12,15
	dw $0120,$0100
	dw .tiles-SpriteFrame_Goalie_59
	db $10,$00,$18,$FE
	dw -20,-12,$0800 : db $FF
	dw -4,-12,$0802 : db $FF
	dw 12,-12,$0804 : db $FF
	dw -14,4,$0806 : db $FF
	dw 2,4,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":23112..23656
SpriteFrame_Goalie_60:
	db $04,$80
	dw $000D
	dw -14,11,-17,8
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_60
	db $05,$09,$07,$07
	dw -14,-17,$0800 : db $FF
	dw 2,-17,$0802 : db $FF
	dw -7,-1,$0804 : db $FF
	dw 9,-1,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":23706..24122
SpriteFrame_Goalie_61:
	db $05,$80
	dw $000E
	dw -18,17,-13,15
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_61
	db $08,$08,$11,$06
	dw -18,-13,$0800 : db $FF
	dw -2,-13,$0802 : db $FF
	dw 1,3,$0804 : db $FF
	dw -18,3,$0806 : db $00
	dw 17,3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":24179..24627

SpriteFrame_Goalie_62:
	db $04,$80
	dw $000D
	dw -14,11,-20,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_62
	db $F8,$03,$F4,$00
	dw -14,-20,$0800 : db $FF
	dw 2,-20,$0802 : db $FF
	dw -12,-4,$0804 : db $FF
	dw 4,-4,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":24677..25093
SpriteFrame_Goalie_63:
	db $07,$80
	dw $000D
	dw -21,19,-11,12
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_Goalie_63
	db $F5,$07,$EC,$06
	dw -19,-11,$0800 : db $FF
	dw -3,-11,$0802 : db $FF
	dw 13,-3,$0804 : db $00
	dw -21,5,$0805 : db $00
	dw -13,5,$0814 : db $00
	dw -5,5,$0815 : db $00
	dw 3,5,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":25164..25580
SpriteFrame_Goalie_64:
	db $04,$80
	dw $000A
	dw -8,15,-24,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_Goalie_64
	db $0C,$F8,$0E,$F3
	dw -8,-24,$0800 : db $FF
	dw -8,-8,$0802 : db $FF
	dw 8,-17,$0804 : db $00
	dw 8,-9,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":25630..25950
SpriteFrame_Goalie_65:
	db $06,$80
	dw $000C
	dw -17,12,-21,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_65
	db $F4,$02,$EF,$FE
	dw -15,-21,$0800 : db $FF
	dw -17,-5,$0802 : db $FF
	dw 1,-21,$0804 : db $00
	dw 1,-13,$0805 : db $00
	dw -1,-5,$0814 : db $00
	dw 7,-5,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":26014..26398
SpriteFrame_Goalie_66:
	db $03,$80
	dw $000C
	dw -9,20,-23,4
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_66
	db $0E,$01,$13,$FC
	dw -9,-11,$0800 : db $FF
	dw 7,-11,$0802 : db $FF
	dw -6,-27,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":26441..26825
SpriteFrame_Goalie_67:
	db $06,$80
	dw $000C
	dw -15,18,-20,7
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_67
	db $F6,$FE,$F2,$F8
	dw 1,-8,$0800 : db $FF
	dw -11,-24,$0802 : db $FF
	dw -15,-8,$0804 : db $00
	dw -7,-8,$0805 : db $00
	dw 5,-16,$0814 : db $00
	dw 13,-16,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":26889..27273
SpriteFrame_Goalie_68:
	db $05,$80
	dw $000E
	dw -15,24,-19,8
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_68
	db $0A,$08,$10,$03
	dw -15,-7,$0800 : db $FF
	dw 1,-7,$0802 : db $FF
	dw -5,-23,$0804 : db $FF
	dw 17,-7,$0806 : db $00
	dw 17,1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":27330..27778
SpriteFrame_Goalie_69:
	db $03,$80
	dw $000C
	dw -7,20,-20,8
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_69
	db $FE,$F8,$FA,$F3
	dw -7,-20,$0800 : db $FF
	dw -7,-4,$0802 : db $FF
	dw 9,-12,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":27821..28205
SpriteFrame_Goalie_70:
	db $05,$80
	dw $000B
	dw -10,13,-18,13
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_Goalie_70
	db $FE,$0A,$03,$07
	dw -10,-18,$0800 : db $FF
	dw -6,-2,$0802 : db $FF
	dw 6,-18,$0804 : db $00
	dw 6,-10,$0805 : db $00
	dw 10,6,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":28262..28614
SpriteFrame_Goalie_71:
	db $05,$80
	dw $000E
	dw -11,17,-20,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_71
	db $08,$FE,$0D,$FA
	dw -5,-20,$0800 : db $FF
	dw -11,-4,$0802 : db $FF
	dw 5,-4,$0804 : db $FF
	dw 11,-20,$0806 : db $00
	dw 11,-12,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":28671..29119

SpriteFrame_Goalie_72:
	db $05,$80
	dw $000E
	dw -16,8,-23,8
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_72
	db $F8,$02,$F0,$FD
	dw -15,-23,$0800 : db $FF
	dw -16,-7,$0802 : db $FF
	dw 0,-7,$0804 : db $FF
	dw 1,-23,$0806 : db $00
	dw 1,-15,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":29176..29624
SpriteFrame_Goalie_73:
	db $03,$80
	dw $000C
	dw -12,18,-20,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_Goalie_73
	db $0C,$00,$11,$FB
	dw -12,-10,$0800 : db $FF
	dw 4,-10,$0802 : db $FF
	dw -7,-26,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":29667..30051
SpriteFrame_Goalie_74:
	db $05,$80
	dw $000E
	dw -18,16,-21,9
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_74
	db $F5,$01,$EF,$FB
	dw -16,-21,$0800 : db $FF
	dw -18,-5,$0802 : db $FF
	dw -2,-5,$0804 : db $FF
	dw 0,-13,$0806 : db $00
	dw 14,-5,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":30108..30556
SpriteFrame_Goalie_75:
	db $04,$80
	dw $0010
	dw -16,17,-19,7
	dw $0100,$0100
	dw .tiles-SpriteFrame_Goalie_75
	db $0C,$02,$11,$00
	dw -16,-19,$0800 : db $FF
	dw 0,-19,$0802 : db $FF
	dw -11,-3,$0804 : db $FF
	dw 5,-3,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":30606..31118
SpriteFrame_Goalie_76:
	db $07,$80
	dw $0010
	dw -20,13,-21,7
	dw $0100,$0100
	dw .tiles-SpriteFrame_Goalie_76
	db $FB,$FD,$F6,$F9
	dw -14,-21,$0800 : db $FF
	dw -20,-5,$0802 : db $FF
	dw -4,-5,$0804 : db $FF
	dw 2,-21,$0806 : db $00
	dw 2,-13,$0807 : db $00
	dw 12,-5,$0816 : db $00
	dw 12,3,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":31189..31701
SpriteFrame_Goalie_77:
	db $05,$80
	dw $000E
	dw -15,10,-18,13
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_77
	db $05,$08,$00,$07
	dw -15,-18,$0800 : db $FF
	dw 1,-18,$0802 : db $FF
	dw -13,-2,$0804 : db $FF
	dw 3,-2,$0806 : db $00
	dw 3,6,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":31758..32206
SpriteFrame_Goalie_78:
	db $05,$80
	dw $000E
	dw -12,15,-23,8
	dw $0100,$00C0
	dw .tiles-SpriteFrame_Goalie_78
	db $03,$F6,$FF,$F4
	dw -12,-23,$0800 : db $FF
	dw 4,-23,$0802 : db $FF
	dw -12,-7,$0804 : db $FF
	dw 4,-7,$0806 : db $00
	dw 4,1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames89.bin":32263..32711
