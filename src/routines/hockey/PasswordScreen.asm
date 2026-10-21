; Password entry screen
PasswordScreen:						; called from setoptions
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	lda.w #$FF7F
	and.l PassWord
	sta.l PassWord
	jsl.l ClearTextMap				; fill the text map with the blank tile
	stz.w textdirtylo
	lda.w #$03FF
	sta.w textdirtyhi
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadAnyPad				; d1 = the buttons that changed on any pad
	jsl.l SpriteFrameStart
	ldx.w #$0053
	ldy.w #$0018
	lda.w #PasswordLabel>>16
	sta.b a1+2
	lda.w #PasswordLabel
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites PasswordLabel
	lda.w #$001C
	sta.l setupvis
	lda.w #$001D
	sta.l setuphome
	jsl.l DrawMatchupPictures
	jsl.l SpriteFrameEnd
	jsl.l SendColours				; send the 256 colours of the colour buffer with DMAToCGRAM
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PasswordScreenPos>>16
	sta.b a1+2
	lda.w #PasswordScreenPos
	sta.b a1
	jsl.l print						; print PasswordScreenPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0011
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l FramerOutline
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PasswordTxt>>16
	sta.b a1+2
	lda.w #PasswordTxt
	sta.b a1
	jsl.l print						; print PasswordTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	dec.w printx
	dec.w printx
	lda.w #PasstoText>>16
	sta.b a0+2
	lda.w #PasstoText
	sta.b a0
	lda.w #$0004
	sta.b d0
.loop:								; loop: d1 = $0005, a1 = mesarea, [a1] = $000D, ...
	lda.w #$0005
	sta.b d1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$000D
	sta.b [a1]
	inc.b a1
	inc.b a1
.loop2:								; loop: [a1] = [a0], increment a0, increment a1, ...
	lda.b [a0]
	sta.b [a1]
	inc.b a0
	inc.b a1
	lda.w #$0020
	sta.b [a1]
	inc.b a1
	dec.b d1
	bpl .loop2
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	jsl.l print						; print mesarea
	inc.w printy
	inc.w printy
	lda.w printx
	sec
	sbc.w #$000B
	sta.w printx
	dec.b d0
	bpl .loop
	stz.b d4
	jsl.l PrintSelectLeft			; print the Select Left hint on the password screen
	stz.b d5
	lda.l PassWord
	and.w #$00FF
	cmp.w #$001E
	bcs .1
	sta.b d5
.1:									; call PlacePasswordCursor, call FramerOutline, PWCharStr = $0003, ...
	jsl.l PlacePasswordCursor		; move the password cursor to character d5
	jsl.l FramerOutline
	lda.w #$0003
	sta.w PWCharStr
	phx
	ldy.b d5
	tyx
	lda.l PasstoText,x
	plx
	sta.w PWCharStr+2
	lda.w #$0000
	sta.b a1+2
	lda.w #$0A4A
	sta.b a1
	inc.w printx
	dec.w printy
	dec.w printy
	jsl.l print
	lda.w #$000A
	sta.w fadestep
PasswordRedraw:						; called from BadPasswordPrompt
	jsr.w PrintPasswordHelp			; print the password screen keys: Select, A Next, Y Back, Press start
.1:									; a1 = PasswordScreenPos2, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #PasswordScreenPos2>>16
	sta.b a1+2
	lda.w #PasswordScreenPos2
	sta.b a1
	jsl.l print						; print PasswordScreenPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l PWprint					; print the password, unless it is hidden
	jsl.l QueueTextDMA				; queue the changed part of the text map for transfer to video memory
.loop:								; loop: call WaitFrame, call ReadPads, call ReadJoy1, ...
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadJoy1					; read pad 1: d0 = direction, d1 = new presses, d2 = changed buttons
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1
	beq .loop
	sta.b d1
	bit.w #$1000
	beq .t3
	jmp.w BadPasswordPrompt			; bad password: wait for a button, then offer retry or exit

.t3:								; d0 = 0, decrement d0, if not zero go to .t1, ...
	stz.b d0
	dec.b d0
	bit.w #$4000
	bne .t1
	stz.b d0
	inc.b d0
	bit.w #$8080
	bne .t1
	bit.w #$0100
	bne .2
	stz.b d0
	dec.b d0
	bit.w #$0200
	bne .2
	ldy.w #$0006
	sty.b d0
	bit.w #$0400
	bne .2
	ldy.w #$FFFA
	sty.b d0
	bit.w #$0800
	bne .2
	jmp.w .1

.t1:								; if carry clear go to .t2, ...
	lda.b d4
	clc
	adc.b d0
	cmp.w #$0010
	bcc .t2
	jmp.w .1

.t2:								; d4 = A, call PrintSelectLeft, a0 = PassWord, ...
	sta.b d4
	jsl.l PrintSelectLeft			; print the Select Left hint on the password screen
	lda.w #PassWord>>16
	sta.b a0+2
	lda.w #PassWord
	sta.b a0
	stz.b d0
	ldy.b d4
	lda.b [a0],y
	and.w #$00FF
	cmp.w #$001E
	bcs .2
	sec
	sbc.b d5
	sta.b d0
.2:									; if carry clear go to .t1x, ...
	lda.b d5
	clc
	adc.b d0
	cmp.w #$001E
	bcc .t1x
	jmp.w .1

.t1x:								; call PlacePasswordCursor, d2 = blankchar, call eraser, ...
	pha
	jsl.l PlacePasswordCursor		; move the password cursor to character d5
	lda.l blankchar
	sta.b d2
	jsl.l eraser
	lda.w #$0003
	sta.w PWCharStr
	phx
	ldy.b d5
	tyx
	lda.l PasstoText,x
	plx
	sta.w PWCharStr+2
	lda.w #$0000
	sta.b a1+2
	lda.w #$0A4A
	sta.b a1
	inc.w printx
	dec.w printy
	dec.w printy
	jsl.l print
	pla
	sta.b d5
	jsl.l PlacePasswordCursor		; move the password cursor to character d5
	jsl.l FramerOutline
	phx
	ldy.b d5
	tyx
	lda.l PasstoText,x
	plx
	sta.w PWCharStr+2
	lda.w #$0000
	sta.b a1+2
	lda.w #$0A4A
	sta.b a1
	inc.w printx
	dec.w printy
	dec.w printy
	jsl.l print
	lda.w #PassWord>>16
	sta.b a0+2
	lda.w #PassWord
	sta.b a0
	ldy.b d4
	sep #$20
	lda.b d5
	sta.b [a0],y
	rep #$30
	jmp.w .1
