; Set which team each controller plays
;
; Takes notdemo, OptPlayMode and the playoff tree. In the playoffs it finds the series of the user's team,
; sets HomeTeam, VisTeam, OptTeam2 and gamenum, and gives the controllers their teams. In every other case
; it only builds the other games (InitializeGameStructures). Called from PlayerSelect and maketree.
FigureJoy:							; set which team each controller plays
	lda.l notdemo					; the demo?
	bne .t2							; not the demo: go on
	jmp.w .4						; demo: other games only

.t2:								; not the demo
	lda.l OptPlayMode				; play mode
	bne .t1							; not 0: go on
	jmp.w .3						; play mode 0: other games only

.t1:								; play mode not 0
	cmp.w #$0004					; play mode 4?
	bne .t3
	jmp.w .3						; play mode 4: other games only

.t3:								; playoffs: find the series of the user's team
	jsl.l GetShifter				; d1 = games - 1
	lda.w #potree>>16				; a0 = the playoff team table
	sta.b a0+2
	lda.w #potree
	sta.b a0
	lda.l potreeteam				; playoff team index
	tay
	lda.b [a0],y
	and.w #$00FF
	sta.b d2						; d2 = the user's playoff team
	lda.b d1						; series index offset
	asl a
	sta.b a1
	lda.w #$FFFF					; gamenum -1: the team is not playing
	sta.l gamenum
	stz.b d0						; d0 = 0
.loop:								; search the series
	lda.b d2
	ldx.b a1
	cmp.l gst1,x					; first team of the series?
	beq .t2x
	cmp.l gst2,x					; second team of the series?
	beq .t1x
	dec.b a1						; next series
	dec.b a1
	dec.b d1
	bpl .loop
	rtl								; not found

.t1x:								; the playoff team is the second team of the series
	lda.w #$0004					; d0 = 4
	sta.b d0
	lda.l gst1,x					; the opponent is the first team
	sta.l OptTeam2					; OptTeam2
	bra .2

.t2x:								; the playoff team is the first team of the series
	stz.b d0
	lda.l gst2,x					; the opponent is the second team
	sta.l OptTeam2					; OptTeam2
.2:									; add the joystick offset
	lda.b d0
	clc
	adc.l pojoy						; plus pojoy
	sta.b d0
	lda.b d1						; game number
	sta.l gamenum
	lda.l gst1,x					; home team
	sta.w HomeTeam
	lda.l gst2,x					; visitor team
	sta.w VisTeam
	asl.b d0						; times 4: two words per entry
	asl.b d0
	phb								; data bank = this bank for the table
	phk
	plb
	ldy.b d0						; entry offset
	ldx.w #$0000					; first of the 5 controller slots
.loopx:								; each controller slot
	lda.w cont1team,x
	beq .1							; slot unused: skip
	lda.w .5,y						; its team from the table
	sta.w cont1team,x
.1:									; next slot
	inx
	inx
	cpx.w #$000A
	bcc .loopx						; more slots
	plb								; restore the data bank
	rtl
.3:									; other games only: table pointer (set but not used)
	lda.l OptPlayers				; OptPlayers
	asl a
	asl a
	sta.b d0
	tay
	lda.w #.5>>16
	sta.b a0+2
	lda.w #.5+32
	sta.b a0
	iny
	iny
.4:									; build the other games
	jsl.l InitializeGameStructures	; build the other games of the day
	rtl
.5:									; controller team pairs: by pojoy, then by OptPlayers
	dw $0001,$0000,$0001,$0001,$0001,$0002,$0002,$0001,$0002,$0000,$0002,$0002,$0002
	dw $0001,$0001,$0002,$0000,$0000,$0001,$0000,$0002,$0000,$0001,$0001,$0001,$0002
