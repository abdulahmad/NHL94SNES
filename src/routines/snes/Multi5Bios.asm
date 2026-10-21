; read the five pads: pads 1 and 2 from the auto read, pads 3 to 5 through the multitap
Multi5Bios:							;read the five pads: pads 1 and 2 from the auto read, pads 3 to 5 through
									;the multitap
			;   on port 2 when mp5present is set
	php
	sep #$20
	rep #$10
	stz.w mp5padsig+3
	stz.w mp5padsig+4
.loop:								; loop: if HVBJOY & $01 != 0 go to .loop, ...
	lda.w HVBJOY
	and.b #$01
	bne .loop
	ldx.w JOY1L
	stx.w JoyPad
	txa
	and.b #$0F
	sta.w mp5padsig
	lda.w JOYSER0
	lsr a
	rol.w mp5padsig
	ldx.w JOY2L
	stx.w JoyPad+2
	txa
	and.b #$0F
	sta.w mp5padsig+1
	lda.w mp5present
	bne .t2
	jmp.w .2

.t2:								; mp5present != 0: JoyPad+4 = JOY4L, mp5padsig+2 = JOY4L & $0F, rol mp5...
	ldx.w JOY4L
	stx.w JoyPad+4
	txa
	and.b #$0F
	sta.w mp5padsig+2
	lda.w JOYSER1
	lsr a
	rol.w mp5padsig+1
	lsr a
	rol.w mp5padsig+2
	stz.w WRIO
	lda.w mp5readall
	ora.w mp5warning
	bne .1
	lda.w cont4team
	ora.w cont5team
	bne .1
	lda.w mp5readdelay
	beq .t1
	dec a
	sta.w mp5readdelay
	jmp.w .5

.t1:								; mp5readdelay = 0: mp5readdelay = $1E
	lda.b #$1E
	sta.w mp5readdelay
.1:									; rol JoyPad+7, lsr a, rol JoyPad+9, ...
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+7
	lsr a
	rol.w JoyPad+9
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+7
	lsr a
	rol.w JoyPad+9
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+7
	lsr a
	rol.w JoyPad+9
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+7
	lsr a
	rol.w JoyPad+9
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+7
	lsr a
	rol.w JoyPad+9
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+7
	lsr a
	rol.w JoyPad+9
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+7
	lsr a
	rol.w JoyPad+9
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+7
	lsr a
	rol.w JoyPad+9
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+6
	lsr a
	rol.w JoyPad+8
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+6
	lsr a
	rol.w JoyPad+8
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+6
	lsr a
	rol.w JoyPad+8
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+6
	lsr a
	rol.w JoyPad+8
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+6
	lsr a
	rol.w JoyPad+8
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+6
	lsr a
	rol.w JoyPad+8
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+6
	lsr a
	rol.w JoyPad+8
	lda.w JOYSER1
	lsr a
	rol.w JoyPad+6
	lsr a
	rol.w JoyPad+8
	lda.w JoyPad+6
	and.b #$0F
	sta.w mp5padsig+3
	lda.w JoyPad+8
	and.b #$0F
	sta.w mp5padsig+4
	lda.w JOYSER1
	lsr a
	rol.w mp5padsig+3
	lsr a
	rol.w mp5padsig+4
	bra .5
.2:									; rol mp5padsig+1
	lda.w JOYSER1
	lsr a
	rol.w mp5padsig+1
.5:									; WRIO = $80, mp5warning = mp5warning & $01, if mp5checktimer = 0 go to...
	lda.b #$80
	sta.w WRIO
	lda.w mp5warning
	and.b #$01
	sta.w mp5warning
	lda.w mp5checktimer
	beq .2x
.1x:								; decrement mp5checktimer
	dec.w mp5checktimer
.2x:								; JOYSER0 = 0, JOYSER0 = $01, eor mp5port1last, ...
	stz.w JOYSER0
	lda.b #$01
	sta.w JOYSER0
	lda.w JOYSER0
	and.b #$02
	tax
	eor.w mp5port1last
	stx.w mp5port1last
	sta.w mp5portchg
	lda.w JOYSER1
	and.b #$02
	tax
	eor.w mp5port2last
	stx.w mp5port2last
	ora.w mp5portchg
	beq .4
