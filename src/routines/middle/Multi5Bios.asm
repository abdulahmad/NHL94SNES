; read the five pads: pads 1 and 2 from the auto read, pads 3 to 5 through the multitap
Multi5Bios:							;read the five pads: pads 1 and 2 from the auto read, pads 3 to 5 through
									;the multitap
			;   on port 2 when mp5present is set
	php								;save the flags
	sep #$20						;8-bit A
	rep #$10						;16-bit index
	stz.w mp5padsig+3				;pad 4 signature = 0
	stz.w mp5padsig+4				;pad 5 signature = 0
.loop:								; loop: if HVBJOY & $01 != 0 go to .loop, ...
	lda.w HVBJOY					;HVBJOY: auto joypad read running?
	and.b #$01						;bit 0
	bne .loop						;wait until it finishes
	ldx.w JOY1L						;pad 1 buttons from the auto read
	stx.w PadRaw1					;store as PadRaw1
	txa								;A = low byte
	and.b #$0F						;the id bits
	sta.w mp5padsig					;start the pad 1 signature
	lda.w JOYSER0					;pad 1 serial data (port 1, data 2)
	lsr a							;bit 0 to carry
	rol.w mp5padsig					;shift into the signature
	ldx.w JOY2L						;pad 2 buttons from the auto read
	stx.w PadRaw2					;store as PadRaw2
	txa								;A = low byte
	and.b #$0F						;the id bits
	sta.w mp5padsig+1				;start the pad 2 signature
	lda.w mp5present				;multitap present?
	bne .t2							;yes: read pads 3 to 5
	jmp.w .2						;no: skip to the end

.t2:								; mp5present != 0: PadRaw3 = JOY4L, mp5padsig+2 = JOY4L & $0F, rol mp5...
	ldx.w JOY4L						;pad 3 buttons from the auto read
	stx.w PadRaw3					;store as PadRaw3
	txa								;A = low byte
	and.b #$0F						;the id bits
	sta.w mp5padsig+2				;start the pad 3 signature
	lda.w JOYSER1					;pad 2 port serial data
	lsr a							;bit 0 to carry
	rol.w mp5padsig+1				;shift into signature 2
	lsr a							;bit 1 to carry
	rol.w mp5padsig+2				;shift into signature 3
	stz.w WRIO						;WRIO = 0: latch the multitap
	lda.w mp5readall				;read all pads this frame?
	ora.w mp5warning				;or a warning shown
	bne .1							;yes: read now
	lda.w cont4team					;pad 4 assigned to a team?
	ora.w cont5team					;or pad 5
	bne .1							;yes: read now
	lda.w mp5readdelay				;frames until the next full read
	beq .t1							;none: read now
	dec a							;one less
	sta.w mp5readdelay				;store
	jmp.w .5						;skip the read this frame

.t1:								; mp5readdelay = 0: mp5readdelay = $1E
	lda.b #$1E						;read again in 30 frames
	sta.w mp5readdelay				;store
.1:									; rol PadRaw4+1, lsr a, rol PadRaw5+1, ...
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4+1					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5+1					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4+1					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5+1					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4+1					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5+1					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4+1					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5+1					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4+1					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5+1					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4+1					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5+1					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4+1					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5+1					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4+1					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5+1					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5					;shift into pad 5
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w PadRaw4					;shift into pad 4
	lsr a							;data bit 0 to carry
	rol.w PadRaw5					;shift into pad 5
	lda.w PadRaw4
	and.b #$0F
	sta.w mp5padsig+3
	lda.w PadRaw5
	and.b #$0F
	sta.w mp5padsig+4
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w mp5padsig+3
	lsr a							;data bit 0 to carry
	rol.w mp5padsig+4
	bra .5
.2:									; rol mp5padsig+1
	lda.w JOYSER1					;next serial bits of the two multitap pads
	lsr a							;data bit 0 to carry
	rol.w mp5padsig+1				;shift into signature 2
.5:									; WRIO = $80, mp5warning = mp5warning & $01, if mp5checktimer = 0 go to...
	lda.b #$80						;WRIO bit 7 high: release the multitap latch
	sta.w WRIO						;to WRIO
	lda.w mp5warning				;warning flags
	and.b #$01						;keep bit 0
	sta.w mp5warning				;store
	lda.w mp5checktimer				;port change timer
	beq .2x							;zero: skip
.1x:								; decrement mp5checktimer
	dec.w mp5checktimer				;count it down
.2x:								; JOYSER0 = 0, JOYSER0 = $01, eor mp5port1last, ...
	stz.w JOYSER0					;reset the port 1 data latch
	lda.b #$01						;latch on
	sta.w JOYSER0					;to JOYSER0
	lda.w JOYSER0					;port 1 data
	and.b #$02						;bit 1
	tax								;X = port 1 state
	eor.w mp5port1last				;changed from last time?
	stx.w mp5port1last				;remember it
	sta.w mp5portchg				;change flag
	lda.w JOYSER1					;port 2 data
	and.b #$02						;bit 1
	tax								;X = port 2 state
	eor.w mp5port2last				;changed from last time?
	stx.w mp5port2last				;remember it
	ora.w mp5portchg				;either port changed?
	beq .4							;no: go on
.3:									; mp5checktimer = $10
	lda.b #$10						;16 frames
	sta.w mp5checktimer				;to the check timer
.4:									; if mp5checktimer != 0 go to .t1x, ...
	lda.w mp5checktimer				;check timer
	bne .t1x						;running: check the connection
	bra .7							;timer done: skip

