; More frames of SpriteFrames. A frame is the piece count, flags (bit 7: 16x16 tiles), tile
; count, the box of its pixels (left, right, top, bottom; nothing reads it), the two transfer
; sizes, the tile offset, the hot spot x / y (signed bytes, GetHot), the stick point x / y
; (GetFrameHot), the pieces, then the tiles. Frame labels are SpriteFrame_<group>_<n>.

SpriteFrame_gwall_1:
	db $04,$80
	dw $0010
	dw -18,11,-37,-6
	dw $0100,$0100
	dw .tiles-SpriteFrame_gwall_1
	db $00,$00,$00,$00
	dw -18,-37,$0800 : db $FF
	dw -2,-37,$0802 : db $FF
	dw -15,-21,$0804 : db $FF
	dw 1,-21,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":50..562
SpriteFrame_gwall_2:
	db $03,$80
	dw $000C
	dw -17,12,-31,-6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_gwall_2
	db $0C,$00,$1D,$00
	dw -17,-31,$0800 : db $FF
	dw -1,-31,$0802 : db $FF
	dw -6,-15,$0804 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":605..989
SpriteFrame_gwall_3:
	db $05,$80
	dw $000E
	dw -5,20,-27,1
	dw $0100,$00C0
	dw .tiles-SpriteFrame_gwall_3
	db $02,$00,$1A,$00
	dw -5,-27,$0800 : db $FF
	dw 11,-27,$0802 : db $FF
	dw -2,-11,$0804 : db $FF
	dw 14,-11,$0806 : db $00
	dw 14,-3,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":1046..1494
SpriteFrame_arrow_0:
	db $03,$80
	dw $0005
	dw -13,10,-7,16
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_0
	db $01,$02,$03,$04
	dw -13,-7,DMA_OAM : db $FF
	dw -5,-7,$4400 : db $FF
	dw -4,9,$0402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":1537..1697
SpriteFrame_arrow_1:
	db $06,$80
	dw $0009
	dw -16,4,-5,15
	dw $00A0,$0080
	dw .tiles-SpriteFrame_arrow_1
	db $01,$02,$03,$04
	dw -15,-5,DMA_OAM : db $FF
	dw 1,-5,$0402 : db $00
	dw 1,3,$0403 : db $00
	dw -16,11,$0412 : db $00
	dw -8,11,$0413 : db $00
	dw 2,11,$0404 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":1761..2049
SpriteFrame_arrow_2:
	db $04,$80
	dw $0005
	dw -18,5,-12,11
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_2
	db $01,$02,$03,$04
	dw -18,-12,DMA_OAM : db $FF
	dw -18,-4,$8400 : db $FF
	dw -2,-8,$0402 : db $00
	dw -2,0,$4402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":2099..2259
SpriteFrame_arrow_3:
	db $03,$80
	dw $0005
	dw -13,10,-7,16
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_3
	db $01,$02,$03,$04
	dw -13,-7,DMA_OAM : db $FF
	dw -5,-7,$4400 : db $FF
	dw -4,9,$0402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":2302..2462
SpriteFrame_arrow_4:
	db $06,$80
	dw $0009
	dw -16,4,-5,15
	dw $00A0,$0080
	dw .tiles-SpriteFrame_arrow_4
	db $01,$02,$03,$04
	dw -15,-5,DMA_OAM : db $FF
	dw 1,-5,$0402 : db $00
	dw 1,3,$0403 : db $00
	dw -16,11,$0412 : db $00
	dw -8,11,$0413 : db $00
	dw 2,11,$0404 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":2526..2814
SpriteFrame_arrow_5:
	db $04,$80
	dw $0005
	dw -18,5,-12,11
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_5
	db $01,$02,$03,$04
	dw -18,-12,DMA_OAM : db $FF
	dw -18,-4,$8400 : db $FF
	dw -2,-8,$0402 : db $00
	dw -2,0,$4402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":2864..3024
SpriteFrame_arrow_6:
	db $03,$80
	dw $0005
	dw -13,10,-7,16
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_6
	db $01,$02,$03,$04
	dw -13,-7,DMA_OAM : db $FF
	dw -5,-7,$4400 : db $FF
	dw -4,9,$0402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":3067..3227
SpriteFrame_arrow_7:
	db $06,$80
	dw $0009
	dw -16,4,-5,15
	dw $00A0,$0080
	dw .tiles-SpriteFrame_arrow_7
	db $01,$02,$03,$04
	dw -15,-5,DMA_OAM : db $FF
	dw 1,-5,$0402 : db $00
	dw 1,3,$0403 : db $00
	dw -16,11,$0412 : db $00
	dw -8,11,$0413 : db $00
	dw 2,11,$0404 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":3291..3579
