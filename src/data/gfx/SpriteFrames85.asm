; More frames of SpriteFrames (format at SpriteFrames82). Frame labels are SpriteFrame_<group>_<n>.

SpriteFrame_hipl_5:
	db $04,$80
	dw $000A
	dw -17,5,-17,14
	dw $00C0,$0080
	dw .tiles-SpriteFrame_hipl_5
	db $F8,$0C,$03,$04
	dw -17,-17,$0800 : db $FF
	dw -17,-1,$0802 : db $FF
	dw -1,-10,$0804 : db $00
	dw -1,-2,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":50..370
SpriteFrame_hipl_6:
	db $05,$80
	dw $000E
	dw -33,4,-23,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_hipl_6
	db $E2,$03,$03,$04
	dw -33,-11,$0800 : db $FF
	dw -17,-11,$0802 : db $FF
	dw -16,-27,$0804 : db $FF
	dw -1,-11,$0806 : db $00
	dw -1,-3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":427..875
SpriteFrame_hipl_7:
	db $04,$80
	dw $000D
	dw -19,9,-25,7
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_hipl_7
	db $EF,$07,$03,$04
	dw -5,-25,$0800 : db $FF
	dw -19,-9,$0802 : db $FF
	dw -3,-9,$0804 : db $FF
	dw -17,7,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":925..1341
SpriteFrame_hipr_0:
	db $05,$80
	dw $000E
	dw -20,8,-26,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_hipr_0
	db $EE,$FC,$03,$04
	dw -20,-26,$0800 : db $FF
	dw -18,-10,$0802 : db $FF
	dw -2,-10,$0804 : db $FF
	dw -4,-26,$0806 : db $00
	dw -4,-18,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":1398..1846
SpriteFrame_hipr_1:
	db $03,$80
	dw $0009
	dw -9,9,-26,3
	dw $00A0,$0080
	dw .tiles-SpriteFrame_hipr_1
	db $F8,$F8,$03,$04
	dw -8,-26,$0800 : db $FF
	dw -9,-10,$0802 : db $FF
	dw 7,-2,$0804 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":1889..2177
SpriteFrame_hipr_2:
	db $08,$80
	dw $000D
	dw -6,32,-20,3
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_hipr_2
	db $1D,$FA,$03,$04
	dw -3,-20,$0800 : db $FF
	dw 13,-20,$0802 : db $FF
	dw 29,-20,$0804 : db $00
	dw 29,-12,$C803 : db $00
	dw -6,-4,$0805 : db $00
	dw 2,-4,$0814 : db $00
	dw 10,-4,$0815 : db $00
	dw 18,-4,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":2255..2671
SpriteFrame_hipr_3:
	db $05,$80
	dw $000E
	dw -8,34,-19,3
	dw $0100,$00C0
	dw .tiles-SpriteFrame_hipr_3
	db $1F,$02,$05,$04
	dw -8,-12,$0800 : db $FF
	dw 8,-12,$0802 : db $FF
	dw 24,-12,$0804 : db $FF
	dw 0,-20,$0806 : db $00
	dw 8,-20,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":2728..3176
SpriteFrame_hipr_4:
	db $04,$80
	dw $000A
	dw -4,18,-16,14
	dw $00C0,$0080
	dw .tiles-SpriteFrame_hipr_4
	db $0F,$0D,$04,$04
	dw -4,-16,$0800 : db $FF
	dw -4,0,$0802 : db $FF
	dw 12,0,$0804 : db $00
	dw 12,8,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":3226..3546
SpriteFrame_hipr_5:
	db $02,$80
	dw $0008
	dw -4,11,-14,16
	dw $0080,$0080
	dw .tiles-SpriteFrame_hipr_5
	db $01,$0E,$03,$04
	dw -4,-14,$0800 : db $FF
	dw -3,2,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":3582..3838
SpriteFrame_hipr_6:
	db $03,$80
	dw $000C
	dw -27,4,-20,5
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_hipr_6
	db $E8,$04,$03,$04
	dw -27,-10,$0800 : db $FF
	dw -11,-10,$0802 : db $FF
	dw -12,-26,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":3881..4265

