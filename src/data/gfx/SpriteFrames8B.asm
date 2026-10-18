; More frames of SpriteFrames (format at SpriteFrames82). Frame labels are SpriteFrame_<group>_<n>.

SpriteFrame_gpoke_7:
	db $04,$80
	dw $000D
	dw -9,29,-20,9
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gpoke_7
	db $1A,$09,$1C,$07
	dw -5,-20,$0800 : db $FF
	dw -9,-4,$0802 : db $FF
	dw 7,-4,$0804 : db $FF
	dw 23,4,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":50..466
SpriteFrame_gpoke_8:
	db $05,$80
	dw $000E
	dw -11,15,-23,7
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gpoke_8
	db $04,$08,$06,$06
	dw -11,-23,$0800 : db $FF
	dw 5,-23,$0802 : db $FF
	dw -11,-7,$0804 : db $FF
	dw 5,-7,$0806 : db $00
	dw 5,1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":523..971
SpriteFrame_gpoke_9:
	db $06,$80
	dw $000F
	dw -9,13,-22,11
	dw $0100,$00E0
	dw .tiles-SpriteFrame_gpoke_9
	db $04,$0C,$06,$0A
	dw -7,-22,$0800 : db $FF
	dw -9,-6,$0802 : db $FF
	dw -1,2,$0804 : db $FF
	dw 9,-22,$0806 : db $00
	dw 9,-14,$0807 : db $00
	dw 7,-6,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":1035..1515
SpriteFrame_gpoke_10:
	db $04,$80
	dw $0010
	dw -20,11,-23,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_gpoke_10
	db $EE,$03,$F0,$01
	dw -18,-23,$0800 : db $FF
	dw -2,-23,$0802 : db $FF
	dw -20,-7,$0804 : db $FF
	dw -4,-7,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":1565..2077
SpriteFrame_gpoke_11:
	db $07,$80
	dw $0013
	dw -32,12,-22,11
	dw $0140,$0120
	dw .tiles-SpriteFrame_gpoke_11
	db $E3,$0B,$E5,$09
	dw -19,-22,$0800 : db $FF
	dw -3,-22,$0802 : db $FF
	dw -32,-6,$0804 : db $FF
	dw -16,-6,$0806 : db $FF
	dw 0,-6,$0808 : db $00
	dw 8,-6,$0809 : db $00
	dw -29,10,$0818 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":2148..2756
SpriteFrame_gpoke_12:
	db $04,$80
	dw $0007
	dw -18,6,-21,2
	dw $0080,$0060
	dw .tiles-SpriteFrame_gpoke_12
	db $EF,$01,$F1,$FF
	dw -9,-21,$0800 : db $FF
	dw -18,-5,$0802 : db $00
	dw -10,-5,$0803 : db $00
	dw -2,-5,$0812 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":2806..3030
SpriteFrame_gpoke_13:
	db $05,$80
	dw $000E
	dw -27,8,-21,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gpoke_13
	db $E6,$03,$E8,$01
	dw -27,-12,$0800 : db $FF
	dw -11,-12,$0802 : db $FF
	dw -8,-28,$0804 : db $FF
	dw 5,-12,$0806 : db $00
	dw 5,-4,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":3087..3535
SpriteFrame_gpoke_14:
	db $04,$80
	dw $000D
	dw -21,10,-25,2
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gpoke_14
	db $EE,$FE,$F0,$FC
	dw -9,-25,$0800 : db $FF
	dw -21,-9,$0802 : db $FF
	dw -5,-9,$0804 : db $FF
	dw 7,-17,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":3585..4001
SpriteFrame_gpoke_15:
	db $04,$80
	dw $0010
	dw -34,9,-23,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_gpoke_15
	db $E2,$FD,$E4,$FB
	dw -34,-12,$0800 : db $FF
	dw -18,-12,$0802 : db $FF
	dw -2,-12,$0804 : db $FF
	dw -8,-28,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":4051..4563

SpriteFrame_gcover_0:
	db $05,$80
	dw $000B
	dw -14,17,-23,0
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_gcover_0
	db $F4,$FD,$F1,$F3
	dw -14,-23,$0800 : db $FF
	dw 2,-23,$0802 : db $FF
	dw -9,-7,$0804 : db $00
	dw -1,-7,$0805 : db $00
	dw 7,-7,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":4620..4972
