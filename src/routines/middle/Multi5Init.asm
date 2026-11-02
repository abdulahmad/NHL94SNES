; check for the multitap, then clear the multitap pads and state
Multi5Init:							; check for the multitap, then clear the multitap pads and state
	jsl.l Multi5ConnectCheck		; read 16 signature bits from each port
	lda.w #$000F
	sta.w PadRaw3
	sta.w PadRaw4
	sta.w PadRaw5
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

.t1:								; mp5connect & $0080 = 0: trb mp5warning
	lda.w #$0001
	trb.w mp5warning
.1:									; if mp5connect & $0040 = 0 go to .t1x, ...
	lda.w mp5connect
	and.w #$0040
	beq .t1x
	lda.w #$0001
	tsb.w mp5present
	bra .2

.t1x:								; mp5connect & $0040 = 0: trb mp5present
	lda.w #$0001
	trb.w mp5present
.2:									; return
	rtl
	db "START OF MULTI5 CONNECT CHECK"
