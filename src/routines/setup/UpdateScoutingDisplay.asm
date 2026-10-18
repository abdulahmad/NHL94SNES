; Every frame of the scouting report: print the next word when its timer runs out
UpdateScoutingDisplay:
	lda.w ScoutingReportTimer
	sec
	sbc.w #$1000
	beq .2
	bmi .t1
	bvs .2
	bra UpdateScoutingDisplay_rtl

.t1:
	bvs UpdateScoutingDisplay_rtl
.2:
	lda.w asv
	bmi .1
	dec.w ScoutingReportTimer
	bpl UpdateScoutingDisplay_rtl
.1:
	lda.w #PregameText>>16
	sta.b a1+2
	lda.w #PregameText
	sta.b a1
	lda.w PlayerScrollCtr
	sta.b d0
	bpl UpdateScoutingDisplay_para
	stz.w DispAttribCtr
	ldy.w SelectedPlayerIdx
	inc.w SelectedPlayerIdx
	inc.w SelectedPlayerIdx
	lda.w #TestList>>16
	sta.b a0+2
	lda.w #TestList
	sta.b a0
	lda.b [a0],y
	sta.b d0
	bpl UpdateScoutingDisplay_scroll
	lda.w #$7FFF
	sta.w ScoutingReportTimer
	lda.w #$01E0
	sta.w screentimer
UpdateScoutingDisplay_rtl:
	rtl
UpdateScoutingDisplay_scroll:
	lda.w VertLineScrolling
	cmp.w #$0001
	bmi .1
	jsl.l ScrollDisplayUp
.1:
	jsl.l ScrollDisplayUp
	lda.b a1+2
	sta.b a2+2
	lda.b a1
	sta.b a2
	bra UpdateScoutingDisplay_next
UpdateScoutingDisplay_skip:
	lda.b [a2]
	inc.b a2
	and.w #$00FF
	cmp.w #$000D
	bne UpdateScoutingDisplay_skip
UpdateScoutingDisplay_next:
	dec.b d0
	bpl UpdateScoutingDisplay_skip
	lda.b a2
	sec
	sbc.b a1
	sta.b d0
UpdateScoutingDisplay_para:
	lda.b a1
	clc
	adc.b d0
	sta.b a2
	lda.b a1+2
	sta.b a2+2
	lda.w #$000A
	sta.w ScoutingReportTimer
	lda.w DispAttribCtr
	sta.b d0
	lda.b [a2]
	and.w #$00FF
	cmp.w #$0025
	beq .t1
	jmp.w ScoutPlainWord

.t1:
	inc.b a2
	lda.b [a2]
	inc.w PlayerScrollCtr
	and.w #$00FF
	cmp.w #$0072
	bne .t3
	jmp.w ScoutHomeArena

.t3:
	cmp.w #$0076
	bne .t1x
	jmp.w ScoutVisCity

.t1x:
	cmp.w #$0068
	bne .t2
	jmp.w ScoutHomeCity

.t2:
	cmp.w #$0056
	bne .t1xx
	jmp.w ScoutVisName

.t1xx:
	cmp.w #$0048
	bne .t5
	jmp.w ScoutHomeName

.t5:
	cmp.w #$006D
	bne .t1x2
	jmp.w ScoutVisNick

.t1x2:
	cmp.w #$006E
	bne .t2x
	jmp.w ScoutHomeNick

.t2x:
	cmp.w #$0074
	bne .t1xx2
	jmp.w ScoutHotTeam

.t1xx2:
	cmp.w #$0065
	bne .t3x
	jmp.w ScoutExtremely

.t3x:
	cmp.w #$0030
	bne .t1x2x
	jmp.w ScoutHomeHot1

.t1x2x:
	cmp.w #$0031
	bne .t2xx
	jmp.w ScoutHomeHot2

.t2xx:
	cmp.w #$0032
	bne .t1xxx
	jmp.w ScoutHomeHot3

.t1xxx:
	cmp.w #$0033
	bne .t4
	jmp.w ScoutHomeCold1

.t4:
	cmp.w #$0034
	bne .t1x3
	jmp.w ScoutHomeCold2

.t1x3:
	cmp.w #$0035
	bne .t2x2
	jmp.w ScoutHomeCold3

.t2x2:
	cmp.w #$0036
	bne .t1xx2x
	jmp.w ScoutVisHot1

.t1xx2x:
	cmp.w #$0037
	bne .t3xx
	jmp.w ScoutVisHot2

.t3xx:
	cmp.w #$0038
	bne .t1x2xx
	jmp.w ScoutVisHot3

.t1x2xx:
	cmp.w #$0039
	bne .t2xxx
	jmp.w ScoutVisCold1

.t2xxx:
	cmp.w #$0061
	bne .t1xxxx
	jmp.w ScoutVisCold2

.t1xxxx:
	cmp.w #$0062
	bne ScoutPlainWord
	jmp.w ScoutVisCold3