SpriteFrame_gcover_1:
	db $04,$80
	dw $000A
	dw -14,14,-20,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_1
	db $F4,$FE,$F2,$F7
	dw -14,-14,$0800 : db $FF
	dw 2,-14,$0802 : db $FF
	dw -7,-22,$0804 : db $00
	dw 1,-22,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":5022..5342
SpriteFrame_gcover_2:
	db $03,$80
	dw $0009
	dw -16,17,-11,1
	dw $00A0,$0080
	dw .tiles-SpriteFrame_gcover_2
	db $00,$FA,$00,$FA
	dw -16,-11,$0800 : db $FF
	dw 0,-11,$0802 : db $FF
	dw 16,-11,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":5385..5673
SpriteFrame_gcover_3:
	db $05,$80
	dw $000E
	dw -7,25,-23,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gcover_3
	db $10,$00,$12,$F7
	dw -3,-23,$0800 : db $FF
	dw -7,-7,$0802 : db $FF
	dw 9,-7,$0804 : db $FF
	dw 13,-15,$0806 : db $00
	dw 21,-15,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":5730..6178
SpriteFrame_gcover_4:
	db $04,$80
	dw $000A
	dw -10,25,-16,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_4
	db $11,$00,$14,$FC
	dw -10,-12,$0800 : db $FF
	dw 6,-12,$0802 : db $FF
	dw 22,-4,$0804 : db $00
	dw 5,-20,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":6228..6548
SpriteFrame_gcover_5:
	db $03,$80
	dw $0009
	dw -10,26,-9,3
	dw $00A0,$0080
	dw .tiles-SpriteFrame_gcover_5
	db $0B,$FE,$0C,$FD
	dw -10,-9,$0800 : db $FF
	dw 6,-9,$0802 : db $FF
	dw 22,-1,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":6591..6879
SpriteFrame_gcover_6:
	db $04,$80
	dw $000A
	dw -6,14,-24,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_6
	db $09,$03,$0B,$F9
	dw -3,-24,$0800 : db $FF
	dw -6,-8,$0802 : db $FF
	dw 10,-8,$0804 : db $00
	dw 10,0,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":6929..7249
SpriteFrame_gcover_7:
	db $04,$80
	dw $000A
	dw -8,19,-15,2
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_7
	db $0F,$03,$12,$FD
	dw -8,-13,$0800 : db $FF
	dw 8,-13,$0802 : db $FF
	dw 3,-21,$0804 : db $00
	dw 11,-21,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":7299..7619
SpriteFrame_gcover_8:
	db $04,$80
	dw $000A
	dw -11,24,-10,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_8
	db $11,$FE,$11,$FD
	dw -11,-10,$0800 : db $FF
	dw 5,-10,$0802 : db $FF
	dw 21,-10,$0804 : db $00
	dw 21,-2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":7669..7989
SpriteFrame_gcover_9:
	db $05,$80
	dw $000E
	dw -10,18,-22,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gcover_9
	db $0F,$04,$12,$01
	dw -9,-22,$0800 : db $FF
	dw -10,-6,$0802 : db $FF
	dw 6,-6,$0804 : db $FF
	dw 7,-22,$0806 : db $00
	dw 7,-14,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":8046..8494

SpriteFrame_gcover_10:
	db $05,$80
	dw $000B
	dw -12,24,-16,4
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_gcover_10
	db $15,$04,$18,$01
	dw -12,-11,$0800 : db $FF
	dw 4,-11,$0802 : db $FF
	dw 20,-3,$0804 : db $00
	dw 1,-19,$0805 : db $00
	dw 9,-19,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":8551..8903
SpriteFrame_gcover_11:
	db $04,$80
	dw $000D
	dw -16,30,-7,9
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gcover_11
	db $0C,$02,$0C,$01
	dw -16,-7,$0800 : db $FF
	dw 0,-7,$0802 : db $FF
	dw 16,-7,$0804 : db $FF
	dw 4,9,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":8953..9369