SpriteFrame_hipr_7:
	db $05,$80
	dw $000E
	dw -31,6,-24,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_hipr_7
	db $E4,$04,$02,$04
	dw -31,-11,$0800 : db $FF
	dw -15,-11,$0802 : db $FF
	dw -14,-27,$0804 : db $FF
	dw 1,-11,$0806 : db $00
	dw 1,-3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":4322..4770
SpriteFrame_shoulderl_0:
	db $05,$80
	dw $000B
	dw -16,7,-34,4
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_shoulderl_0
	db $F1,$F4,$04,$04
	dw -16,-34,$0800 : db $FF
	dw -15,-18,$0802 : db $FF
	dw 1,-10,$0804 : db $00
	dw -8,-2,$0805 : db $00
	dw 0,-2,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":4827..5179
SpriteFrame_shoulderl_1:
	db $05,$80
	dw $0011
	dw -6,20,-30,3
	dw $0120,$0100
	dw .tiles-SpriteFrame_shoulderl_1
	db $13,$F6,$03,$04
	dw -6,-30,$0800 : db $FF
	dw 10,-30,$0802 : db $FF
	dw -6,-14,$0804 : db $FF
	dw 10,-14,$0806 : db $FF
	dw -3,2,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":5236..5780
SpriteFrame_shoulderl_2:
	db $05,$80
	dw $0011
	dw -5,33,-26,3
	dw $0120,$0100
	dw .tiles-SpriteFrame_shoulderl_2
	db $1E,$F7,$03,$04
	dw -5,-12,$0800 : db $FF
	dw 11,-12,$0802 : db $FF
	dw 3,-28,$0804 : db $FF
	dw 19,-28,$0806 : db $FF
	dw 28,-12,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":5837..6381
SpriteFrame_shoulderl_3:
	db $07,$80
	dw $0010
	dw -7,34,-19,8
	dw $0100,$0100
	dw .tiles-SpriteFrame_shoulderl_3
	db $1D,$07,$04,$04
	dw -2,-19,$0800 : db $FF
	dw 14,-19,$0802 : db $FF
	dw -7,-3,$0804 : db $FF
	dw 30,-11,$0806 : db $00
	dw 9,5,$0807 : db $00
	dw 17,5,$0816 : db $00
	dw 25,5,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":6452..6964
SpriteFrame_shoulderl_4:
	db $04,$80
	dw $000A
	dw -10,11,-18,12
	dw $00C0,$0080
	dw .tiles-SpriteFrame_shoulderl_4
	db $06,$0A,$04,$04
	dw -6,-18,$0800 : db $FF
	dw -10,-2,$0802 : db $FF
	dw 6,-2,$0804 : db $00
	dw 6,6,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":7014..7334
SpriteFrame_shoulderl_5:
	db $06,$80
	dw $000F
	dw -31,6,-20,8
	dw $0100,$00E0
	dw .tiles-SpriteFrame_shoulderl_5
	db $E4,$07,$04,$04
	dw -15,-20,$0800 : db $FF
	dw -31,-4,$0802 : db $FF
	dw -15,-4,$0804 : db $FF
	dw 1,-12,$0806 : db $00
	dw 1,-4,$0807 : db $00
	dw 1,4,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":7398..7878
SpriteFrame_shoulderl_6:
	db $05,$80
	dw $0011
	dw -33,7,-24,4
	dw $0120,$0100
	dw .tiles-SpriteFrame_shoulderl_6
	db $E3,$02,$04,$04
	dw -33,-12,$0800 : db $FF
	dw -17,-24,$0802 : db $FF
	dw -17,-8,$0804 : db $FF
	dw -1,-13,$0806 : db $FF
	dw -1,3,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":7935..8479

SpriteFrame_shoulderl_7:
	db $06,$80
	dw $0012
	dw -28,5,-31,2
	dw $0140,$0100
	dw .tiles-SpriteFrame_shoulderl_7
	db $E5,$F6,$00,$04
	dw -28,-31,$0800 : db $FF
	dw -12,-31,$0802 : db $FF
	dw -26,-15,$0804 : db $FF
	dw -10,-15,$0806 : db $FF
	dw -6,1,$0808 : db $00
	dw 2,1,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":8543..9119