.t1x:								; mp5checktimer != 0: call Multi5ConnectCheck, PadRaw3 = $000F, PadRaw1...
	jsl.l Multi5ConnectCheck		; read 16 signature bits from each port
	ldx.w #$000F					;no pad: $000F
	stx.w PadRaw3					;pads 3 to 5 read as no controller
	stx.w PadRaw4					;..
	stx.w PadRaw5					;..
	lda.w mp5connect				;connection result
	and.b #$80						;bit 7: multitap seen
	beq .t2x						;no: clear the warning
	lda.b #$01						;bit 0
	tsb.w mp5warning				;set the warning
	bra .6

.t2x:								; mp5connect & $80 = 0: trb mp5warning
	lda.b #$01						;bit 0
	trb.w mp5warning				;clear the warning
.6:									; if mp5connect & $40 = 0 go to .t1xx, ...
	lda.w mp5connect				;connection result
	and.b #$40						;bit 6: Multi5 present
	beq .t1xx						;no: clear present
	lda.b #$01						;bit 0
	tsb.w mp5present				;set mp5present
	bra .10

.t1xx:								; mp5connect & $40 = 0: trb mp5present, go to .10
	lda.b #$01						;bit 0
	trb.w mp5present				;clear mp5present
	bra .10
.7:									; JOYSER0 = 0
	stz.w JOYSER0					;leave the data latch off
.10:								; if mp5padsig = $01 go to .2xx, ...
	lda.w mp5padsig					;pad 1 signature
	cmp.b #$01						;1 = a normal pad
	beq .2xx						;yes: next pad
	ldx.w #$000F					;no pad: $000F
	stx.w PadRaw1					;pad 1 reads as no controller
	ldx.w mp5present				;multitap present?
	beq .2xx						;no: next pad
.1xx:								; call .12
	jsr.w .12						;check the signature bits
.2xx:								; if mp5padsig+1 = $01 go to .4x, ...
	lda.w mp5padsig+1				;pad 2 signature
	cmp.b #$01						;1 = a normal pad
	beq .4x							;yes: next pad
	ldx.w #$000F					;no pad: $000F
	stx.w PadRaw2					;pad 2 reads as no controller
	ldx.w mp5present				;multitap present?
	beq .8							;no: skip pads 3 to 5
.3x:								; call .12
	jsr.w .12						;check the signature bits
.4x:								; if mp5present = 0 go to .8
	lda.w mp5present				;multitap present?
	beq .8							;no: skip pads 3 to 5
.5x:								; if mp5padsig+2 = $01 go to .6x, ...
	lda.w mp5padsig+2				;pad 3 signature
	cmp.b #$01						;1 = a normal pad
	beq .6x							;yes: next pad
	ldx.w #$000F					;no pad: $000F
	stx.w PadRaw3					;pad 3 reads as no controller
	jsr.w .12						;check the signature bits
.6x:								; if mp5padsig+3 = $01 go to .7x, ...
	lda.w mp5padsig+3				;pad 4 signature
	cmp.b #$01						;1 = a normal pad
	beq .7x							;yes: next pad
	ldx.w #$000F					;no pad: $000F
	stx.w PadRaw4					;pad 4 reads as no controller
	jsr.w .12						;check the signature bits
.7x:								; if mp5padsig+4 = $01 go to .8, ...
	lda.w mp5padsig+4				;pad 5 signature
	cmp.b #$01						;1 = a normal pad
	beq .8							;yes: done
	ldx.w #$000F					;no pad: $000F
	stx.w PadRaw5					;pad 5 reads as no controller
	jsr.w .12						;check the signature bits
.8:									; if mp5warning = 0 go to .11
	lda.w mp5warning				;warning shown?
	beq .11							;no: return
.9:									; if Vcount & $10 != 0 go to .t1xxx, ...
	lda.b Vcount					;frame counter
	and.b #$10						;bit 4: blink
	bne .t1xxx						;on: clear the pads
	ldx.w #$1000					;blink off: $1000 on all pads
	stx.w PadRaw1					;pad 1
	stx.w PadRaw2					;pad 2
	stx.w PadRaw3					;pad 3
	stx.w PadRaw4					;pad 4
	stx.w PadRaw5					;pad 5
	bra .11							;return

.t1xxx:								; Vcount & $10 != 0: PadRaw1 = $0000, PadRaw2 = $0000, PadRaw3 = $0000...
	ldx.w #$0000					;all pads read 0
	stx.w PadRaw1					;pad 1
	stx.w PadRaw2					;pad 2
	stx.w PadRaw3					;pad 3
	stx.w PadRaw4					;pad 4
	stx.w PadRaw5					;pad 5
.11:								; return
	plp								;restore the flags
	rtl
.12:								; subroutine: and #$1E, if not zero go to .t1xxxx, ...
	and.b #$1E						;the signature bits that tell the pad type
	cmp.b #$02						;2?
	bne .t1xxxx						;no: test the other value
	lda.b #$04						;bit 2
	tsb.w mp5warning				;set that warning
	bra .1xxx						;return

.t1xxxx:							; if not zero go to .1xxx, ...
	cmp.b #$1E						;$1E?
	bne .1xxx						;no: return
	lda.b #$02						;bit 1
	tsb.w mp5warning				;set that warning
.1xxx:								; return
	rts
	db "MODIFIED FROM SHVC MULTI5 BIOS Ver2.00"
	db "END OF MULTI5 BIOS"
