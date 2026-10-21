; Title: reset the credits state (entry CreditTitleIdx, step CreditStep, the two text y positions CreditTitleY
; / CreditNameY)
StartCredits:						; no input; called from TitleScreen
	stz.w CreditTitleIdx			; first title
	stz.w CreditNameIdx				; first name
	lda.w #$0000
	sta.w CreditStep				; step 0: title and name scroll in
	lda.w #$00E0					; title starts at y $E0 (below the screen)
	sta.w CreditTitleY
	lda.w #$00F0					; name starts at y $F0
	sta.w CreditNameY
	stz.w CreditTime				; no wait pending
	rts								; done

RollCredits:						; advance the credits one step when its wait is over; called from
									; TitleScreen
	lda.w FrameCount				; frames so far
	cmp.w CreditTime				; wait over?
	bcc .rts						; not yet
	lda.w CreditStep				; step
	cmp.w #$0003					; step 3 = finished
	bne .t1							; no
.rts:								; nothing to do
	rts

.t1:								; step 0: title and name scroll up
	cmp.w #$0000					; step 0?
	bne .2							; no
	lda.w CreditTitleY				; title y
	dec a
	dec a
	cmp.w #$00B9					; scrolled far enough?
	bmi .3							; yes: hold
	dec.w CreditTitleY				; title up 2
	dec.w CreditTitleY
.1:									; name up 2
	dec.w CreditNameY
	dec.w CreditNameY
	lda.w #$0002					; redraw after 2 frames
	bra .5							; draw
.2:									; step 1: only the name scrolls up
	cmp.w #$0001					; step 1?
	bne .4							; no, step 2: next entry
	lda.w CreditNameY				; name y
	dec a
	dec a
	cmp.w #$00C9					; not yet at its place?
	bpl .1							; keep scrolling
.3:									; hold the text on screen
	lda.w #$0002					; step 2
	sta.w CreditStep
	lda.w #$0046					; for 70 frames
	bra .5							; draw
.4:									; step 2: next name
	inc.w CreditNameIdx				; next name
	lda.w CreditNameIdx
	asl a							; word index
	tax
	lda.l CreditNames,x				; name pointer
	bne .t2							; more names under this title
	inc.w CreditTitleIdx			; next title
	lda.w CreditTitleIdx
	asl a
	tax
	lda.l CreditTitles,x			; title pointer
	beq .t1x						; none left: finish
	inc.w CreditNameIdx				; first name of the new title
	lda.w #$00E0					; title starts at y $E0
	sta.w CreditTitleY
	lda.w #$00F0					; name starts at y $F0
	sta.w CreditNameY
	lda.w #$0000					; step 0
	sta.w CreditStep
	lda.w #$000F					; draw after 15 frames
	bra .5							; draw

.t1x:								; credits finished
	lda.w #$0003					; step 3
	sta.w CreditStep
	lda.w #$00E0					; positions reset
	sta.w CreditTitleY
	lda.w #$00F0					; name y
	sta.w CreditNameY
	lda.w #$002D					; wait 45 frames
	bra .5							; draw

.t2:								; next name under the same title
	lda.w #$0001					; step 1: the name scrolls in
	sta.w CreditStep
	lda.w #$00E0					; name starts at y $E0
	sta.w CreditNameY
	lda.w #$000F					; draw after 15 frames
.5:									; A = frames until the next step: set the wait and draw the credits
									; sprites
	clc
	adc.w FrameCount				; next step time
	sta.w CreditTime				; store it
	jsl.l SpriteFrameStart			; new sprite frame
	lda.w #titlesprbuf>>16			; p1 = sprite buffer
	sta.b p1+2
	lda.w #titlesprbuf
	sta.b p1
	lda.w #$0009					; title sprite 9 ...
	jsr.w DrawTitleSprite
	lda.w #$000A					; ... and 10
	jsr.w DrawTitleSprite
	lda.w CreditTitleIdx			; current title
	asl a
	tax
	lda.l CreditTitles,x			; its string
	sta.b a1
	lda.w #CreditTitles>>16			; string bank
	sta.b a1+2
	ldx.w #$0080					; x = 128
	ldy.w CreditTitleY				; y of the title
	jsl.l PrintStringSprites		; print the title
	lda.w CreditNameIdx				; current name
	asl a
	tax
	lda.l CreditNames,x				; its string
	sta.b a1
	lda.w #CreditNames>>16
	sta.b a1+2
	ldx.w #$0080
	ldy.w CreditNameY				; y of the name
	jsl.l PrintStringSprites		; print the name
	jsl.l SpriteFrameEnd			; close the frame
	rts								; done