SpriteFrame_gcover_12:
	db $05,$80
	dw $000E
	dw -14,14,-21,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gcover_12
	db $0C,$00,$0E,$F7
	dw -14,-21,$0800 : db $FF
	dw 2,-21,$0802 : db $FF
	dw -9,-5,$0804 : db $FF
	dw 7,-5,$0806 : db $00
	dw 7,3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":9426..9874
SpriteFrame_gcover_13:
	db $04,$80
	dw $000A
	dw -14,15,-9,10
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_13
	db $0D,$0A,$0F,$07
	dw -14,-5,$0800 : db $FF
	dw 2,-5,$0802 : db $FF
	dw -6,-13,$0804 : db $00
	dw 2,-13,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":9924..10244
SpriteFrame_gcover_14:
	db $04,$80
	dw $000A
	dw -16,18,-9,7
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_14
	db $01,$04,$01,$04
	dw -16,-8,$0800 : db $FF
	dw 0,-8,$0802 : db $FF
	dw 16,0,$0804 : db $00
	dw -2,-16,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":10294..10614
SpriteFrame_gcover_15:
	db $04,$80
	dw $000D
	dw -19,10,-23,2
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gcover_15
	db $F2,$FC,$EF,$F4
	dw -19,-23,$0800 : db $FF
	dw -3,-23,$0802 : db $FF
	dw -13,-7,$0804 : db $FF
	dw 3,-7,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":10664..11080
SpriteFrame_gcover_16:
	db $06,$80
	dw $000C
	dw -21,11,-16,6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gcover_16
	db $F2,$04,$F0,$00
	dw -21,-16,$0800 : db $FF
	dw -5,-16,$0802 : db $FF
	dw -17,0,$0804 : db $00
	dw -9,0,$0805 : db $00
	dw -1,0,$0814 : db $00
	dw 7,0,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":11144..11528
SpriteFrame_gcover_17:
	db $05,$80
	dw $000B
	dw -26,11,-7,10
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_gcover_17
	db $F3,$05,$F3,$05
	dw -26,-7,$0800 : db $FF
	dw -10,-7,$0802 : db $FF
	dw 6,-7,$0804 : db $00
	dw 6,1,$0805 : db $00
	dw -13,9,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":11585..11937
SpriteFrame_gcover_18:
	db $04,$80
	dw $000A
	dw -13,7,-23,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_18
	db $F8,$03,$F5,$F8
	dw -11,-23,$0800 : db $FF
	dw -13,-7,$0802 : db $FF
	dw 3,-7,$0804 : db $00
	dw 3,1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":11987..12307

SpriteFrame_gcover_19:
	db $04,$80
	dw $000A
	dw -16,11,-15,2
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_19
	db $F3,$01,$F4,$FE
	dw -16,-13,$0800 : db $FF
	dw 0,-13,$0802 : db $FF
	dw -12,-21,$0804 : db $00
	dw -4,-21,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":12357..12677
SpriteFrame_gcover_20:
	db $04,$80
	dw $000A
	dw -32,7,-7,7
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_20
	db $EB,$00,$EB,$00
	dw -32,-7,$0800 : db $FF
	dw -16,-7,$0802 : db $FF
	dw 0,-7,$0804 : db $00
	dw 0,1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":12727..13047
SpriteFrame_gcover_21:
	db $04,$80
	dw $0010
	dw -21,9,-21,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_gcover_21
	db $F1,$03,$EE,$F5
	dw -21,-21,$0800 : db $FF
	dw -5,-21,$0802 : db $FF
	dw -21,-5,$0804 : db $FF
	dw -5,-5,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":13097..13609
SpriteFrame_gcover_22:
	db $04,$80
	dw $000A
	dw -24,10,-15,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gcover_22
	db $EB,$01,$E8,$FF
	dw -24,-12,$0800 : db $FF
	dw -8,-12,$0802 : db $FF
	dw 8,-4,$0804 : db $00
	dw -16,-20,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":13659..13979
SpriteFrame_gcover_23:
	db $03,$80
	dw $000C
	dw -30,11,-10,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gcover_23
	db $F3,$FF,$F3,$FF
	dw -30,-10,$0800 : db $FF
	dw -14,-10,$0802 : db $FF
	dw 2,-10,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":14022..14406