SpriteFrame_shoulderr_0:
	db $05,$80
	dw $000E
	dw -23,8,-26,5
	dw $0100,$00C0
	dw .tiles-SpriteFrame_shoulderr_0
	db $EA,$FF,$04,$04
	dw -23,-26,$0800 : db $FF
	dw -7,-26,$0802 : db $FF
	dw -7,-10,$0804 : db $FF
	dw -23,-2,$0806 : db $00
	dw -15,-2,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":9176..9624
SpriteFrame_shoulderr_1:
	db $04,$80
	dw $0010
	dw -17,11,-24,5
	dw $0100,$0100
	dw .tiles-SpriteFrame_shoulderr_1
	db $F0,$FE,$04,$04
	dw -14,-24,$0800 : db $FF
	dw 2,-24,$0802 : db $FF
	dw -17,-8,$0804 : db $FF
	dw -1,-8,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":9674..10186
SpriteFrame_shoulderr_2:
	db $04,$80
	dw $000D
	dw -11,17,-20,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_shoulderr_2
	db $0F,$F7,$05,$04
	dw -7,-20,$0800 : db $FF
	dw 9,-20,$0802 : db $FF
	dw -11,-4,$0804 : db $FF
	dw 5,-4,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":10236..10652
SpriteFrame_shoulderr_3:
	db $04,$80
	dw $0010
	dw -17,14,-26,4
	dw $0100,$0100
	dw .tiles-SpriteFrame_shoulderr_3
	db $0D,$FD,$03,$04
	dw -17,-26,$0800 : db $FF
	dw -1,-26,$0802 : db $FF
	dw -13,-10,$0804 : db $FF
	dw 3,-10,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":10702..11214
SpriteFrame_shoulderr_4:
	db $05,$80
	dw $000E
	dw -15,19,-21,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_shoulderr_4
	db $10,$00,$03,$04
	dw -15,-21,$0800 : db $FF
	dw 1,-21,$0802 : db $FF
	dw -9,-5,$0804 : db $FF
	dw 7,-5,$0806 : db $00
	dw 15,-5,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":11271..11719
SpriteFrame_shoulderr_5:
	db $04,$80
	dw $000A
	dw -17,10,-21,8
	dw $00C0,$0080
	dw .tiles-SpriteFrame_shoulderr_5
	db $03,$07,$06,$04
	dw -17,-21,$0800 : db $FF
	dw -10,-5,$0802 : db $FF
	dw -1,-13,$0804 : db $00
	dw 6,-5,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":11769..12089
SpriteFrame_shoulderr_6:
	db $06,$80
	dw $000C
	dw -19,11,-24,6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_shoulderr_6
	db $F4,$06,$03,$04
	dw -19,-24,$0800 : db $FF
	dw -11,-8,$0802 : db $FF
	dw -3,-24,$0804 : db $00
	dw -3,-16,$0805 : db $00
	dw 5,-8,$0814 : db $00
	dw 5,0,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":12153..12537

SpriteFrame_shoulderr_7:
	db $03,$80
	dw $000C
	dw -18,11,-25,6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_shoulderr_7
	db $F1,$05,$03,$04
	dw -6,-25,$0800 : db $FF
	dw -18,-9,$0802 : db $FF
	dw -2,-9,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":12580..12964
SpriteFrame_sweep_0:
	db $02,$80
	dw $0008
	dw -9,7,-26,5
	dw $0080,$0080
	dw .tiles-SpriteFrame_sweep_0
	db $F7,$EB,$03,$05
	dw -9,-26,$0800 : db $FF
	dw -8,-10,$0802 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":13000..13256
SpriteFrame_sweep_1:
	db $06,$80
	dw $000C
	dw -11,9,-31,8
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_sweep_1
	db $F5,$E3,$03,$07
	dw -10,-31,$0800 : db $FF
	dw -11,-15,$0802 : db $FF
	dw 5,-15,$0804 : db $00
	dw 5,-7,$0805 : db $00
	dw -2,1,$0814 : db $00
	dw 6,1,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":13320..13704
SpriteFrame_sweep_2:
	db $03,$80
	dw $000C
	dw -7,18,-24,7
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_sweep_2
	db $11,$FA,$01,$05
	dw -7,-24,$0800 : db $FF
	dw -7,-8,$0802 : db $FF
	dw 9,-9,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":13747..14131