SpriteFrame_arrow_8:
	db $04,$80
	dw $0005
	dw -18,5,-12,11
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_8
	db $01,$02,$03,$04
	dw -18,-12,DMA_OAM : db $FF
	dw -18,-4,$8400 : db $FF
	dw -2,-8,$0402 : db $00
	dw -2,0,$4402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":3629..3789
SpriteFrame_arrow_9:
	db $03,$80
	dw $0005
	dw -13,10,-7,16
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_9
	db $01,$02,$03,$04
	dw -13,-7,DMA_OAM : db $FF
	dw -5,-7,$4400 : db $FF
	dw -4,9,$0402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":3832..3992
SpriteFrame_arrow_10:
	db $06,$80
	dw $0009
	dw -16,4,-5,15
	dw $00A0,$0080
	dw .tiles-SpriteFrame_arrow_10
	db $01,$02,$03,$04
	dw -15,-5,DMA_OAM : db $FF
	dw 1,-5,$0402 : db $00
	dw 1,3,$0403 : db $00
	dw -16,11,$0412 : db $00
	dw -8,11,$0413 : db $00
	dw 2,11,$0404 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":4056..4344

SpriteFrame_arrow_11:
	db $04,$80
	dw $0005
	dw -18,5,-12,11
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_11
	db $01,$02,$03,$04
	dw -18,-12,DMA_OAM : db $FF
	dw -18,-4,$8400 : db $FF
	dw -2,-8,$0402 : db $00
	dw -2,0,$4402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":4394..4554
SpriteFrame_arrow_12:
	db $03,$80
	dw $0005
	dw -13,10,-7,16
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_12
	db $01,$02,$03,$04
	dw -13,-7,DMA_OAM : db $FF
	dw -5,-7,$4400 : db $FF
	dw -4,9,$0402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":4597..4757
SpriteFrame_arrow_13:
	db $06,$80
	dw $0009
	dw -16,4,-5,15
	dw $00A0,$0080
	dw .tiles-SpriteFrame_arrow_13
	db $01,$02,$03,$04
	dw -15,-5,DMA_OAM : db $FF
	dw 1,-5,$0402 : db $00
	dw 1,3,$0403 : db $00
	dw -16,11,$0412 : db $00
	dw -8,11,$0413 : db $00
	dw 2,11,$0404 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":4821..5109
SpriteFrame_arrow_14:
	db $04,$80
	dw $0005
	dw -18,5,-12,11
	dw $0060,$0040
	dw .tiles-SpriteFrame_arrow_14
	db $01,$02,$03,$04
	dw -18,-12,DMA_OAM : db $FF
	dw -18,-4,$8400 : db $FF
	dw -2,-8,$0402 : db $00
	dw -2,0,$4402 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":5159..5319
SpriteFrame_pad_0:
	db $02,$80
	dw $0004
	dw -13,12,-4,9
	dw $0040,$0040
	dw .tiles-SpriteFrame_pad_0
	db $01,$02,$03,$04
	dw -13,-4,$0000 : db $FF
	dw -3,-4,$4000 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":5355..5483
SpriteFrame_pad_1:
	db $02,$80
	dw $0004
	dw -16,15,-5,10
	dw $0040,$0040
	dw .tiles-SpriteFrame_pad_1
	db $01,$02,$03,$04
	dw -16,-5,DMA_OAM : db $FF
	dw 0,-5,$4400 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":5519..5647
SpriteFrame_pad_2:
	db $02,$80
	dw $0004
	dw -16,15,-5,10
	dw $0040,$0040
	dw .tiles-SpriteFrame_pad_2
	db $01,$02,$03,$04
	dw -16,-5,DMA_OAM : db $FF
	dw 0,-5,$4400 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":5683..5811
SpriteFrame_pad_3:
	db $02,$80
	dw $0004
	dw -16,15,-5,10
	dw $0040,$0040
	dw .tiles-SpriteFrame_pad_3
	db $01,$02,$03,$04
	dw -16,-5,DMA_OAM : db $FF
	dw 0,-5,$4400 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":5847..5975
SpriteFrame_pad_4:
	db $02,$80
	dw $0004
	dw -16,15,-5,10
	dw $0040,$0040
	dw .tiles-SpriteFrame_pad_4
	db $01,$02,$03,$04
	dw -16,-5,DMA_OAM : db $FF
	dw 0,-5,$4400 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6011..6139