SpriteFrame_gbutterfly_0:
	db $04,$80
	dw $000A
	dw -10,12,-25,-1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gbutterfly_0
	db $00,$FE,$01,$F5
	dw -10,-16,$0800 : db $FF
	dw -8,-32,$0802 : db $FF
	dw 6,-16,$0804 : db $00
	dw 6,-8,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":14456..14776
SpriteFrame_gbutterfly_1:
	db $04,$80
	dw $000A
	dw -14,13,-21,-1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gbutterfly_1
	db $F3,$FF,$F1,$F7
	dw -14,-16,$0800 : db $FF
	dw 2,-16,$0802 : db $FF
	dw -6,-24,$0804 : db $00
	dw 2,-24,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":14826..15146
SpriteFrame_gbutterfly_2:
	db $02,$80
	dw $0008
	dw -17,12,-14,-1
	dw $0080,$0080
	dw .tiles-SpriteFrame_gbutterfly_2
	db $F0,$FE,$EF,$F8
	dw -17,-14,$0800 : db $FF
	dw -1,-14,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":15182..15438
SpriteFrame_gbutterfly_3:
	db $05,$80
	dw $000E
	dw -8,20,-26,1
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gbutterfly_3
	db $02,$00,$14,$F2
	dw -8,-26,$0800 : db $FF
	dw -7,-10,$0802 : db $FF
	dw 9,-10,$0804 : db $FF
	dw 8,-18,$0806 : db $00
	dw 16,-18,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":15495..15943
SpriteFrame_gbutterfly_4:
	db $03,$80
	dw $000C
	dw -8,20,-23,1
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gbutterfly_4
	db $14,$01,$15,$F6
	dw -8,-14,$0800 : db $FF
	dw 8,-14,$0802 : db $FF
	dw -8,-30,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":15986..16370
SpriteFrame_gbutterfly_5:
	db $02,$80
	dw $0008
	dw -6,18,-12,4
	dw $0080,$0080
	dw .tiles-SpriteFrame_gbutterfly_5
	db $10,$04,$12,$FF
	dw -6,-12,$0800 : db $FF
	dw 10,-5,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":16406..16662

SpriteFrame_gbutterfly_6:
	db $04,$80
	dw $000A
	dw -7,15,-25,0
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gbutterfly_6
	db $0E,$00,$10,$F7
	dw -5,-25,$0800 : db $FF
	dw -7,-9,$0802 : db $FF
	dw 9,-9,$0804 : db $00
	dw 9,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":16712..17032
SpriteFrame_gbutterfly_7:
	db $04,$80
	dw $0007
	dw -7,15,-22,0
	dw $0080,$0060
	dw .tiles-SpriteFrame_gbutterfly_7
	db $0C,$FF,$0F,$F4
	dw -7,-15,$0800 : db $FF
	dw 9,-15,$0802 : db $00
	dw 9,-7,$0803 : db $00
	dw -6,-23,$0812 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":17082..17306
SpriteFrame_gbutterfly_8:
	db $04,$80
	dw $0007
	dw -6,19,-16,1
	dw $0080,$0060
	dw .tiles-SpriteFrame_gbutterfly_8
	db $08,$01,$09,$00
	dw -6,-14,$0800 : db $FF
	dw 10,-6,$0802 : db $00
	dw 18,-6,$0803 : db $00
	dw 1,-22,$0812 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":17356..17580
SpriteFrame_gbutterfly_9:
	db $04,$80
	dw $0010
	dw -18,13,-24,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_gbutterfly_9
	db $F9,$02,$F6,$F6
	dw -18,-24,$0800 : db $FF
	dw -2,-24,$0802 : db $FF
	dw -12,-8,$0804 : db $FF
	dw 4,-8,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":17630..18142
SpriteFrame_gbutterfly_10:
	db $05,$80
	dw $000E
	dw -13,18,-23,1
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gbutterfly_10
	db $F4,$01,$F3,$F9
	dw -9,-23,$0800 : db $FF
	dw -13,-7,$0802 : db $FF
	dw 3,-7,$0804 : db $FF
	dw 7,-15,$0806 : db $00
	dw 15,-15,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":18199..18647
