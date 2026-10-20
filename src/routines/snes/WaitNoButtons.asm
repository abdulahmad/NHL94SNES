; Wait until no button is held on pad 1
; Takes nothing. Spins until pad 1 has no button down (buttons only, the low nibble is ignored).
; The code after the rtl (.t1 to .t1x) are waits for the release of pad 2 or for a release with a
; frame timeout in X; nothing calls them.
;
; Called from BadPasswordPrompt.
WaitNoButtons:						; wait until no button is held on pad 1
	pha
.loop:								; still held?
	lda.w JoyPad
	and.w #$FFF0
	bne .loop
	pla
	rtl

.t1:								; unused: wait until no button is held on pad 2
	pha
.loopx:								; still held?
	lda.w JoyPad+2
	and.w #$FFF0
	bne .loopx
	pla
	rtl

.t2:								; unused: wait for the release of pad 1, at most X frames
	pha
.loopx2:							; wait a frame
	jsl.l WaitFrame
	lda.w JoyPad
	and.w #$FFF0
	beq .1
	dex
	bne .loopx2
.1:									; released or timed out
	pla
	rtl

.t1x:								; unused: the same for pad 2
	pha
.loopxx:							; wait a frame
	jsl.l WaitFrame
	lda.w JoyPad+2
	and.w #$FFF0
	beq .1x
	dex
	bne .loopxx
.1x:								; released or timed out
	pla
	rtl