SpriteFrame_pad_5:
	db $02,$80
	dw $0004
	dw -16,15,-5,10
	dw $0040,$0040
	dw .tiles-SpriteFrame_pad_5
	db $01,$02,$03,$04
	dw -16,-5,DMA_OAM : db $FF
	dw 0,-5,$4400 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6175..6303
SpriteFrame_replay_0:
	db $04,$00
	dw $0002
	dw -16,15,-6,5
	dw $0040,$0000
	dw .tiles-SpriteFrame_replay_0
	db $01,$01,$03,$03
	dw -16,-6,DMA_OAM : db $00
	dw -16,2,$0401 : db $00
	dw 8,-6,$4400 : db $00
	dw 8,2,$4401 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6353..6417
SpriteFrame_puck_0:
	db $01,$00
	dw $0001
	dw -4,2,-2,0
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_0
	db $01,$02,$03,$04
	dw -4,-2,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6446..6478
SpriteFrame_puck_1:
	db $01,$00
	dw $0001
	dw -3,2,-2,0
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_1
	db $01,$02,$03,$04
	dw -3,-2,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6507..6539
SpriteFrame_puck_2:
	db $01,$00
	dw $0001
	dw -3,1,-3,1
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_2
	db $01,$02,$03,$04
	dw -3,-3,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6568..6600
SpriteFrame_puck_3:
	db $01,$00
	dw $0001
	dw -1,0,-3,2
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_3
	db $01,$02,$03,$04
	dw -1,-3,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6629..6661
SpriteFrame_puck_4:
	db $01,$00
	dw $0001
	dw -2,2,-3,1
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_4
	db $01,$02,$03,$04
	dw -2,-3,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6690..6722
SpriteFrame_puck_5:
	db $01,$00
	dw $0001
	dw -3,2,-2,0
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_5
	db $01,$02,$03,$04
	dw -3,-2,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6751..6783
SpriteFrame_puck_6:
	db $01,$00
	dw $0001
	dw -3,1,-3,1
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_6
	db $01,$02,$03,$04
	dw -3,-3,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6812..6844
SpriteFrame_puck_7:
	db $01,$00
	dw $0001
	dw -2,2,-3,1
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_7
	db $01,$02,$03,$04
	dw -2,-3,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6873..6905
SpriteFrame_puck_8:
	db $01,$00
	dw $0001
	dw -3,2,-1,0
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_8
	db $01,$02,$03,$04
	dw -3,-1,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6934..6966
SpriteFrame_puck_9:
	db $01,$00
	dw $0001
	dw -3,2,-3,1
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_9
	db $01,$02,$03,$04
	dw -3,-3,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":6995..7027
SpriteFrame_puck_10:
	db $01,$00
	dw $0001
	dw -3,2,-3,1
	dw $0020,$0000
	dw .tiles-SpriteFrame_puck_10
	db $01,$02,$03,$04
	dw -3,-3,$0000 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":7056..7088
SpriteFrame_goal_0:
	db $07,$80
	dw $000A
	dw -24,24,-23,5
	dw $00C0,$0080
	dw .tiles-SpriteFrame_goal_0
	db $00,$FE,$04,$04
	dw -22,-23,$0000 : db $FF
	dw 7,-23,$4000 : db $FF
	dw -9,-23,$0002 : db $FF
	dw -24,-7,$0004 : db $00
	dw -24,1,$0005 : db $00
	dw 17,-7,$4004 : db $00
	dw 17,1,$4005 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":7159..7479
SpriteFrame_goal_1:
	db $06,$80
	dw $0010
	dw -23,23,-24,6
	dw $0100,$0100
	dw .tiles-SpriteFrame_goal_1
	db $00,$00,$04,$05
	dw -20,-24,$0000 : db $FF
	dw 5,-24,$4000 : db $FF
	dw -11,-24,$0002 : db $FF
	dw -23,-8,$0004 : db $FF
	dw 8,-8,$4004 : db $FF
	dw -8,-8,$0006 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":7543..8055
SpriteFrame_Siren_0:
	db $02,$00
	dw $0002
	dw -7,3,-4,3
	dw $0040,$0000
	dw .tiles-SpriteFrame_Siren_0
	db $00,$00,$00,$00
	dw -7,-4,$0000 : db $00
	dw 1,-4,$0001 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":8091..8155