SpriteFrame_sweep_3:
	db $04,$80
	dw $000D
	dw -8,21,-22,6
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_sweep_3
	db $14,$F1,$FF,$04
	dw -8,-22,$0800 : db $FF
	dw 8,-22,$0802 : db $FF
	dw -8,-6,$0804 : db $FF
	dw 8,-6,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":14181..14597
SpriteFrame_sweep_4:
	db $04,$80
	dw $000D
	dw -9,29,-25,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_sweep_4
	db $1A,$03,$03,$01
	dw -3,-25,$0800 : db $FF
	dw -9,-9,$0802 : db $FF
	dw 7,-9,$0804 : db $FF
	dw 23,-1,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":14647..15063
SpriteFrame_sweep_5:
	db $09,$80
	dw $000C
	dw -11,34,-20,3
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_sweep_5
	db $22,$02,$02,$00
	dw -6,-20,$0800 : db $FF
	dw 10,-20,$0802 : db $00
	dw 10,-12,$0803 : db $00
	dw -11,-4,$0812 : db $00
	dw -3,-4,$0813 : db $00
	dw 5,-4,$0804 : db $00
	dw 13,-4,$0805 : db $00
	dw 21,-4,$0814 : db $00
	dw 29,-4,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":15148..15532
SpriteFrame_sweep_6:
	db $05,$80
	dw $000E
	dw -11,22,-23,12
	dw $0100,$00C0
	dw .tiles-SpriteFrame_sweep_6
	db $13,$0C,$02,$02
	dw -6,-23,$0800 : db $FF
	dw -11,-7,$0802 : db $FF
	dw 5,-7,$0804 : db $FF
	dw 10,-23,$0806 : db $00
	dw 16,9,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":15589..16037
SpriteFrame_sweep_7:
	db $07,$80
	dw $0010
	dw -13,34,-19,13
	dw $0100,$0100
	dw .tiles-SpriteFrame_sweep_7
	db $1F,$0C,$03,$03
	dw -13,-18,$0800 : db $FF
	dw 3,-19,$0802 : db $FF
	dw 3,-3,$0804 : db $FF
	dw -13,-2,$0806 : db $00
	dw -5,-2,$0807 : db $00
	dw 19,8,$0816 : db $00
	dw 27,8,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":16108..16620

SpriteFrame_sweep_8:
	db $06,$80
	dw $000C
	dw -8,12,-18,16
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_sweep_8
	db $08,$0E,$03,$02
	dw -1,1,$0800 : db $FF
	dw -8,-15,$0802 : db $FF
	dw 8,-15,$0804 : db $00
	dw 8,-7,$0805 : db $00
	dw -4,-23,$0814 : db $00
	dw 4,-23,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":16684..17068
SpriteFrame_sweep_9:
	db $05,$80
	dw $000B
	dw -7,10,-13,26
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_sweep_9
	db $05,$19,$03,$04
	dw -7,-13,$0800 : db $FF
	dw -5,3,$0802 : db $FF
	dw 9,-13,$0804 : db $00
	dw 2,19,$0805 : db $00
	dw 10,19,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":17125..17477
SpriteFrame_sweep_10:
	db $05,$80
	dw $000E
	dw -19,8,-19,9
	dw $0100,$00C0
	dw .tiles-SpriteFrame_sweep_10
	db $F1,$08,$03,$04
	dw -8,-19,$0800 : db $FF
	dw -19,-3,$0802 : db $FF
	dw -3,-3,$0804 : db $FF
	dw 8,-19,$0806 : db $00
	dw 8,-11,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":17534..17982
SpriteFrame_sweep_11:
	db $06,$80
	dw $000C
	dw -30,9,-11,18
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_sweep_11
	db $E5,$10,$01,$05
	dw -13,-11,$0800 : db $FF
	dw -30,5,$0802 : db $FF
	dw 3,-11,$0804 : db $00
	dw 3,-3,$0805 : db $00
	dw -14,5,$0814 : db $00
	dw -6,5,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":18046..18430
SpriteFrame_sweep_12:
	db $04,$80
	dw $0010
	dw -33,7,-20,4
	dw $0100,$0100
	dw .tiles-SpriteFrame_sweep_12
	db $E3,$04,$03,$04
	dw -33,-11,$0800 : db $FF
	dw -17,-11,$0802 : db $FF
	dw -1,-11,$0804 : db $FF
	dw -14,-27,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":18480..18992
