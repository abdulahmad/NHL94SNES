; check for the multitap, then clear the multitap pads and state
Multi5Init:							; check for the multitap, then clear the multitap pads and state
	jsl.l Multi5ConnectCheck
	lda.w #$000F
	sta.w JoyPad+4
	sta.w JoyPad+6
	sta.w JoyPad+8
	stz.w mp5present
	stz.w mp5warning
	stz.w mp5checktimer
	stz.w mp5readdelay
	lda.w mp5connect
	and.w #$0080
	beq .t1
	lda.w #$0001
	tsb.w mp5warning
	bra .1

.t1:
	lda.w #$0001
	trb.w mp5warning
.1:
	lda.w mp5connect
	and.w #$0040
	beq .t1x
	lda.w #$0001
	tsb.w mp5present
	bra .2

.t1x:
	lda.w #$0001
	trb.w mp5present
.2:
	rtl
	db "START OF MULTI5 CONNECT CHECK"