SpriteFrame_Siren_1:
	db $01,$80
	dw $0004
	dw -9,3,-5,5
	dw $0040,$0040
	dw .tiles-SpriteFrame_Siren_1
	db $00,$00,$00,$00
	dw -9,-5,$0000 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":8184..8312

SpriteFrame_Siren_2:
	db $01,$80
	dw $0004
	dw -8,4,-6,6
	dw $0040,$0040
	dw .tiles-SpriteFrame_Siren_2
	db $00,$00,$00,$00
	dw -8,-6,$0000 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":8341..8469
SpriteFrame_Siren_3:
	db $04,$80
	dw $0005
	dw -11,8,-10,10
	dw $0060,$0040
	dw .tiles-SpriteFrame_Siren_3
	db $00,$00,$00,$00
	dw -11,-10,$0000 : db $FF
	dw -7,-10,$4000 : db $FF
	dw -9,6,$0002 : db $00
	dw -1,6,$4002 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":8519..8679
SpriteFrame_Siren_4:
	db $01,$80
	dw $0004
	dw -6,6,-6,6
	dw $0040,$0040
	dw .tiles-SpriteFrame_Siren_4
	db $00,$00,$00,$00
	dw -6,-6,$0000 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":8708..8836
SpriteFrame_Siren_5:
	db $01,$80
	dw $0004
	dw -5,7,-5,5
	dw $0040,$0040
	dw .tiles-SpriteFrame_Siren_5
	db $00,$00,$00,$00
	dw -5,-5,$0000 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":8865..8993
SpriteFrame_Siren_6:
	db $02,$00
	dw $0002
	dw -5,5,-4,3
	dw $0040,$0000
	dw .tiles-SpriteFrame_Siren_6
	db $00,$00,$00,$00
	dw -5,-4,$0000 : db $00
	dw 3,-4,$0001 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":9029..9093
SpriteFrame_Siren_7:
	db $03,$80
	dw $0006
	dw -5,20,-16,3
	dw $0080,$0040
	dw .tiles-SpriteFrame_Siren_7
	db $00,$00,$00,$00
	dw -5,-9,$0000 : db $FF
	dw 11,-16,$0002 : db $00
	dw 19,-16,$0003 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":9136..9328
SpriteFrame_Siren_8:
	db $03,$80
	dw $0006
	dw -5,11,-19,3
	dw $0080,$0040
	dw .tiles-SpriteFrame_Siren_8
	db $00,$00,$00,$00
	dw -3,-19,$0000 : db $FF
	dw -5,-3,$0002 : db $00
	dw 3,-3,$0003 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":9371..9563
SpriteFrame_Siren_9:
	db $03,$80
	dw $0006
	dw -5,7,-18,3
	dw $0080,$0040
	dw .tiles-SpriteFrame_Siren_9
	db $00,$00,$00,$00
	dw -4,-18,$0000 : db $FF
	dw -5,-2,$0002 : db $00
	dw 3,-2,$0003 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":9606..9798
SpriteFrame_Siren_10:
	db $02,$80
	dw $0005
	dw -5,3,-20,3
	dw $0060,$0040
	dw .tiles-SpriteFrame_Siren_10
	db $00,$00,$00,$00
	dw -5,-12,$0000 : db $FF
	dw -5,-20,$0002 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":9834..9994
SpriteFrame_Siren_11:
	db $03,$80
	dw $0006
	dw -8,3,-18,3
	dw $0080,$0040
	dw .tiles-SpriteFrame_Siren_11
	db $00,$00,$00,$00
	dw -8,-18,$0000 : db $FF
	dw -5,-2,$0002 : db $00
	dw 3,-2,$0003 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":10037..10229
SpriteFrame_Siren_12:
	db $03,$80
	dw $0006
	dw -13,3,-19,3
	dw $0080,$0040
	dw .tiles-SpriteFrame_Siren_12
	db $00,$00,$00,$00
	dw -13,-19,$0000 : db $FF
	dw -5,-3,$0002 : db $00
	dw 3,-3,$0003 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":10272..10464
SpriteFrame_Siren_13:
	db $04,$00
	dw $0004
	dw -22,3,-16,3
	dw $0080,$0000
	dw .tiles-SpriteFrame_Siren_13
	db $00,$00,$00,$00
	dw -22,-16,$0000 : db $00
	dw -14,-16,$0001 : db $00
	dw -6,-4,$0002 : db $00
	dw 2,-4,$0003 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":10514..10642
