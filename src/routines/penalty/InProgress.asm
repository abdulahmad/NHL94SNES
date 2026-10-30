; The referee's work after a whistle
;
; Entered from chkprogress_find with a0 just past the first PenBuf word and the caller's registers already
; on the stack. Takes the last queued penalty of PenBuf (a word per penalty: penalty number in the low
; byte, object offset in the high byte, bit 15 = new) and sends that player to the box.
;
; A new entry gets its minutes from Penaltylist, raises the team penalty counts and minutes, logs it in
; PenSum, sets the penalty time in tmpdst, adds the player to tmboxlist, then calls SetPA and USBoard.
; Leaves through InProgress_coin; when no penalty is left InProgress_exit ends the penalty mode first.
InProgress:							; sends the last PenBuf entry to the box
	lda.b [a0]						; scan PenBuf for its zero word (the end)
	inc.b a0
	inc.b a0
	cmp.w #$0000
	bne InProgress
	dec.b a0						; back up to the last entry
	dec.b a0
	dec.b a0
	dec.b a0
	lda.b [a0]						; the last entry
	pha								; keep it for the new flag test
	and.w #$7FFF					; clear the new flag (bit 15)
	sta.b [a0]
	pla
	bmi .t4							; it was set: a new penalty
	lda.b [a0]						; old entry: object offset from the high byte
	xba
	and.w #$00FF
	asl a
	sta.b d1						; d1 = object offset
	tay
	lda.w position,y				; position of that object
	bmi .t1							; negative: the player left, drop the entry
	jmp.w InProgress_coin			; still in play: keep the entry

.t1:								; drop the entry
	lda.w #$0000
	sta.b [a0]
	jmp.w InProgress_coin			; and go on

.t4:								; a new penalty entry
	lda.b [a0]						; low byte is the penalty number
	and.w #$00FF
	sta.b d0						; d0 = penalty number
	tay
	lda.w #Penaltylist>>16			; a1 = Penaltylist
	sta.b a1+2
	lda.w #Penaltylist
	sta.b a1
	lda.b [a1],y					; offset of this penalty's record
	clc
	adc.b a1
	sta.b a1						; a1 = address of the record
	cmp.w #$D4AD					; compare with one record (the penalty shot)
	bne .t2
	jmp.w .t3						; penalty shot: .t3

.t2:								; not the penalty shot
	cmp.w #$D434					; compare with another record
	bne .1
	jsl.l ShowThreeStars			; that record: ShowThreeStars first
.1:									; record found
	lda.b [a1]						; first byte of the record: penalty minutes
	and.w #$00FF
	sta.b d2						; d2 = minutes
	bne .t1x						; some minutes: a player is sent to the box
	jmp.w .10						; none: just clear the entry (.10)

.t1x:								; save d0 and d1 (two words each)
	lda.b d0
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	stx.b xsave						; keep X
	ldx.w #$0000					; x counts bytes
.loop:								; push a1 and the next 7 words
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .loop
	ldx.b xsave						; restore X
	jsl.l GetPeriodTimeRemaining	; period time remaining
	lda.b [a0]						; high byte of the entry: object offset
	xba
	and.w #$00FF
	asl a
	sta.b d1						; d1 = object offset
	tax								; x = object offset
	stx.b a3						; a3 = object offset for SetPA
	stz.b d0						; d0 = 0 (home)
	stz.b a2						; a2 = 0: team offset of the penalized team
	lda.w #$0002					; a1 = 2: team offset of the other team
	sta.b a1
	lda.w pfteam,x					; team of the player
	beq .1x							; home: keep
	lda.w #$8000					; visitors: d0 = $8000 flag
	sta.b d0
	stz.b a1						; a1 = 0
	lda.w #$0002					; a2 = 2
	sta.b a2
	lda.w CwdExciteLvl				; crowd excitement
	clc
	adc.w #$0014					; plus $14
	bmi .1x							; skip the store if it goes negative
	sta.w CwdExciteLvl
.1x:								; count the penalty for the team
	ldy.b a2						; tmPenalties +1, tmPenmin += minutes
	lda.w tmPenalties,y				; tmPenalties + 1
	inc a
	sta.w tmPenalties,y
	lda.w tmPenmin,y				; tmPenmin += minutes
	clc
	adc.b d2
	sta.w tmPenmin,y
	lda.w pnum,x					; TempPlOffset = player number
	and.w #$00FF					; team and player number in TempPlOffset
	ora.b d0						; plus the visitor flag
	sta.w TempPlOffset
	lda.w pnum,x					; player number again
	sta.b d0						; d0 = player number
	lda.b a2						; player's team
	beq .2							; home: offset 0
	lda.w #$001A					; visitors: offset $1A
.2:									; team player offset ready
	phx								; keep x
	clc
	adc.b d0
	tax								; x = index of the player
	sep #$20						; byte access
	lda.w ppenmin,x					; player's penalty minutes
	rep #$20
	and.w #$00FF
	clc
	adc.b d2						; plus d2
	sep #$20
	sta.w ppenmin,x					; store
	rep #$20
	plx								; restore x
	lda.w PenSumLength				; penalties already logged
	cmp.w #$0041					; log full ($41 entries)?
	bcs .4							; yes: no entry
	asl a							; entries are 4 bytes
	asl a
	tay
	jsl.l GetPeriodTimeRemaining	; period time remaining
	lda.b d0						; log the time
	sta.w PenSum,y
	iny
	iny
	lda.w TempPlOffset				; player and visitor flag
	cmp.w #$0080					; below $80: home
	bmi .3
	ora.w #$0080					; visitors: bit 7 set