SpriteFrame_gbutterfly_11:
	db $04,$80
	dw $000A
	dw -9,18,-15,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gbutterfly_11
	db $FC,$05,$FB,$01
	dw -9,-10,$0800 : db $FF
	dw 7,-10,$0802 : db $FF
	dw -6,-18,$0804 : db $00
	dw 2,-18,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":18697..19017
SpriteFrame_gbutterfly_12:
	db $05,$80
	dw $0011
	dw -18,14,-24,1
	dw $0120,$0100
	dw .tiles-SpriteFrame_gbutterfly_12
	db $EF,$00,$ED,$F3
	dw -18,-24,$0800 : db $FF
	dw -2,-24,$0802 : db $FF
	dw -16,-8,$0804 : db $FF
	dw 0,-8,$0806 : db $FF
	dw 14,-16,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":19074..19618
SpriteFrame_gbutterfly_13:
	db $04,$80
	dw $000A
	dw -19,10,-20,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gbutterfly_13
	db $EE,$01,$ED,$F9
	dw -19,-14,$0800 : db $FF
	dw -3,-14,$0802 : db $FF
	dw -8,-22,$0804 : db $00
	dw 0,-22,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":19668..19988
SpriteFrame_gbutterfly_14:
	db $04,$80
	dw $000A
	dw -15,16,-16,3
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gbutterfly_14
	db $0E,$02,$11,$F9
	dw -15,-12,$0800 : db $FF
	dw 1,-12,$0802 : db $FF
	dw -5,-20,$0804 : db $00
	dw 3,-20,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":20038..20358
SpriteFrame_gbutterfly_15:
	db $04,$80
	dw $0010
	dw -17,9,-24,2
	dw $0100,$0100
	dw .tiles-SpriteFrame_gbutterfly_15
	db $F0,$01,$EE,$F4
	dw -17,-24,$0800 : db $FF
	dw -1,-24,$0802 : db $FF
	dw -15,-8,$0804 : db $FF
	dw 1,-8,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":20408..20920

SpriteFrame_gbutterfly_16:
	db $06,$80
	dw $000C
	dw -19,10,-23,-1
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gbutterfly_16
	db $01,$FF,$01,$FD
	dw -18,-23,$0800 : db $FF
	dw -2,-23,$0802 : db $FF
	dw -19,-7,$0804 : db $00
	dw -11,-7,$0805 : db $00
	dw -3,-7,$0814 : db $00
	dw 5,-7,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":20984..21368
SpriteFrame_gbutterfly_17:
	db $03,$80
	dw $0009
	dw -18,9,-15,2
	dw $00A0,$0080
	dw .tiles-SpriteFrame_gbutterfly_17
	db $F0,$02,$F2,$F8
	dw -18,-13,$0800 : db $FF
	dw -2,-13,$0802 : db $FF
	dw -4,-21,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":21411..21699
SpriteFrame_gbutterfly_18:
	db $04,$80
	dw $000A
	dw -13,8,-25,0
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gbutterfly_18
	db $01,$FF,$F3,$FD
	dw -8,-25,$0800 : db $FF
	dw -13,-9,$0802 : db $FF
	dw 8,-25,$0804 : db $00
	dw 3,-1,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":21749..22069
SpriteFrame_gbutterfly_19:
	db $05,$80
	dw $000B
	dw -18,16,-23,0
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_gbutterfly_19
	db $EF,$FF,$ED,$F7
	dw -18,-15,$0800 : db $FF
	dw -2,-15,$0802 : db $FF
	dw 14,-15,$0804 : db $00
	dw -3,-23,$0805 : db $00
	dw 5,-23,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":22126..22478
SpriteFrame_gbutterfly_20:
	db $02,$80
	dw $0008
	dw -17,7,-13,5
	dw $0080,$0080
	dw .tiles-SpriteFrame_gbutterfly_20
	db $F9,$05,$FC,$03
	dw -17,-6,$0800 : db $FF
	dw -1,-13,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":22514..22770
SpriteFrame_gbutterfly_21:
	db $05,$80
	dw $000E
	dw -15,11,-26,1
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gbutterfly_21
	db $F1,$01,$F0,$FA
	dw -11,-26,$0800 : db $FF
	dw -15,-10,$0802 : db $FF
	dw 1,-10,$0804 : db $FF
	dw 5,-26,$0806 : db $00
	dw 5,-18,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":22827..23275
