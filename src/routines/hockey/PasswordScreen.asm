; Password entry screen
PasswordScreen:						;password entry: a 5 by 6 grid of characters, 16 positions; called from
									;setoptions
	jsl.l FadeOut					; fade out: install BrightnessHook as the frame hook
	jsl.l WaitFadeOut				; wait until the screen is black
	lda.w #$FF7F					;clear bit 7 of the first character
	and.l PassWord					;password
	sta.l PassWord
	jsl.l ClearTextMap				; fill the text map with the blank tile
	stz.w textdirtylo				;whole text map
	lda.w #$03FF
	sta.w textdirtyhi				;dirty
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l ReadAnyPad				; d1 = the buttons that changed on any pad
	jsl.l SpriteFrameStart
	ldx.w #$0053					;x
	ldy.w #$0018					;y
	lda.w #PasswordLabel>>16
	sta.b a1+2
	lda.w #PasswordLabel
	sta.b a1
	jsl.l PrintLetterSprites		; PrintLetterSprites PasswordLabel
	lda.w #$001C					;team $1C
	sta.l setupvis					;as visitors
	lda.w #$001D					;team $1D
	sta.l setuphome					;as home
	jsl.l DrawMatchupPictures		;their pictures
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
	lda.w #$0011					;17 wide
	sta.b d0
	lda.w #$0005					;5 high
	sta.b d1
	jsl.l FramerOutline				;box outline
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
	dec.w printx					;back 2 columns
	dec.w printx
	lda.w #PasstoText>>16			;grid characters
	sta.b a0+2
	lda.w #PasstoText
	sta.b a0
	lda.w #$0004					;5 rows
	sta.b d0
.loop:								;each row: 6 characters with spaces
	lda.w #$0005					;6 characters
	sta.b d1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	lda.w #$000D					;string length 13
	sta.b [a1]						;first word
	inc.b a1						;text after it
	inc.b a1
.loop2:								; loop: [a1] = [a0], increment a0, increment a1, ...
	lda.b [a0]						;character
	sta.b [a1]						;stored
	inc.b a0						;next character
	inc.b a1
	lda.w #$0020					;space
	sta.b [a1]						;after it
	inc.b a1
	dec.b d1						;characters left
	bpl .loop2
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #mesarea
	sta.b a1
	jsl.l print						;print the row
	inc.w printy					;2 rows
	inc.w printy					;down
	lda.w printx					;column
	sec
	sbc.w #$000B					;back 11
	sta.w printx					;row start
	dec.b d0						;rows left
	bpl .loop
	stz.b d4						;position 0
	jsl.l PrintSelectLeft			; print the Select Left hint on the password screen
	stz.b d5						;cursor on the grid
	lda.l PassWord					;first character
	and.w #$00FF
	cmp.w #$001E					;valid (below 30)?
	bcs .1							;no: cursor at 0
	sta.b d5						;cursor on it
.1:									; call PlacePasswordCursor, call FramerOutline, PWCharStr = $0003, ...
	jsl.l PlacePasswordCursor		; move the password cursor to character d5
	jsl.l FramerOutline
	lda.w #$0003					;string length 3
	sta.w PWCharStr
	phx								;cursor
	ldy.b d5
	tyx
	lda.l PasstoText,x				;its character
	plx
	sta.w PWCharStr+2				;in the string
	lda.w #$0000
	sta.b a1+2
	lda.w #$0A4A					;text at $0A4A
	sta.b a1
	inc.w printx					;inside the box
	dec.w printy					;up 2 rows
	dec.w printy
	jsl.l print						;print the character
	lda.w #$000A					;fade-in step
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
	lda.b d1						;presses
	beq .loop						;none
	sta.b d1
	bit.w #$1000					;Start?
	beq .t3							;no
	jmp.w BadPasswordPrompt			;check the password

.t3:								; d0 = 0, decrement d0, if not zero go to .t1, ...
	stz.b d0						;-1
	dec.b d0
	bit.w #$4000					;Y: previous position
	bne .t1
	stz.b d0						;+1
	inc.b d0
	bit.w #$8080					;A or B: next position
	bne .t1
	bit.w #$0100					;Right: next character
	bne .2
	stz.b d0						;-1
	dec.b d0
	bit.w #$0200					;Left: previous character
	bne .2
	ldy.w #$0006					;+6
	sty.b d0
	bit.w #$0400					;Down: next row
	bne .2
	ldy.w #$FFFA					;-6
	sty.b d0
	bit.w #$0800					;Up: previous row
	bne .2
	jmp.w .1						;other: ignore

.t1:								; if carry clear go to .t2, ...
	lda.b d4						;position
	clc
	adc.b d0						;plus the step
	cmp.w #$0010					;past 15?
	bcc .t2							;no
	jmp.w .1						;yes: ignore

.t2:								; d4 = A, call PrintSelectLeft, a0 = PassWord, ...
	sta.b d4						;new position
	jsl.l PrintSelectLeft			; print the Select Left hint on the password screen
	lda.w #PassWord>>16				;the password
	sta.b a0+2
	lda.w #PassWord
	sta.b a0
	stz.b d0						;no cursor change
	ldy.b d4						;position
	lda.b [a0],y					;its character
	and.w #$00FF
	cmp.w #$001E					;valid?
	bcs .2							;no: cursor stays
	sec
	sbc.b d5						;minus the cursor
	sta.b d0						;cursor step to it
.2:									; if carry clear go to .t1x, ...
	lda.b d5						;cursor
	clc
	adc.b d0						;plus the step
	cmp.w #$001E					;off the grid?
	bcc .t1x						;no
	jmp.w .1						;yes: ignore

.t1x:								; call PlacePasswordCursor, d2 = blankchar, call eraser, ...
	pha								;new cursor
	jsl.l PlacePasswordCursor		; move the password cursor to character d5
	lda.l blankchar					;blank tile
	sta.b d2
	jsl.l eraser					;erase the old cursor
	lda.w #$0003					;string length 3
	sta.w PWCharStr
	phx
	ldy.b d5						;cursor
	tyx
	lda.l PasstoText,x				;its character
	plx
	sta.w PWCharStr+2				;in the string
	lda.w #$0000
	sta.b a1+2
	lda.w #$0A4A					;text at $0A4A
	sta.b a1
	inc.w printx					;inside the box
	dec.w printy					;up 2 rows
	dec.w printy
	jsl.l print						;print the character
	pla
	sta.b d5						;new cursor
	jsl.l PlacePasswordCursor		;move it
	jsl.l FramerOutline
	phx
	ldy.b d5						;cursor
	tyx
	lda.l PasstoText,x				;its character
	plx
	sta.w PWCharStr+2				;in the string
	lda.w #$0000
	sta.b a1+2
	lda.w #$0A4A					;text at $0A4A
	sta.b a1
	inc.w printx					;inside the box
	dec.w printy					;up 2 rows
	dec.w printy
	jsl.l print						;print the character
	lda.w #PassWord>>16
	sta.b a0+2
	lda.w #PassWord
	sta.b a0
	ldy.b d4						;position
	sep #$20
	lda.b d5						;cursor character
	sta.b [a0],y					;into the password
	rep #$30
	jmp.w .1						;redraw
