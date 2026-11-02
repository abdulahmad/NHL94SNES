; While HotColdRaised is not 0: lower four hot / cold bytes of each of 52 entries (HotColdTable, 12 bytes
; apart) by 2, and count HotColdRaised down
;
; Called from CheckCrowdMeter.
LowerHotColdTable:					; lower the raised hot/cold bytes and count HotColdRaised down
	lda.w HotColdRaised				; nothing to do when HotColdRaised is 0
	beq .rtl
	ldy.w #$0033					; 52 entries (y = 51 down to 0), 12 bytes apart
	ldx.w #$0000
.loop:								; one entry
	sep #$20						; lower the four bytes of the entry by 2
	lda.w HotColdTable+1,x
	dec a
	dec a
	sta.w HotColdTable+1,x
	lda.w HotColdTable,x
	dec a
	dec a
	sta.w HotColdTable,x
	lda.w HotColdTable+3,x
	dec a
	dec a
	sta.w HotColdTable+3,x
	lda.w HotColdTable+2,x
	dec a
	dec a
	sta.w HotColdTable+2,x
	rep #$20
	txa
	clc
	adc.w #$000C
	tax
	dey
	bpl .loop
	dec.w HotColdRaised				; one step less raised
.rtl:								; return
	rtl