SpriteFrame_gbutterfly_22:
	db $04,$80
	dw $0010
	dw -17,12,-23,2
	dw $0100,$0100
	dw .tiles-SpriteFrame_gbutterfly_22
	db $00,$01,$00,$00
	dw -17,-23,$0800 : db $FF
	dw -1,-23,$0802 : db $FF
	dw -17,-7,$0804 : db $FF
	dw -1,-7,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":23325..23837
SpriteFrame_gbutterfly_23:
	db $02,$80
	dw $0008
	dw -16,8,-11,3
	dw $0080,$0080
	dw .tiles-SpriteFrame_gbutterfly_23
	db $F0,$03,$EF,$FE
	dw -16,-11,$0800 : db $FF
	dw 0,-11,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":23873..24129
SpriteFrame_gsprawll_0:
	db $07,$80
	dw $000D
	dw -17,16,-20,1
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gsprawll_0
	db $F2,$01,$EF,$F1
	dw -17,-20,$0800 : db $FF
	dw -1,-20,$0802 : db $FF
	dw 15,-12,$0804 : db $00
	dw -15,-4,$0805 : db $00
	dw -7,-4,$0814 : db $00
	dw 1,-4,$0815 : db $00
	dw 9,-4,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":24200..24616

SpriteFrame_gsprawll_1:
	db $07,$80
	dw $0010
	dw -22,20,-14,5
	dw $0100,$0100
	dw .tiles-SpriteFrame_gsprawll_1
	db $EE,$03,$EB,$FA
	dw -22,-14,$0800 : db $FF
	dw -6,-14,$0802 : db $FF
	dw 10,-14,$0804 : db $FF
	dw -20,2,$0806 : db $00
	dw -12,2,$0807 : db $00
	dw -4,2,$0816 : db $00
	dw 4,2,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":24687..25199
SpriteFrame_gsprawll_2:
	db $07,$80
	dw $000D
	dw -22,25,-12,7
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gsprawll_2
	db $ED,$04,$EA,$01
	dw -22,-8,$0800 : db $FF
	dw -6,-8,$0802 : db $FF
	dw 10,0,$0804 : db $00
	dw 18,0,$0805 : db $00
	dw -13,-16,$0814 : db $00
	dw -5,-16,$0815 : db $00
	dw 3,-16,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":25270..25686
SpriteFrame_gsprawll_3:
	db $04,$80
	dw $000A
	dw -7,16,-26,1
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gsprawll_3
	db $FB,$FF,$F8,$EB
	dw -7,-26,$0800 : db $FF
	dw -7,-10,$0802 : db $FF
	dw 9,-18,$0804 : db $00
	dw 9,-10,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":25736..26056
SpriteFrame_gsprawll_4:
	db $04,$80
	dw $000A
	dw -15,16,-15,2
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gsprawll_4
	db $F3,$01,$F0,$F4
	dw -15,-13,$0800 : db $FF
	dw 1,-13,$0802 : db $FF
	dw -14,-21,$0804 : db $00
	dw -6,-21,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":26106..26426
SpriteFrame_gsprawll_5:
	db $04,$80
	dw $000A
	dw -20,20,-8,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gsprawll_5
	db $EE,$02,$EB,$FF
	dw -20,-8,$0800 : db $FF
	dw -4,-8,$0802 : db $FF
	dw 12,0,$0804 : db $00
	dw 20,0,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":26476..26796
SpriteFrame_gsprawll_6:
	db $04,$80
	dw $000A
	dw -12,16,-20,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gsprawll_6
	db $05,$01,$08,$F1
	dw -6,-20,$0800 : db $FF
	dw 4,-4,$0802 : db $FF
	dw -12,-4,$0804 : db $00
	dw -4,-4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":26846..27166
SpriteFrame_gsprawll_7:
	db $04,$80
	dw $000A
	dw -9,20,-19,2
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gsprawll_7
	db $F9,$00,$F5,$EF
	dw -9,-13,$0800 : db $FF
	dw 7,-13,$0802 : db $FF
	dw -9,-21,$0804 : db $00
	dw -1,-21,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":27216..27536
