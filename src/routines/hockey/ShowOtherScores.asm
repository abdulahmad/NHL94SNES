; Other scores screen
ShowOtherScores:					; called from PauseOtherScores
	lda.w #$001C
	sta.l setupvis
	lda.w #$001D
	sta.l setuphome
	jsl.l SetupScreen				; common setup of the stats screens
	ldx.w #$0049
	ldy.w #$0018
	lda.w #OtherScores>>16
	sta.b a1+2
	lda.w #OtherScores
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites OtherScores
	jsl.l SpriteFrameEnd
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	stz.w curitem
	lda.w #$0000
	cmp.l gamenum
	bne .2
.1:									; increment a
	inc a
.2:									; listtop = A, call GetShifter, listend = d1 + 1, ...
	sta.w listtop
	jsl.l GetShifter				; games of the round less one and its first win bit
	lda.b d1
	inc a
	sta.w listend
	jsl.l FillOtherScores			; fill the other-scores rows, skipping this game
	jsl.l SendTextMap
	lda.w #$0050
	ldx.w #$00C0
	ldy.w #$00D8
	jsl.l SetupScrollIRQ			; set up the three-way scroll IRQ
	jsl.l MenuScreenHDMA			; start the window and COLDATA HDMA
	jsl.l ScreenOn
	lda.w #$0005
	sta.w listrows
	jsl.l DrawOtherScoresPage		; draw the other-scores rows
OtherScoresLoop:					; called from OtherScoresNext, ScrollOtherScoresDown, ScrollOtherScoresUp
	jsl.l getpzjoy					; ReadjoyA for the controller that owns the pause menu
	lda.b d3
	bit.w #$1000
	beq .t2
	jmp.w OtherScoresRtl			; the rtl ShowOtherScores leaves through

.t2:								; d3 bits $1000 clear: if zero go to .t1
	bit.w #$0800
	beq .t1
.1:									; go to ScrollOtherScoresUp
	jmp.w ScrollOtherScoresUp		; scroll the other-scores list up one page

.t1:								; if not zero go to ScrollOtherScoresDown
	bit.w #$0400
	bne ScrollOtherScoresDown
OtherScoresNext:					; called from ScrollOtherScoresDown, ScrollOtherScoresUp
	lda.w listtop
	beq .3
	dec a
	bne .2
.1:									; if zero go to .3
	cmp.l gamenum
	beq .3
.2:									; printx = $0004, printy = listtop * 2 + listtop, printa = $2000, ...
	lda.w #$0004
	sta.w printx
	lda.w listtop
	asl a
	adc.w listtop
	sta.w printy
	lda.w #$2000
	sta.w printa
	lda.w #LineBraces>>16
	sta.b a1+2
	lda.w #LineBraces
	sta.b a1
	jsl.l PrintToStatsPage
.3:									; if plus go to .4, ...
	lda.w listtop
	clc
	adc.w listrows
	clc
	adc.w otherskip
	cmp.w listend
	bpl .4
	lda.w #$0004
	sta.w printx
	lda.w listtop
	clc
	adc.w listrows
	dec a
	sta.b r3
	asl a
	adc.b r3
	inc a
	sta.w printy
	lda.w #$2000
	sta.w printa
	lda.w #LineBraces>>16
	sta.b a1+2
	lda.w #LineBraces+3
	sta.b a1
	jsl.l PrintToStatsPage
.4:									; call DrawOtherScoresPage, call WaitFrame, go to OtherScoresLoop
	jsl.l DrawOtherScoresPage		; draw the other-scores rows
	jsl.l WaitFrame
	jmp.w OtherScoresLoop