.3:									; mp5checktimer = $10
	lda.b #$10
	sta.w mp5checktimer
.4:									; if mp5checktimer != 0 go to .t1x, ...
	lda.w mp5checktimer
	bne .t1x
	bra .7

.t1x:								; mp5checktimer != 0: call Multi5ConnectCheck, JoyPad+4 = $000F, JoyPad...
	jsl.l Multi5ConnectCheck
	ldx.w #$000F
	stx.w JoyPad+4
	stx.w JoyPad+6
	stx.w JoyPad+8
	lda.w mp5connect
	and.b #$80
	beq .t2x
	lda.b #$01
	tsb.w mp5warning
	bra .6

.t2x:								; mp5connect & $80 = 0: trb mp5warning
	lda.b #$01
	trb.w mp5warning
.6:									; if mp5connect & $40 = 0 go to .t1xx, ...
	lda.w mp5connect
	and.b #$40
	beq .t1xx
	lda.b #$01
	tsb.w mp5present
	bra .10

.t1xx:								; mp5connect & $40 = 0: trb mp5present, go to .10
	lda.b #$01
	trb.w mp5present
	bra .10
.7:									; JOYSER0 = 0
	stz.w JOYSER0
.10:								; if mp5padsig = $01 go to .2xx, ...
	lda.w mp5padsig
	cmp.b #$01
	beq .2xx
	ldx.w #$000F
	stx.w JoyPad
	ldx.w mp5present
	beq .2xx
.1xx:								; call .12
	jsr.w .12
.2xx:								; if mp5padsig+1 = $01 go to .4x, ...
	lda.w mp5padsig+1
	cmp.b #$01
	beq .4x
	ldx.w #$000F
	stx.w JoyPad+2
	ldx.w mp5present
	beq .8
.3x:								; call .12
	jsr.w .12
.4x:								; if mp5present = 0 go to .8
	lda.w mp5present
	beq .8
.5x:								; if mp5padsig+2 = $01 go to .6x, ...
	lda.w mp5padsig+2
	cmp.b #$01
	beq .6x
	ldx.w #$000F
	stx.w JoyPad+4
	jsr.w .12
.6x:								; if mp5padsig+3 = $01 go to .7x, ...
	lda.w mp5padsig+3
	cmp.b #$01
	beq .7x
	ldx.w #$000F
	stx.w JoyPad+6
	jsr.w .12
.7x:								; if mp5padsig+4 = $01 go to .8, ...
	lda.w mp5padsig+4
	cmp.b #$01
	beq .8
	ldx.w #$000F
	stx.w JoyPad+8
	jsr.w .12
.8:									; if mp5warning = 0 go to .11
	lda.w mp5warning
	beq .11
.9:									; if vcount & $10 != 0 go to .t1xxx, ...
	lda.b vcount
	and.b #$10
	bne .t1xxx
	ldx.w #$1000
	stx.w JoyPad
	stx.w JoyPad+2
	stx.w JoyPad+4
	stx.w JoyPad+6
	stx.w JoyPad+8
	bra .11

.t1xxx:								; vcount & $10 != 0: JoyPad = $0000, JoyPad+2 = $0000, JoyPad+4 = $0000...
	ldx.w #$0000
	stx.w JoyPad
	stx.w JoyPad+2
	stx.w JoyPad+4
	stx.w JoyPad+6
	stx.w JoyPad+8
.11:								; return
	plp
	rtl
.12:								; subroutine: and #$1E, if not zero go to .t1xxxx, ...
	and.b #$1E
	cmp.b #$02
	bne .t1xxxx
	lda.b #$04
	tsb.w mp5warning
	bra .1xxx

.t1xxxx:							; if not zero go to .1xxx, ...
	cmp.b #$1E
	bne .1xxx
	lda.b #$02
	tsb.w mp5warning
.1xxx:								; return
	rts
	db "MODIFIED FROM SHVC MULTI5 BIOS Ver2.00"
	db "END OF MULTI5 BIOS"
