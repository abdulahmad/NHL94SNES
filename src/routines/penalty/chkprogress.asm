; Move the referee and the game through a penalty
chkprogress:						; called from PenaltyManager
	lda.w gmode
	bit.w #gmpen
	bne .2
.1:									; return
	rtl
.2:									; gmode bit gmpen set: if PenCntDwn >= 0 go to .t1, ...
	lda.w PenCntDwn
	bpl .t1
	jmp.w .t3

.t1:								; PenCntDwn >= 0: sbc d7, PenCntDwn = A, if plus go to .1, ...
	sec
	sbc.b d7
	sta.w PenCntDwn
	bpl .1
	lda.w #gmpendel
	trb.w gmode
	lda.w #PenBuf>>16
	sta.b a0+2
	lda.w #PenBuf
	sta.b a0
.loop:								; loop: increment a0, increment a0, if zero go to .loop, ...
	lda.b [a0]
	inc.b a0
	inc.b a0
	and.w #$00FF
	cmp.w #$0034
	beq .loop
	tay
	beq .1
	dec.b a0
	dec.b a0
	lda.b [a0]
	inc.b a0
	inc.b a0
	and.w #$00FF
	sta.b d0
	tay
	lda.w #Penaltylist>>16
	sta.b a1+2
	lda.w #Penaltylist
	sta.b a1
	clc
	adc.b [a1],y
	sta.b a1
	lda.b [a1]						; penalty with minutes?
	and.w #$00FF
	beq .loop
	cmp.w #$0001
	beq .loop
	lda.w #sf2drec
	tsb.w sflags
	lda.w brightness
	beq .1x
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
.1x:								; call SetHor, tsb puckc, a3 = $001C, ...
	jsl.l SetHor					; switches to the horizontal rink
	lda.w #$FF00
	tsb.w puckc
	ldx.w #puckscnum
	stx.b a3
	lda.w #$001A
	sta.b d0
	jsl.l assinsert					; give player X assignment d0 on top of the current one
	ldx.b a3
	lda.w #$1C20
	sta.w temp1,x					; temp1 = 120*60
	lda.w #$FF00					; RefStep negative, RefCnt 0; UpdatePA; RefCnt 50; PushRef 0
	tsb.w RefStep
	stz.w RefCnt
	jsl.l UpdatePA					; animates the referee and the message line
	lda.w #$0032
	sta.w RefCnt
	stz.b d0
	jsl.l PushRef					; draws a referee frame
	jsl.l FadeIn					; fade in: install BrightnessHook as the frame hook
	jsl.l ScreenOn
	rtl

.t3:								; call SeatPenaltyBox, if RefCnt negative go to .t2, ...
	jsl.l SeatPenaltyBox			; puts the box players at their box spots
	lda.w RefCnt
	bmi .t2
	jmp.w InProgress_rtl

.t2:								; RefCnt negative: if RefStep negative go to .t1x, ...
	lda.w RefStep
	bmi .t1x
	jmp.w InProgress_rtl

.t1x:								; RefStep negative: xsave = X
	lda.b d0
	pha
	lda.b d0+2
	pha
	stx.b xsave
	ldx.w #$0000
.loopx:								; loop: X + 1, X + 1, if not zero go to .loopx, ...
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loopx
	ldx.b xsave
; chkprogress: look for any penalty left in PenBuf (93S .find); InProgress when there is one, else
; InProgress_exit
chkprogress_find:					; called from InProgress
	lda.w #PenBuf>>16
	sta.b a0+2
	lda.w #PenBuf
	sta.b a0
.loop:								; loop: increment a0, increment a0, if zero go to .loop, ...
	lda.b [a0]
	inc.b a0
	inc.b a0
	and.w #$00FF
	cmp.w #$0034
	beq .loop
	cmp.w #$0000
	bne InProgress
	jmp.w InProgress_exit			; the penalty list is empty: end the penalty mode