SpriteFrame_faceoff_0:
	db $0A,$80
	dw $0016
	dw -40,5,-44,3
	dw $0180,$0140
	dw .tiles-SpriteFrame_faceoff_0
	db $01,$02,$03,$04
	dw -32,-44,$0800 : db $FF
	dw -34,-28,$0802 : db $FF
	dw -40,-12,$0804 : db $FF
	dw -24,-12,$0806 : db $FF
	dw -16,-44,$0808 : db $00
	dw -16,-36,$0809 : db $00
	dw -18,-28,$0818 : db $00
	dw -18,-20,$0819 : db $00
	dw -8,-4,$080A : db $00
	dw 0,-4,$080B : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":10734..11438
SpriteFrame_faceoff_1:
	db $09,$80
	dw $001B
	dw -42,12,-42,3
	dw $01C0,$01A0
	dw .tiles-SpriteFrame_faceoff_1
	db $01,$02,$03,$04
	dw -29,-42,$0800 : db $FF
	dw -35,-26,$0802 : db $FF
	dw -19,-26,$0804 : db $FF
	dw -42,-10,$0806 : db $FF
	dw -26,-10,$0808 : db $FF
	dw -10,-10,$080A : db $FF
	dw -13,-42,$080C : db $00
	dw -13,-34,$080D : db $00
	dw 6,-2,$081C : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":11523..12387

SpriteFrame_faceoff_2:
	db $0A,$80
	dw $001C
	dw -46,7,-42,3
	dw $01C0,$01C0
	dw .tiles-SpriteFrame_faceoff_2
	db $01,$02,$04,$04
	dw -30,-42,$0800 : db $FF
	dw -37,-26,$0802 : db $FF
	dw -21,-26,$0804 : db $FF
	dw -46,-10,$0806 : db $FF
	dw -30,-10,$0808 : db $FF
	dw -14,-10,$080A : db $FF
	dw -14,-42,$080C : db $00
	dw -14,-34,$080D : db $00
	dw 2,-10,$081C : db $00
	dw 2,-2,$081D : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":12479..13375
SpriteFrame_faceoff_3:
	db $07,$80
	dw $001C
	dw -41,2,-42,1
	dw $01C0,$01C0
	dw .tiles-SpriteFrame_faceoff_3
	db $E4,$01,$E6,$03
	dw -36,-42,$0800 : db $FF
	dw -20,-42,$0802 : db $FF
	dw -37,-26,$0804 : db $FF
	dw -21,-26,$0806 : db $FF
	dw -41,-10,$0808 : db $FF
	dw -25,-10,$080A : db $FF
	dw -9,-10,$080C : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":13446..14342
SpriteFrame_faceoff_4:
	db $0A,$80
	dw $001C
	dw -44,13,-37,2
	dw $01C0,$01C0
	dw .tiles-SpriteFrame_faceoff_4
	db $E4,$01,$E8,$03
	dw -44,-13,$0800 : db $FF
	dw -28,-13,$0802 : db $FF
	dw -12,-13,$0804 : db $FF
	dw 4,-13,$0806 : db $FF
	dw -36,-29,$0808 : db $FF
	dw -20,-29,$080A : db $FF
	dw -32,-37,$080C : db $00
	dw -24,-37,$080D : db $00
	dw -16,-37,$081C : db $00
	dw -8,-37,$081D : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":14434..15330
SpriteFrame_faceoff_5:
	db $08,$80
	dw $001D
	dw -42,10,-38,2
	dw $01E0,$01C0
	dw .tiles-SpriteFrame_faceoff_5
	db $E5,$01,$E7,$03
	dw -42,-13,$0800 : db $FF
	dw -26,-13,$0802 : db $FF
	dw -10,-13,$0804 : db $FF
	dw -36,-29,$0806 : db $FF
	dw -20,-29,$0808 : db $FF
	dw -32,-45,$080A : db $FF
	dw -16,-45,$080C : db $FF
	dw 6,-5,$080E : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":15408..16336
SpriteFrame_faceoff_6:
	db $04,$80
	dw $000A
	dw -3,18,-63,-32
	dw $00C0,$0080
	dw .tiles-SpriteFrame_faceoff_6
	db $01,$02,$03,$04
	dw 3,-63,$0200 : db $FF
	dw 3,-47,$0202 : db $FF
	dw -5,-58,$0204 : db $00
	dw -5,-50,$0205 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":16386..16706

SpriteFrame_faceoff_7:
	db $04,$80
	dw $000D
	dw -4,25,-63,-35
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_faceoff_7
	db $01,$02,$03,$04
	dw -4,-63,$0200 : db $FF
	dw -1,-47,$0202 : db $FF
	dw 15,-47,$0204 : db $FF
	dw 12,-55,$0206 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":16756..17172
