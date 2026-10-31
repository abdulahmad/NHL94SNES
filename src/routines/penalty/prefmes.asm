; Print the message for penalty d0, or clear it
prefmes:							;print penalty message d0 (negative: just clear it); called from PushRef,
									;SetPA
	lda.b d0						;save the registers
	pha
	lda.b d0+2
	pha
	lda.b d1
	pha
	lda.b d1+2
	pha
	lda.b d2
	pha
	lda.b d2+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.w sfhormode					;horizontal (sfhormode) layout?
	beq .t1							;no: boxed message
	jmp.w .t5						;yes

.t1:								;boxed: clear any old box first
	lda.l penmsgbox					;box showing?
	beq .1							;no
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #prefmesPos>>16			;position of the old box
	sta.b a1+2
	lda.w #prefmesPos
	sta.b a1
	jsl.l print						;print prefmesPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$000E					;14 wide
	sta.b d0
	lda.w #$0003					;3 high
	sta.b d1
	lda.l blankchar					;blank tile
	sta.b d2
	jsl.l eraser					;erase the box
	lda.w #$0000
	sta.l penmsgbox					;no box now
.1:									;new message?
	lda.b d0						;penalty d0
	bpl .t4							;yes
	jmp.w .3						;negative: done

.t4:								;print the message box
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #prefmesPos2>>16
	sta.b a1+2
	lda.w #prefmesPos2
	sta.b a1
	jsl.l print						;print prefmesPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #Penaltylist>>16			;penalty name table
	sta.b a1+2
	lda.w #Penaltylist
	sta.b a1
	ldy.b d0						;penalty offset
	lda.l penmsgbox					;box already up?
	beq .t3							;no: show it
	cpy.w #$0006					;penalty $06?
	bne .t1x						;no
	jmp.w .3						;yes: don't replace the box

.t1x:								;other penalties that don't replace a box
	cpy.w #$0008					;penalty $08?
	bne .t2
	jmp.w .3

.t2:								;penalty $0C?
	cpy.w #$000C
	bne .t1xx
	jmp.w .3

.t1xx:								;penalty $12?
	cpy.w #$0012
	bne .t3
	jmp.w .3

.t3:								;text of the penalty: a1 = its string, d0 = length - 2
	lda.b [a1],y					;offset of the string
	clc
	adc.b a1						;plus the table
	inc a							;skip the
	inc a							;length word
	sta.b a1						;string
	lda.b [a1]						;length byte
	dec a							;minus 2
	dec a
	sta.b d0						;box width
	bne .t1x2						;nonempty
	jmp.w .3						;empty: done

.t1x2:								;centre: x -= (width+1)/2
	inc a
	lsr a
	sta.b d0						;half width
	lda.w printx					;column
	sec
	sbc.b d0						;minus half
	sta.w printx					; center the text
	bpl .1x							;still on screen?
	stz.w printx					;no: column 0
.1x:								;box width = length, minus 1 if the last char is a space
	lda.b [a1]						;length
	sta.b d0						; d0
	tay
	dec.b a1						;back one byte
	lda.b [a1],y					;last char
	inc.b a1						;restore
	and.w #$00FF					;low byte
	bne .2							;not blank
	dec.b d0						;one narrower
.2:									;draw the box with the text
	lda.w #$0001
	sta.l penmsgbox					;box up
	lda.w #$0003					;3 high
	sta.b d1
	jsl.l Framer					; draw a frame and fill it
	dec.w printy					;up 2 rows
	dec.w printy
	inc.w printx					;inside the frame
	jsl.l print						;print the text
	bra .3							;done

.t5:								;horizontal layout: clear the old message
	jsl.l ClearPenaltyMessage
	lda.b d0						;new message?
	bmi .3							;no
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #prefmesPos3>>16			;print prefmesPos3
	sta.b a1+2
	lda.w #prefmesPos3
	sta.b a1
	jsl.l print						; print prefmesPos3
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #Penaltylist>>16			;penalty name table
	sta.b a1+2
	lda.w #Penaltylist
	sta.b a1
	ldy.b d0						;penalty offset
	lda.b [a1],y					;offset of the string
	clc
	adc.b a1						;plus the table
	inc a
	inc a
	sta.b a1						; text
	lda.b [a1]
	lsr a							; half of the text length
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx					; center
	jsl.l print						; print it
.3:									; a1+2 = pulled value, a1 = pulled value, d2+2 = pulled value, ...
	pla
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b d2+2
	pla
	sta.b d2
	pla
	sta.b d1+2
	pla
	sta.b d1
	pla
	sta.b d0+2
	pla
	sta.b d0
	rtl
