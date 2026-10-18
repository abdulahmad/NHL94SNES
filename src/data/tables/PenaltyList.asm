; The penalties and stoppages by penalty number: a word offset to each entry, then the entries (name and data)
PenaltyList:
	dw $0000
	dw PenDataEOP-PenaltyList		;$2 period over
	dw PenDataEOG-PenaltyList		;$4 game over
	dw PenDataGhold-PenaltyList		;$6 face off
	dw PenDataGhold-PenaltyList		;$8 face off
	dw PenDatawhistle-PenaltyList	;$A whistle
	dw PenDataice-PenaltyList		;$C icing
	dw PenDataGoal-PenaltyList		;$E goal
	dw PenDataNoText-PenaltyList	;$10 no text
	dw PenDataoffsides-PenaltyList	;$12 offsides
	dw PenDatarough2-PenaltyList	;$14 roughing, slow down time $0A
	dw PenDataNoText2-PenaltyList	;$16 no text
	dw PenDatacharge-PenaltyList	;$18
	dw PenDataslash-PenaltyList		;$1A
	dw PenDatarough-PenaltyList		;$1C
	dw PenDatacross-PenaltyList		;$1E
	dw PenDatahook-PenaltyList		;$20
	dw PenDatatrip-PenaltyList		;$22
	dw PenDataShot-PenaltyList		;$24 penalty shot
	dw PenDataint-PenaltyList		;$26
	dw PenDataHold-PenaltyList		;$28
	dw PenDatafight-PenaltyList		;$2A
	dw PenDatafight2-PenaltyList	;$2C
	dw PenDataInst-PenaltyList		;$2E
	dw PenDatadelay-PenaltyList		;$30 delay
	dw PenDataNoText3-PenaltyList	;$32 no text
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