SpriteFrame_faceoff_8:
	db $07,$80
	dw $0010
	dw -6,25,-63,2
	dw $0100,$0100
	dw .tiles-SpriteFrame_faceoff_8
	db $01,$02,$03,$04
	dw 1,-45,$0200 : db $FF
	dw 0,-61,$0202 : db $FF
	dw 16,-61,$0204 : db $FF
	dw -5,-5,$0006 : db $00
	dw -6,-29,$0007 : db $00
	dw -6,-21,$0016 : db $00
	dw 5,-69,$0217 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":17243..17755
SpriteFrame_faceoff_9:
	db $05,$80
	dw $000E
	dw -5,25,-63,2
	dw $0100,$00C0
	dw .tiles-SpriteFrame_faceoff_9
	db $01,$02,$03,$04
	dw 1,-45,$0200 : db $FF
	dw 0,-61,$0202 : db $FF
	dw 16,-61,$0204 : db $FF
	dw -5,-5,$0006 : db $00
	dw 5,-69,$0207 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":17812..18260
SpriteFrame_smallfont_0:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_0
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18289..18321
SpriteFrame_smallfont_1:
	db $01,$00
	dw $0001
	dw 2,5,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_1
	db $01,$02,$03,$04
	dw 2,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18350..18382
SpriteFrame_smallfont_2:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_2
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18411..18443
SpriteFrame_smallfont_3:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_3
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18472..18504
SpriteFrame_smallfont_4:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_4
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18533..18565
SpriteFrame_smallfont_5:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_5
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18594..18626
SpriteFrame_smallfont_6:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_6
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18655..18687
SpriteFrame_smallfont_7:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_7
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18716..18748
SpriteFrame_smallfont_8:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_8
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18777..18809
SpriteFrame_smallfont_9:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_9
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18838..18870
SpriteFrame_smallfont_10:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_10
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18899..18931
SpriteFrame_smallfont_11:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_11
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":18960..18992
SpriteFrame_smallfont_12:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_12
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":19021..19053
SpriteFrame_smallfont_13:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_13
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":19082..19114
SpriteFrame_smallfont_14:
	db $01,$00
	dw $0001
	dw 0,6,0,6
	dw $0020,$0000
	dw .tiles-SpriteFrame_smallfont_14
	db $01,$02,$03,$04
	dw 0,0,$0200 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":19143..19175
SpriteFrame_zamboni_0:
	db $11,$80
	dw $003E
	dw -48,37,-38,5
	dw $0600,$01C0
	dw .tiles-SpriteFrame_zamboni_0
	db $01,$02,$03,$04
	dw -42,-38,$0200 : db $FF
	dw -26,-38,$0202 : db $FF
	dw -10,-38,$0204 : db $FF
	dw 6,-38,$0206 : db $FF
	dw 22,-38,$0208 : db $FF
	dw -40,-22,$020A : db $FF
	dw -24,-22,$020C : db $FF
	dw -8,-22,$020E : db $FF
	dw 8,-22,$0220 : db $FF
	dw 24,-22,$0222 : db $FF
	dw -48,-6,$0224 : db $FF
	dw -32,-6,$0226 : db $FF
	dw -16,-6,$0228 : db $FF
	dw 0,-6,$022A : db $FF
	dw 16,-6,$022C : db $FF
	dw 32,-6,$022E : db $00
	dw 32,2,$022F : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":19316..21300

SpriteFrame_flip_0:
	db $07,$80
	dw $0013
	dw -14,12,-22,14
	dw $0140,$0120
	dw .tiles-SpriteFrame_flip_0
	db $F2,$FB,$03,$09
	dw -14,-22,$0800 : db $FF
	dw 2,-22,$0802 : db $FF
	dw -14,-6,$0804 : db $FF
	dw 2,-6,$0806 : db $FF
	dw -6,10,$0808 : db $00
	dw 2,10,$0809 : db $00
	dw 11,10,$0818 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":21371..21979
SpriteFrame_flip_1:
	db $05,$80
	dw $000E
	dw -14,14,-20,9
	dw $0100,$00C0
	dw .tiles-SpriteFrame_flip_1
	db $F5,$01,$02,$07
	dw -13,-20,$0800 : db $FF
	dw 3,-20,$0802 : db $FF
	dw -14,-4,$0804 : db $FF
	dw 2,-4,$0806 : db $00
	dw 2,4,$0807 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":22036..22484