SpriteFrame_sweep_13:
	db $09,$80
	dw $000F
	dw -39,12,-17,5
	dw $0100,$00E0
	dw .tiles-SpriteFrame_sweep_13
	db $DB,$03,$05,$05
	dw -18,-17,$0800 : db $FF
	dw -2,-17,$0802 : db $FF
	dw -39,-1,$0804 : db $00
	dw -31,-1,$0805 : db $00
	dw -23,-1,$0814 : db $00
	dw -15,-1,$0815 : db $00
	dw -7,-1,$0806 : db $00
	dw 1,-1,$0807 : db $00
	dw 9,-1,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":19077..19557
SpriteFrame_sweep_14:
	db $05,$80
	dw $000E
	dw -25,11,-21,4
	dw $0100,$00C0
	dw .tiles-SpriteFrame_sweep_14
	db $E8,$F7,$03,$04
	dw -25,-21,$0800 : db $FF
	dw -9,-21,$0802 : db $FF
	dw -11,-5,$0804 : db $FF
	dw 5,-5,$0806 : db $00
	dw 5,3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":19614..20062
SpriteFrame_sweep_15:
	db $05,$80
	dw $000B
	dw -25,12,-19,4
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_sweep_15
	db $E8,$F5,$04,$05
	dw -25,-19,$0800 : db $FF
	dw -9,-19,$0802 : db $FF
	dw -10,-3,$0804 : db $00
	dw -2,-3,$0805 : db $00
	dw 6,-3,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":20119..20471
SpriteFrame_fallback_0:
	db $04,$80
	dw $0007
	dw -10,13,-13,10
	dw $0080,$0060
	dw .tiles-SpriteFrame_fallback_0
	db $0A,$07,$01,$0C
	dw -10,-5,$0800 : db $FF
	dw 6,-5,$0802 : db $00
	dw 6,3,$0803 : db $00
	dw 8,-13,$0812 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":20521..20745

SpriteFrame_fallback_1:
	db $05,$80
	dw $000E
	dw -12,14,-24,12
	dw $0100,$00C0
	dw .tiles-SpriteFrame_fallback_1
	db $0A,$FA,$00,$04
	dw -12,-3,$0800 : db $FF
	dw 4,-3,$0802 : db $FF
	dw -1,-19,$0804 : db $FF
	dw -9,-11,$0806 : db $00
	dw 10,-27,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":20802..21250
SpriteFrame_fallback_2:
	db $08,$80
	dw $0011
	dw -10,12,-15,34
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallback_2
	db $05,$21,$02,$02
	dw -8,-15,$0800 : db $FF
	dw -10,1,$0802 : db $FF
	dw 0,17,$0804 : db $FF
	dw 8,-15,$0806 : db $00
	dw 8,-7,$0807 : db $00
	dw 6,1,$0816 : db $00
	dw 6,9,$0817 : db $00
	dw 0,33,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":21328..21872
SpriteFrame_fallback_3:
	db $04,$80
	dw $000A
	dw -12,13,-24,7
	dw $00C0,$0080
	dw .tiles-SpriteFrame_fallback_3
	db $0D,$FC,$00,$05
	dw -12,-8,$0800 : db $FF
	dw 4,-8,$0802 : db $FF
	dw 10,-24,$0804 : db $00
	dw 10,-16,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":21922..22242
SpriteFrame_fallback_4:
	db $06,$80
	dw $000C
	dw -11,17,-18,9
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_fallback_4
	db $10,$03,$00,$0A
	dw 9,-18,$0800 : db $FF
	dw -10,-2,$0802 : db $FF
	dw -11,-10,$0804 : db $00
	dw -3,-10,$0805 : db $00
	dw 6,-2,$0814 : db $00
	dw 6,6,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":22306..22690
SpriteFrame_fallback_5:
	db $04,$80
	dw $000D
	dw -15,16,-19,13
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_fallback_5
	db $07,$03,$02,$05
	dw -15,-10,$0800 : db $FF
	dw 1,-19,$0802 : db $FF
	dw 1,-3,$0804 : db $FF
	dw -7,6,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":22740..23156
