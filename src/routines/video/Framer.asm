; Draw a frame and fill it. d0 / d1 = width / height
Framer:								; called from ClearPenaltyMessage, DrawExitPrompt, Intermission, NewTic...
	phx
	phy
	lda.l Framercset
	clc
	adc.l printfontset
	ora.w printa
	sta.b tmp0
	lda.w #FramerMap>>16
	sta.b p0+2
	lda.w #FramerMap+6
	sta.b p0
	jsr.w FramerRow					; draw one row of a frame into the text map at printx / printy: a corner
	lda.b tmp2
	lsr a
	cmp.w textdirtylo
	bcs .1
	sta.w textdirtylo
.1:									; decrement d1, decrement d1
	dec.b d1
	dec.b d1
.loop:								; loop: p0 = FramerMap+12, call FramerRow, decrement d1, ...
	lda.w #FramerMap+12
	sta.b p0
	jsr.w FramerRow					; draw one row of a frame into the text map at printx / printy: a corner
	dec.b d1
	bne .loop
	lda.w #FramerMap+18
	sta.b p0
	jsr.w FramerRow					; draw one row of a frame into the text map at printx / printy: a corner
	inx
	inx
	txa
	lsr a
	cmp.w textdirtyhi
	bcc .2
	sta.w textdirtyhi
.2:									; return
	ply
	plx
	rtl
