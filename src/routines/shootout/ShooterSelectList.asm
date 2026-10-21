; Shootout shooters: the select-player list
ShooterSelectList:					; called from PickShooterRow
	jsl.l SpriteFrameStart
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ShooterSelectListPos>>16
	sta.b a1+2
	lda.w #ShooterSelectListPos
	sta.b a1
	jsl.l print
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0020
	sta.b d0
	lda.w #$000D
	sta.b d1
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.w #PlayerListMap>>16
	sta.b p0+2
	lda.w #PlayerListMap
	sta.b p0
	lda.w #unpackbuf>>16
	sta.b p1+2
	lda.w #unpackbuf
	sta.b p1
	jsl.l Decompress
	lda.w #unpackbuf>>16
	sta.b p0+2
	lda.w #unpackbuf
	sta.b p0
	lda.w #textmap2>>16
	sta.b p1+2
	lda.w #textmap2
	sta.b p1
	ldx.w #$0001
	ldy.w #$0001
	lda.l charofs2
	clc
	adc.w #$0C00
	jsl.l PasteMap
	jsl.l SendTextMapRows
	jsl.l SendTextMap2Rows
	jsl.l SpriteFrameEnd
	jsl.l WaitFrame
	lda.w #$0007
	sta.w irqline2
	jsl.l GetPlayerCount
	lda.b d0
	sta.w listcount
	jsl.l GoalieCount
	lda.w listcount
	sec
	sbc.b d0
	sta.w listcount
	lda.b d0
	sta.w pickfirst
	lda.b d0
	sta.w picktop
	lda.w #$0000
	sta.b a3+2
	lda.w #homeshooters
	sta.b a3
	lda.b a2
	beq .list
	lda.w #$0000
	sta.b a3+2
	lda.w #awayshooters
	sta.b a3
.list:								; a3 = a3 + curitem, curplayer = [a3] & $00FF - 1, if plus go to .t1, ...
	lda.b a3
	clc
	adc.w curitem
	sta.b a3
	lda.b [a3]
	and.w #$00FF
	dec a
	sta.w curplayer
	lda.w #$0008
	clc
	adc.w picktop
	sec
	sbc.w curplayer
	bpl .t1
	lda.w curplayer
	sec
	sbc.w #$0008
	sec
	sbc.w picktop
	bmi .zero
	clc
	adc.w picktop
	sta.w picktop
.zero:								; go to .1
	lda.w #$0000
	bra .1

.t1:								; falls through
	lda.w picktop
	clc
	adc.w #$0008
	sec
	sbc.w curplayer
.1:									; curplayer = A, call PrintShooterList
	sta.w curplayer
	jsl.l PrintShooterList
.2:									; loop: call SendTextMap, call SendTextMap2, call WaitFrame, ...
	jsl.l SendTextMap
	jsl.l SendTextMap2
	jsl.l WaitFrame
	jsl.l ReadPads
	jsl.l ReadPausePad
	jsl.l ProcessInputWithRepeat
	lda.b d1
	bit.w #$1000
	bne .1x
	bit.w #$0800
	bne .t4
	bit.w #$0400
	bne .t3
	bit.w #$0100
	bne .t1x
	bit.w #$0200
	bne .t2
	bit.w #$8080
	beq .2
	jsl.l SetShooter
.1x:								; drawlinesback = $0001, return
	lda.w #$0001
	sta.l drawlinesback
	rtl

.t1x:								; if plus go to .2, ...
	lda.w DispAttribCtr
	inc a
	cmp.w #$0010
	bpl .2
	sta.w DispAttribCtr
	jsl.l PrintShooterList
	bra .2

.t2:								; if a counted below 0 go to .2, ...
	lda.w DispAttribCtr
	dec a
	bmi .2
	sta.w DispAttribCtr
	jsl.l PrintShooterList
	jmp.w .2

.t3:								; if a counted below 0 go to .t5, ...
	lda.w curplayer
	dec a
	bmi .t5
	sta.w curplayer
	jsl.l PrintShooterList
	jmp.w .2

.t4:								; if plus go to .t6, ...
	lda.w curplayer
	inc a
	cmp.w #$0009
	bpl .t6
	sta.w curplayer
	jsl.l PrintShooterList
	jmp.w .2

.t5:								; a counted below 0: if minus go to .t1xx, ...
	lda.w picktop
	sec
	sbc.w pickfirst
	clc
	adc.w #$0009
	cmp.w listcount
	bmi .t1xx
	jmp.w .2

.t1xx:								; increment picktop, call PrintShooterList, go to .2
	inc.w picktop
	jsl.l PrintShooterList
	jmp.w .2

.t6:								; if plus go to .t1x2, ...
	lda.w picktop
	dec a
	cmp.w pickfirst
	bpl .t1x2
	jmp.w .2

.t1x2:								; decrement picktop, call PrintShooterList, go to .2
	dec.w picktop
	jsl.l PrintShooterList
org $80D001
	jmp.w .2