SpriteFrame_fallback_6:
	db $08,$80
	dw $0014
	dw -22,15,-15,27
	dw $0140,$0140
	dw .tiles-SpriteFrame_fallback_6
	db $EB,$1B,$00,$00
	dw -5,-15,$0800 : db $FF
	dw -19,1,$0802 : db $FF
	dw -3,1,$0804 : db $FF
	dw -22,17,$0806 : db $FF
	dw 11,-15,$0808 : db $00
	dw 11,-7,$0809 : db $00
	dw -6,17,$0818 : db $00
	dw 2,17,$0819 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":23234..23874
SpriteFrame_fallback_7:
	db $06,$80
	dw $000C
	dw -9,14,-27,7
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_fallback_7
	db $0B,$04,$04,$03
	dw -9,-8,$0800 : db $FF
	dw 3,-24,$0802 : db $FF
	dw 7,-8,$0804 : db $00
	dw 7,0,$0805 : db $00
	dw -5,-16,$0814 : db $00
	dw 9,-32,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":23938..24322
SpriteFrame_fallback_8:
	db $06,$80
	dw $000C
	dw -10,15,-13,15
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_fallback_8
	db $0D,$0C,$01,$0B
	dw -10,-13,$0800 : db $FF
	dw -5,3,$0802 : db $FF
	dw 6,-13,$0804 : db $00
	dw 6,-5,$0805 : db $00
	dw 11,3,$0814 : db $00
	dw 11,11,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":24386..24770

SpriteFrame_fallback_9:
	db $05,$80
	dw $000E
	dw -12,17,-15,12
	dw $0100,$00C0
	dw .tiles-SpriteFrame_fallback_9
	db $04,$07,$03,$07
	dw -12,-15,$0800 : db $FF
	dw 4,-15,$0802 : db $FF
	dw 4,1,$0804 : db $FF
	dw -12,1,$0806 : db $00
	dw -4,1,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":24827..25275
SpriteFrame_fallback_10:
	db $07,$80
	dw $0010
	dw -35,18,-10,9
	dw $0100,$0100
	dw .tiles-SpriteFrame_fallback_10
	db $DC,$FC,$00,$01
	dw -35,-7,$0800 : db $FF
	dw -19,-10,$0802 : db $FF
	dw -3,-4,$0804 : db $FF
	dw -19,6,$0806 : db $00
	dw -11,6,$0807 : db $00
	dw 13,-5,$0816 : db $00
	dw 13,3,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":25346..25858
SpriteFrame_fallback_11:
	db $06,$80
	dw $000C
	dw -7,14,-16,12
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_fallback_11
	db $07,$0A,$06,$05
	dw -7,-16,$0800 : db $FF
	dw -7,0,$0802 : db $FF
	dw 9,-16,$0804 : db $00
	dw 9,-8,$0805 : db $00
	dw 9,0,$0814 : db $00
	dw 9,8,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":25922..26306
SpriteFrame_fallback_12:
	db $06,$80
	dw $000C
	dw -11,12,-11,16
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_fallback_12
	db $09,$0E,$01,$0C
	dw -11,-11,$0800 : db $FF
	dw -8,5,$0802 : db $FF
	dw 5,-11,$0804 : db $00
	dw 5,-3,$0805 : db $00
	dw 8,5,$0814 : db $00
	dw 8,13,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":26370..26754
SpriteFrame_fallback_13:
	db $04,$80
	dw $000D
	dw -11,18,-22,14
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_fallback_13
	db $FE,$0C,$03,$05
	dw -10,-22,$0800 : db $FF
	dw -11,-6,$0802 : db $FF
	dw 5,-6,$0804 : db $FF
	dw 4,10,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":26804..27220
SpriteFrame_fallback_14:
	db $07,$80
	dw $0013
	dw -29,17,-21,15
	dw $0140,$0120
	dw .tiles-SpriteFrame_fallback_14
	db $E3,$EE,$00,$01
	dw -29,-21,$0800 : db $FF
	dw -12,-21,$0802 : db $FF
	dw -18,-5,$0804 : db $FF
	dw -2,-5,$0806 : db $FF
	dw 14,-5,$0808 : db $00
	dw 14,3,$0809 : db $00
	dw 4,11,$0818 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":27291..27899