SpriteFrame_flip_2:
	db $05,$80
	dw $0014
	dw -17,13,-28,12
	dw $0140,$0140
	dw .tiles-SpriteFrame_flip_2
	db $F1,$FF,$01,$04
	dw -16,-3,$0800 : db $FF
	dw 0,-3,$0802 : db $FF
	dw -17,-19,$0804 : db $FF
	dw -1,-19,$0806 : db $FF
	dw -8,-35,$0808 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":22541..23181
SpriteFrame_flip_3:
	db $06,$80
	dw $000F
	dw -12,16,-20,15
	dw $0100,$00E0
	dw .tiles-SpriteFrame_flip_3
	db $F7,$04,$01,$0A
	dw -12,-20,$0800 : db $FF
	dw -12,-4,$0802 : db $FF
	dw 4,-4,$0804 : db $FF
	dw 4,-20,$0806 : db $00
	dw 4,-12,$0807 : db $00
	dw -2,12,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":23245..23725
SpriteFrame_flip_4:
	db $04,$80
	dw $000A
	dw -10,11,-16,14
	dw $00C0,$0080
	dw .tiles-SpriteFrame_flip_4
	db $FD,$0B,$02,$00
	dw -10,-16,$0800 : db $FF
	dw -7,0,$0802 : db $FF
	dw 6,-16,$0804 : db $00
	dw 6,-8,$0805 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":23775..24095
SpriteFrame_flip_5:
	db $05,$80
	dw $0011
	dw -17,12,-21,11
	dw $0120,$0100
	dw .tiles-SpriteFrame_flip_5
	db $08,$0A,$02,$09
	dw -17,-21,$0800 : db $FF
	dw -1,-21,$0802 : db $FF
	dw -15,-5,$0804 : db $FF
	dw 1,-5,$0806 : db $FF
	dw 3,11,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":24152..24696

SpriteFrame_flip_6:
	db $06,$80
	dw $0012
	dw -13,16,-26,8
	dw $0140,$0100
	dw .tiles-SpriteFrame_flip_6
	db $0D,$FD,$02,$03
	dw -13,-26,$0800 : db $FF
	dw 3,-26,$0802 : db $FF
	dw -13,-10,$0804 : db $FF
	dw 3,-10,$0806 : db $FF
	dw -6,6,$0808 : db $00
	dw 2,6,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":24760..25336
SpriteFrame_flip_7:
	db $07,$80
	dw $0013
	dw -15,14,-26,16
	dw $0140,$0120
	dw .tiles-SpriteFrame_flip_7
	db $F4,$EB,$01,$04
	dw -15,-26,$0800 : db $FF
	dw -13,-10,$0802 : db $FF
	dw 3,-10,$0804 : db $FF
	dw -7,6,$0806 : db $FF
	dw 1,-18,$0808 : db $00
	dw 9,6,$0809 : db $00
	dw 9,14,$0818 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":25407..26015
SpriteFrame_stumble_0:
	db $07,$80
	dw $000D
	dw -12,10,-25,8
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_stumble_0
	db $07,$FA,$04,$08
	dw -12,-25,$0800 : db $FF
	dw -12,-9,$0802 : db $FF
	dw 4,-25,$0804 : db $00
	dw 4,-17,$0805 : db $00
	dw 4,-9,$0814 : db $00
	dw 4,-1,$0815 : db $00
	dw 2,7,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":26086..26502
SpriteFrame_stumble_1:
	db $06,$80
	dw $000F
	dw -13,14,-29,7
	dw $0100,$00E0
	dw .tiles-SpriteFrame_stumble_1
	db $06,$F8,$06,$06
	dw -8,-29,$0800 : db $FF
	dw -13,-13,$0802 : db $FF
	dw 3,-13,$0804 : db $FF
	dw 8,-29,$0806 : db $00
	dw 8,-21,$0807 : db $00
	dw -7,3,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":26566..27046
SpriteFrame_stumble_2:
	db $06,$80
	dw $000C
	dw -11,11,-26,6
	dw $00C0,$00C0
	dw .tiles-SpriteFrame_stumble_2
	db $0A,$F4,$03,$08
	dw -11,-23,$0800 : db $FF
	dw -11,-7,$0802 : db $FF
	dw 5,-26,$0804 : db $00
	dw 5,-18,$0805 : db $00
	dw 5,-10,$0814 : db $00
	dw 5,-2,$0815 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":27110..27494
