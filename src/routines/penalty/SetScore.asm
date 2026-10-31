; Play one period of a playoff game with random goals
SetScore:							;add a period's goals to game a0; after period 3 a close game goes to OT
									;(gsper 3) and asks for a highlight
	phx
	ldx.b a0						;game record
	lda.l gsper,x					;period
	cmp.w #$0004					;finished (4 or more)?
	bcc .t3
	jmp.w .3						;yes: nothing to do

.t3:								;game not over: save the registers
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b a0
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	ldx.b a0
	lda.l gsper,x
	cmp.w #$0003					;period 3 just played?
	bne .t2							;no: play the next period
	lda.w #$0005					;final
	sta.l gsper,x
	lda.l gss1,x					;team 1 score
	sec
	sbc.l gss2,x					;minus team 2 score
	bit.w #$8000					;negative?
	beq .1
	eor.w #$FFFF					;absolute value
	inc a
.1:									;margin
	cmp.w #$0002					;2 or more?
	bcs .2							;yes: final stands
	lda.w gsp						;game mode
	cmp.w #$0004					;mode 4?
	bne .t1							;no: overtime
	lda.l gss1,x					;team 1 score
	cmp.l gss2,x					;tied?
	bne .2							;no: final stands
	inc a							;mode 4 breaks the tie for team 1
	sta.l gss1,x
	bra .2

.t1:								;close game: overtime with a highlight
	lda.w #$0003					;OT
	sta.l gsper,x
	lda.l gsflags,x
	ora.w #$0002					;gsfhl: wants a highlight
	sta.l gsflags,x
	bra .2

.t2:								;not the last period: next period
	lda.l gsper,x
	inc a							;+1
	sta.l gsper,x
	lda.l gst1,x					;team 1
	sta.b d0						;scoring team
	lda.l gst2,x					;team 2
	sta.b d1						;other team
	jsl.l .4						;goals for team 1
	ldx.b a0
	lda.l gss1,x					;team 1 score
	clc
	adc.b d0						;plus the goals
	sta.l gss1,x
	lda.l gst2,x					;team 2
	sta.b d0						;scoring team
	lda.l gst1,x					;team 1
	sta.b d1						;other team
	jsl.l .4						;goals for team 2
	ldx.b a0
	lda.l gss2,x					;team 2 score
	clc
	adc.b d0						;plus the goals
	sta.l gss2,x
.2:									;restore the registers
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
.3:									; return
	plx
	rtl
.4:									;.getscore: d0 = scoring team, d1 = other team; adds their sctab rows (.5)
									;as weights, returns d0 = goals 0-3
	asl.b d0						; team index to a word offset
	asl.b d0						;x4: long index
	lda.w #TeamList>>16
	sta.b a1+2
	lda.w #TeamList
	sta.b a1
	ldy.b d0						;scoring team
	lda.b [a1],y					;team data pointer
	sta.b a1
	ldy.w #$0008					;ScoutReport offset
	adc.b [a1],y					;plus it
	sta.b a1						;scouting report
	lda.b [a1]						;ratings byte
	and.w #$0070					;offence rating bits 4-6
	lsr a							;row * 8
	adc.w #.5						;plus the table
	sta.b a1						;row pointer
	lda.w #.5>>16
	sta.b a1+2
	lda.b [a1]						;scoring team's row
	sta.w nibblebuffer				;weights 0-1
	ldy.w #$0002
	lda.b [a1],y					;row
	sta.w nibblebuffer+2			;weights 2-3
	ldy.w #$0004
	lda.b [a1],y					;row
	sta.w nibblebuffer+4			;weights 4-5
	ldy.w #$0006
	lda.b [a1],y					;row
	sta.w nibblebuffer+6			;weights 6-7
	asl.b d1
	asl.b d1						;x4: long index
	lda.w #TeamList>>16
	sta.b a1+2
	lda.w #TeamList
	sta.b a1
	ldy.b d1						;other team
	lda.b [a1],y					;team data pointer
	sta.b a1
	ldy.w #$0008					;ScoutReport offset
	adc.b [a1],y					;plus it
	sta.b a1
	lda.b [a1]						;ratings byte
	and.w #$0007					;defence rating bits 0-2
	asl a
	asl a
	asl a							;row * 8
	adc.w #.5						;plus the table
	sta.b a1						;row pointer
org $9FA001
	lda.w #.5>>16
	sta.b a1+2
	lda.b [a1]						;other team's row
	adc.w nibblebuffer				;plus weights 0-1
	sta.w nibblebuffer
	ldy.w #$0002
	lda.b [a1],y
	adc.w nibblebuffer+2
	sta.w nibblebuffer+2
	ldy.w #$0004
	lda.b [a1],y
	adc.w nibblebuffer+4
	sta.w nibblebuffer+4
	ldy.w #$0006
	lda.b [a1],y
	adc.w nibblebuffer+6
	sta.w nibblebuffer+6
	lda.w #$0004
	sta.b d0
	jml.l WeightedRandomSelect		; d0 = a random index 0 
.5:									; dw $002B,$001E,$0017,$0004,$0027,$0020,$0018,$0005, dw $0023,$0021,$0...
	dw $002B,$001E,$0017,$0004,$0027,$0020,$0018,$0005
	dw $0023,$0021,$001A,$0006,$001E,$0022,$001E,$0006
	dw $001A,$0024,$001E,$0008,$0016,$0025,$001F,$000A
	dw $0013,$0026,$001F,$000C,$000F,$0026,$0020,$000F
