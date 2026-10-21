; The penalties and stoppages by penalty number: a word offset to each entry, then the entries (name and data)
Penaltylist:
	dw $0000
	dw PenDataEOP-Penaltylist		;$2 period over
	dw PenDataEOG-Penaltylist		;$4 game over
	dw PenDataGhold-Penaltylist		;$6 face off
	dw PenDataGhold-Penaltylist		;$8 face off
	dw PenDatawhistle-Penaltylist	;$A whistle
	dw PenDataice-Penaltylist		;$C icing
	dw PenDataGoal-Penaltylist		;$E goal
	dw PenDataNoText-Penaltylist	;$10 no text
	dw PenDataoffsides-Penaltylist	;$12 offsides
	dw PenDatarough2-Penaltylist	;$14 roughing, slow down time $0A
	dw PenDataNoText2-Penaltylist	;$16 no text
	dw PenDatacharge-Penaltylist	;$18
	dw PenDataslash-Penaltylist		;$1A
	dw PenDatarough-Penaltylist		;$1C
	dw PenDatacross-Penaltylist		;$1E
	dw PenDatahook-Penaltylist		;$20
	dw PenDatatrip-Penaltylist		;$22
	dw PenDataShot-Penaltylist		;$24 penalty shot
	dw PenDataint-Penaltylist		;$26
	dw PenDataHold-Penaltylist		;$28
	dw PenDatafight-Penaltylist		;$2A
	dw PenDatafight2-Penaltylist	;$2C
	dw PenDataInst-Penaltylist		;$2E
	dw PenDatadelay-Penaltylist		;$30 delay
	dw PenDataNoText3-Penaltylist	;$32 no text
	dw $0000
PenDataEOP:
	db $00,$01,$0D,$00,"Period Over",$10,$05,$F0,$BF
PenDataEOG:
	db $00,$01,$0B,$00,"Game Over",$10,$05,$D0,$BF
PenDataGoal:
	db $00,$01,$02,$00,$0A,$05,$E0,$BF
PenDataNoText:
	db $00,$01,$02,$00,$10,$05,$F0,$BF
PenDataNoText2:
	db $00,$01,$02,$00,$10,$05,$FA,$BF
PenDataNoText3:
	db $00,$01,$02,$00,$10,$05,$D0,$BF
PenDataice:
	db $00,$01,$07,$00,"Icing",$02,$00,$01,$01,$0F,$02,$FA,$BF
PenDataoffsides:
	db $00,$01,$0A,$00,"Off-side",$02,$00,$01,$03,$0F,$04,$FA,$BF
PenDataGhold:
	db $00,$01,$0A,$00,"Face Off",$0A,$05,$F8,$BF
PenDatadelay:
	db $00,$00,$09,$00,"Penalty",$03,$00,$01,$03,$1F,$04,$FA,$BF
PenDataShot:
	db $01,$01,$0E,$00,"Penalty Shot",$10,$05,$FA,$BF
PenDatawhistle:
	db $00,$00,$02,$00,$F6,$FA
PenDatacharge:
	db $02,$04,$0A,$00,"Charging",$04,$00,$01,$01,$01,$0A,$01,$0B,$01,$0A,$01,$0B,$01,$0A,$01,$0B,$01,$0A,$01,$0B,$FF,$FE
PenDataslash:
	db $02,$04,$0A,$00,"Slashing",$04,$00,$01,$01,$01,$02,$01,$03,$01,$02,$01,$03,$01,$02,$01,$03,$01,$02,$01,$03,$FF,$FE
PenDatatrip:
	db $02,$04,$0A,$00,"Tripping",$04,$00,$01,$04,$01,$05,$01,$04,$01,$05,$01,$04,$01,$05,$01,$04,$01,$05,$FF,$FE
PenDatarough2:
	db $02,$0A,$0A,$00,"Roughing",$04,$00,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE
PenDatarough:
	db $02,$04,$0A,$00,"Roughing",$04,$00,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE
PenDatahook:
	db $02,$04,$09,$00,"Hooking",$04,$00,$01,$01,$01,$09,$01,$08,$01,$09,$01,$08,$01,$09,$01,$08,$01,$09,$01,$08,$FF,$FE
PenDatacross:
	db $02,$04,$0D,$00,"Cross Check",$04,$00,$01,$06,$01,$0F,$01,$10,$01,$0F,$01,$10,$01,$0F,$01,$10,$01,$0F,$01,$10,$FF,$FE
PenDataint:
	db $02,$04,$0E,$00,"Interference",$04,$00,$01,$01,$06,$0C,$FF,$FE
PenDataHold:
	db $02,$04,$09,$00,"Holding",$04,$00,$01,$01,$06,$07,$FF,$FE
PenDatafight:
	db $05,$28,$0A,$00,"Fighting",$04,$00,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE
PenDatafight2:
	db $05,$28,$0C,$00,"Fighting *",$04,$00,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE
PenDataInst:
	db $02,$28,$12,$00,"Fight Instigator",$04,$00,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$01,$0D,$01,$0E,$FF,$FE