SpriteFrame_stumble_3:
	db $04,$80
	dw $000D
	dw -10,23,-26,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_stumble_3
	db $15,$FB,$02,$06
	dw -8,-26,$0800 : db $FF
	dw 8,-26,$0802 : db $FF
	dw -10,-10,$0804 : db $FF
	dw 6,-10,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":27544..27960
SpriteFrame_stumble_4:
	db $04,$80
	dw $000D
	dw -13,12,-34,5
	dw $00E0,$00C0
	dw .tiles-SpriteFrame_stumble_4
	db $0B,$F6,$04,$04
	dw -4,-10,$0800 : db $FF
	dw -13,-26,$0802 : db $FF
	dw 3,-26,$0804 : db $FF
	dw 7,-34,$0806 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":28010..28426
SpriteFrame_stumble_5:
	db $06,$80
	dw $0012
	dw -15,19,-27,3
	dw $0140,$0100
	dw .tiles-SpriteFrame_stumble_5
	db $10,$F5,$03,$04
	dw -15,-27,$0800 : db $FF
	dw 1,-27,$0802 : db $FF
	dw -9,-11,$0804 : db $FF
	dw 7,-11,$0806 : db $FF
	dw 17,-27,$0808 : db $00
	dw 17,-19,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":28490..29066

SpriteFrame_stumble_6:
	db $04,$80
	dw $0010
	dw -11,23,-26,3
	dw $0100,$0100
	dw .tiles-SpriteFrame_stumble_6
	db $16,$FB,$09,$05
	dw -2,-26,$0800 : db $FF
	dw 14,-26,$0802 : db $FF
	dw -11,-10,$0804 : db $FF
	dw 5,-10,$0806 : db $FF
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":29116..29628
SpriteFrame_stumble_7:
	db $07,$80
	dw $0010
	dw -11,16,-31,4
	dw $0100,$0100
	dw .tiles-SpriteFrame_stumble_7
	db $0D,$FD,$00,$05
	dw -8,-31,$0800 : db $FF
	dw -11,-15,$0802 : db $FF
	dw 5,-15,$0804 : db $FF
	dw 8,-31,$0806 : db $00
	dw 8,-23,$0807 : db $00
	dw -5,1,$0816 : db $00
	dw 3,1,$0817 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":29699..30211
SpriteFrame_stumble_8:
	db $06,$80
	dw $0012
	dw -9,17,-30,10
	dw $0140,$0100
	dw .tiles-SpriteFrame_stumble_8
	db $10,$08,$01,$05
	dw -9,-30,$0800 : db $FF
	dw -9,-14,$0802 : db $FF
	dw 7,-22,$0804 : db $FF
	dw 7,0,$0806 : db $FF
	dw -9,2,$0808 : db $00
	dw -1,2,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":30275..30851
SpriteFrame_stumble_9:
	db $06,$80
	dw $000F
	dw -10,21,-26,7
	dw $0100,$00E0
	dw .tiles-SpriteFrame_stumble_9
	db $14,$06,$05,$04
	dw -3,-26,$0800 : db $FF
	dw -10,-10,$0802 : db $FF
	dw 6,-10,$0804 : db $FF
	dw 13,-26,$0806 : db $00
	dw 13,-18,$0807 : db $00
	dw 12,6,$0816 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":30915..31395
SpriteFrame_stumble_10:
	db $06,$80
	dw $0012
	dw -17,10,-28,5
	dw $0140,$0100
	dw .tiles-SpriteFrame_stumble_10
	db $06,$09,$00,$06
	dw -17,-28,$0800 : db $FF
	dw -1,-28,$0802 : db $FF
	dw -17,-12,$0804 : db $FF
	dw -1,-12,$0806 : db $FF
	dw -10,4,$0808 : db $00
	dw -2,4,$0809 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":31459..32035
SpriteFrame_stumble_11:
	db $08,$80
	dw $0011
	dw -17,15,-27,7
	dw $0120,$0100
	dw .tiles-SpriteFrame_stumble_11
	db $FF,$0C,$05,$05
	dw -17,-27,$0800 : db $FF
	dw -1,-27,$0802 : db $FF
	dw -14,-11,$0804 : db $FF
	dw 15,-19,$0806 : db $00
	dw 2,-11,$0807 : db $00
	dw 2,-3,$0816 : db $00
	dw 0,5,$0817 : db $00
	dw 8,5,$0808 : db $00
.tiles:
	incbin "../../../Extracted/data/gfx/SpriteFrames87.bin":32113..32657