SpriteFrame_fallback_15:
	db $05,$80
	dw $000B
	dw -8,14,-22,13
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_fallback_15
	db $06,$0C,$03,$05
	dw -6,-22,$0800 : db $FF
	dw -8,-6,$0802 : db $FF
	dw 8,-6,$0804 : db $00
	dw 8,2,$0805 : db $00
	dw 2,10,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":27956..28308
SpriteFrame_fallback_16:
	db $06,$80
	dw $000F
	dw -17,12,-14,20
	dw $0100,$00E0
	dw .tiles-SpriteFrame_fallback_16
	db $F0,$12,$01,$0C
	dw -10,5,$0800 : db $FF
	dw -17,-11,$0802 : db $FF
	dw -1,-11,$0804 : db $FF
	dw 6,5,$0806 : db $00
	dw 6,13,$0807 : db $00
	dw -2,-19,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":28372..28852

SpriteFrame_fallback_17:
	db $05,$80
	dw $0011
	dw -16,12,-22,16
	dw $0120,$0100
	dw .tiles-SpriteFrame_fallback_17
	db $F2,$03,$00,$07
	dw -13,1,$0800 : db $FF
	dw 3,1,$0802 : db $FF
	dw -15,-15,$0804 : db $FF
	dw 1,-15,$0806 : db $FF
	dw -16,-23,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":28909..29453
SpriteFrame_fallback_18:
	db $06,$80
	dw $0012
	dw -12,13,-26,18
	dw $0140,$0100
	dw .tiles-SpriteFrame_fallback_18
	db $02,$E9,$01,$03
	dw -9,-26,$0800 : db $FF
	dw -12,-10,$0802 : db $FF
	dw 4,-10,$0804 : db $FF
	dw -10,6,$0806 : db $FF
	dw 6,6,$0808 : db $00
	dw 6,14,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":29517..30093
SpriteFrame_fallback_19:
	db $05,$80
	dw $000B
	dw -15,10,-18,13
	dw $00C0,$00A0
	dw .tiles-SpriteFrame_fallback_19
	db $F4,$0D,$00,$04
	dw -15,-18,$0800 : db $FF
	dw -12,-2,$0802 : db $FF
	dw 1,-10,$0804 : db $00
	dw 4,-2,$0805 : db $00
	dw 4,6,$0814 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":30150..30502
SpriteFrame_fallback_20:
	db $05,$80
	dw $000E
	dw -16,10,-17,15
	dw $0100,$00C0
	dw .tiles-SpriteFrame_fallback_20
	db $F2,$0C,$01,$0A
	dw -5,-13,$0800 : db $FF
	dw -5,3,$0802 : db $FF
	dw -21,-17,$0804 : db $FF
	dw -13,0,$0806 : db $00
	dw -13,8,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":30559..31007
SpriteFrame_fallback_21:
	db $06,$80
	dw $0012
	dw -17,13,-27,14
	dw $0140,$0100
	dw .tiles-SpriteFrame_fallback_21
	db $FB,$04,$01,$08
	dw -5,-27,$0800 : db $FF
	dw -16,-11,$0802 : db $FF
	dw 0,-11,$0804 : db $FF
	dw -17,5,$0806 : db $FF
	dw -1,5,$0808 : db $00
	dw 7,5,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":31071..31647
SpriteFrame_fallback_22:
	db $06,$80
	dw $0012
	dw -17,22,-26,15
	dw $0140,$0100
	dw .tiles-SpriteFrame_fallback_22
	db $13,$EA,$01,$01
	dw 7,-26,$0800 : db $FF
	dw 7,-9,$0802 : db $FF
	dw -9,-15,$0804 : db $FF
	dw -9,1,$0806 : db $FF
	dw -17,1,$0808 : db $00
	dw -17,9,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":31711..32287
SpriteFrame_fallback_23:
	db $06,$80
	dw $000C
	dw -13,9,-25,13
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_fallback_23
	db $F7,$08,$02,$05
	dw -13,-2,$0800 : db $FF
	dw -9,-18,$0802 : db $FF
	dw 3,-2,$0804 : db $00
	dw 3,6,$0805 : db $00
	dw 7,-10,$0814 : db $00
	dw -10,-26,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames85.bin":32351..32735