SpriteFrame_gsprawll_8:
	db $04,$80
	dw $000A
	dw -16,17,-12,4
	dw $00C0,$0080
	dw .tiles-SpriteFrame_gsprawll_8
	db $F2,$FE,$EF,$FD
	dw -16,-12,$0800 : db $FF
	dw 0,-12,$0802 : db $FF
	dw 16,-4,$0804 : db $00
	dw -8,4,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":27586..27906
SpriteFrame_gsprawll_9:
	db $07,$80
	dw $0010
	dw -16,26,-19,2
	dw $0100,$0100
	dw .tiles-SpriteFrame_gsprawll_9
	db $11,$01,$14,$EF
	dw -16,-13,$0800 : db $FF
	dw 0,-13,$0802 : db $FF
	dw 16,-13,$0804 : db $FF
	dw 1,-21,$0806 : db $00
	dw 9,-21,$0807 : db $00
	dw 17,-21,$0816 : db $00
	dw 25,-21,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":27977..28489
SpriteFrame_gsprawll_10:
	db $05,$80
	dw $000E
	dw -15,28,-14,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gsprawll_10
	db $14,$01,$17,$F5
	dw -15,-12,$0800 : db $FF
	dw 1,-12,$0802 : db $FF
	dw 17,-12,$0804 : db $FF
	dw 8,-20,$0806 : db $00
	dw 16,-20,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":28546..28994

SpriteFrame_gsprawll_11:
	db $05,$80
	dw $000E
	dw -13,33,-14,6
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gsprawll_11
	db $19,$FC,$1C,$FB
	dw -13,-9,$0800 : db $FF
	dw 3,-9,$0802 : db $FF
	dw 19,-9,$0804 : db $FF
	dw 6,-17,$0806 : db $00
	dw 14,-17,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":29051..29499
SpriteFrame_gsprawll_12:
	db $05,$80
	dw $0011
	dw -18,17,-23,3
	dw $0120,$0100
	dw .tiles-SpriteFrame_gsprawll_12
	db $0E,$02,$11,$F6
	dw -18,-23,$0800 : db $FF
	dw -2,-23,$0802 : db $FF
	dw -13,-7,$0804 : db $FF
	dw 3,-7,$0806 : db $FF
	dw 14,-15,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":29556..30100
SpriteFrame_gsprawll_13:
	db $06,$80
	dw $0012
	dw -24,23,-20,4
	dw $0140,$0100
	dw .tiles-SpriteFrame_gsprawll_13
	db $14,$FC,$17,$F6
	dw -24,-16,$0800 : db $FF
	dw -8,-20,$0802 : db $FF
	dw 8,-20,$0804 : db $FF
	dw 8,-4,$0806 : db $FF
	dw -8,-4,$0808 : db $00
	dw 0,-4,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":30164..30740
SpriteFrame_gsprawll_14:
	db $06,$80
	dw $000F
	dw -31,25,-12,6
	dw $0100,$00E0
	dw .tiles-SpriteFrame_gsprawll_14
	db $16,$FD,$19,$FC
	dw -15,-12,$0800 : db $FF
	dw 1,-12,$0802 : db $FF
	dw 17,-12,$0804 : db $FF
	dw -31,-4,$0806 : db $00
	dw -23,-4,$0807 : db $00
	dw 16,4,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":30804..31284
SpriteFrame_gsprawll_15:
	db $05,$80
	dw $0011
	dw -19,16,-24,6
	dw $0120,$0100
	dw .tiles-SpriteFrame_gsprawll_15
	db $0E,$02,$11,$F5
	dw -11,-24,$0800 : db $FF
	dw 5,-24,$0802 : db $FF
	dw -19,-8,$0804 : db $FF
	dw -3,-8,$0806 : db $FF
	dw 13,0,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":31341..31885
SpriteFrame_gsprawll_16:
	db $07,$80
	dw $000D
	dw -29,23,-16,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_gsprawll_16
	db $14,$01,$17,$F9
	dw -13,-10,$0800 : db $FF
	dw 3,-10,$0802 : db $FF
	dw -29,-2,$0804 : db $00
	dw -21,-2,$0805 : db $00
	dw 19,-10,$0814 : db $00
	dw 19,-2,$0815 : db $00
	dw 2,-18,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames8B.bin":31956..32372