.3:									; player byte ready
	sep #$20						; log the player
	sta.w PenSum,y
	rep #$20
	iny
	lda.b [a0]						; and the penalty number
	and.w #$00FF
	sep #$20
	sta.w PenSum,y					; log the penalty number
	rep #$20
	inc.w PenSumLength				; one more entry
.4:									; penalty logged
	lda.w TempPlOffset				; TempPlOffset
	and.w #$00FF					; player number
	bit.w #$0080					; sign extend it
	beq .5
	ora.w #$FF00
.5:									; as an offset
	asl a							; word offset
	sta.b d0						; d0 = player offset
	phx								; keep x
	ldx.w #$003C					; 60
	lda.b d2						; minutes
	and.w #$00FF
	jsl.l Mul8U						; minutes * 60
	ora.w #$2000					; flag $2000 in the penalty time
	sta.b d2						; d2 = the penalty time word
	plx								; restore x
	lda.b a2						; team of the penalized player
	beq .6							; home: offset 0
	lda.w #$0034					; visitors: state offset $34
.6:									; team state offset chosen
	clc
	adc.b d0
	tay								; y = index into tmpdst
	lda.w tmpdst,y					; old state of the player
	bmi .7							; negative: no old time
	and.w #$1000					; keep bit 12 of the old state
	tsb.b d2						; into the new word
.7:									; store the penalty time
	lda.b d2
	sta.w tmpdst,y
	lda.w #$1000					; bit 12 is not part of the time itself
	trb.b d2
	lda.b a0+2						; keep a0
	pha
	lda.b a0
	pha
	lda.b a2						; team of the penalized player
	beq .8							; home: box list at 0
	lda.w #$001A					; visitors: box list at offset $1A
.8:									; box list offset chosen
	sta.b a0						; a0 = box list start
	lda.w #$0018					; $19 slots
	sta.b d1
.loop2:								; find a free slot in the box list
	ldy.b a0
	inc.b a0
	lda.w tmboxlist,y				; entry
	bit.w #$0080					; bit 7: free
	bne .9
	dec.b d1						; next slot
	bpl .loop2
.9:									; slot found or list full
	lda.b d0						; put the player in the slot
	ora.w #$FF00					; mark it used
	sta.w tmboxlist,y
	pla								; restore a0
	sta.b a0
	pla
	sta.b a0+2
	lda.w #$000D					; assignment 13: the player goes to the box
	sta.b d0
	jsl.l assreplace				; replace his assignment
	stx.b xsave						; restore the saved registers
	ldx.w #$000E
.loop3:								; pull back a1..
	pla
	sta.b a1,x
	dex
	dex
	bpl .loop3
	ldx.b xsave
	pla								; pull back d1 and d0
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	ldx.b a3						; x = object offset
	jsl.l SetPA						; start the penalty animation
	jsl.l USBoard					; update the box display
	bra InProgress_coin				; common end

.t3:								; penalty shot
	jsl.l StartPenaltyShot			; start the penalty shot
.10:								; no minutes: drop the entry
	lda.w #$0000					; clear the entry
	sta.b [a0]
	lda.w sfhormode					; horizontal mode
	beq .t1xx						; not horizontal: SetPA
	jmp.w chkprogress_find			; look for the next penalty

.t1xx:								; horizontal mode off
	jsl.l SetPA						; start the animation
	bra InProgress_coin				; common end
; InProgress: the penalties are over (chkprogress_find found none): clear gmpen, puck faceoff assignment, then
; InProgress_coin
InProgress_exit:					; the penalty list is empty: end the penalty mode
	lda.w #$0004					; the penalty mode flag
	trb.w gmode
	ldx.w #$001C					; object 14 (the puck)
	stx.b a3
	lda.w #$001B					; assignment 27: puck faceoff
	sta.b d0
	jsl.l assreplace				; replace the assignment
; InProgress: InProgress_ap for both teams (not in a shootout), restore the registers
InProgress_coin:					; restore the registers and leave; first look for coincidental penalties
	lda.w penshot					; penalty shot in progress?
	bne .1							; yes: skip
	stz.b a2						; team 0
	jsl.l InProgress_ap				; find coincidental penalties
	lda.w #$0002					; team 2
	sta.b a2
	jsl.l InProgress_ap
.1:									; registers back
	stx.b xsave
	ldx.w #$000E
.loop:								; pull back a0 and the next 7 words
	pla
	sta.b a0,x
	dex
	dex
	bpl .loop
	ldx.b xsave						; restore x
	pla								; d0 back
	sta.b d0+2
	pla
	sta.b d0
	ldx.b a3						; x = a3
; InProgress: the rtl it leaves through
InProgress_rtl:						; the rtl chkprogress jumps to
	rtl
