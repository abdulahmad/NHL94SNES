; Edit Lines menu: Return to Game and Restore default lines
EditLinesMenu:						; called from EditLinesScreen
	jsr.w ClearEditLinesMenu		; line editor: erase the menu area
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ReturnToGameTxt>>16
	sta.b a1+2
	lda.w #ReturnToGameTxt
	sta.b a1
	jsl.l print						; print ReturnToGameTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RestoreDefaultLinesTxt>>16
	sta.b a1+2
	lda.w #RestoreDefaultLinesTxt
	sta.b a1
	jsl.l print						; print RestoreDefaultLinesTxt
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l SendTextMap
	jsl.l WaitButtonRelease			; wait until the pause pad has no button down
	lda.w #$0000
	sta.w linemenuitem
.1:									; if $0000 != linemenuitem go to .t1, ...
	lda.w #$0000
	cmp.w linemenuitem
	bne .t1
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #EditLinesMenuPos>>16
	sta.b a1+2
	lda.w #EditLinesMenuPos
	sta.b a1
	jsl.l print						; print EditLinesMenuPos
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .2

.t1:								; $0000 != linemenuitem: a1 = EditLinesMenuPos2, call print, a1 = pulle...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #EditLinesMenuPos2>>16
	sta.b a1+2
	lda.w #EditLinesMenuPos2
	sta.b a1
	jsl.l print						; print EditLinesMenuPos2
	pla
	sta.b a1
	pla
	sta.b a1+2
.2:									; a1 = ReturnToGame, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #ReturnToGame>>16
	sta.b a1+2
	lda.w #ReturnToGame
	sta.b a1
	jsl.l print						; print ReturnToGame
	pla
	sta.b a1
	pla
	sta.b a1+2
	lda.w #$0001
	cmp.w linemenuitem
	bne .t1x
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #EditLinesMenuPos3>>16
	sta.b a1+2
	lda.w #EditLinesMenuPos3
	sta.b a1
	jsl.l print						; print EditLinesMenuPos3
	pla
	sta.b a1
	pla
	sta.b a1+2
	bra .3

.t1x:								; $0001 != linemenuitem: a1 = EditLinesMenuPos4, call print, a1 = pulle...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #EditLinesMenuPos4>>16
	sta.b a1+2
	lda.w #EditLinesMenuPos4
	sta.b a1
	jsl.l print						; print EditLinesMenuPos4
	pla
	sta.b a1
	pla
	sta.b a1+2
.3:									; a1 = RestoreDefaultLines, call print, a1 = pulled value, ...
	lda.b a1+2
	pha
	lda.b a1
	pha
	lda.w #RestoreDefaultLines>>16
	sta.b a1+2
	lda.w #RestoreDefaultLines
	sta.b a1
	jsl.l print						; print RestoreDefaultLines
	pla
	sta.b a1
	pla
	sta.b a1+2
	jsl.l SendTextMap
	jsl.l WaitFrame
	jsl.l ReadPads					; once per frame: each pad's direction, changed buttons and new presses
	jsl.l getpzjoy					; ReadjoyA for the controller that owns the pause menu
	jsl.l ProcessInputWithRepeat	; read the pads with key repeat
	lda.b d1
	bit.w #$9080
	bne .7
	bit.w #$0400
	bne .6
	bit.w #$0800
	bne .5
.4:									; go to .1
	jmp.w .1
.5:									; linemenuitem = $0000, go to .4
	lda.w #$0000
	sta.w linemenuitem
	bra .4
.6:									; linemenuitem = $0001, go to .4
	lda.w #$0001
	sta.w linemenuitem
	bra .4
.7:									; d1 bit $9080 set: if linemenuitem = $0000 go to .t1xx, ...
	lda.w linemenuitem
	cmp.w #$0000
	beq .t1xx
	bra .t2

.t1xx:								; linemenuitem = $0000: go to .1x
	lda.w #$FFFF
	bra .1x

.t2:								; call LoadTeamLines, call ClearEditLinesMenu, call DrawEditLinesTop, ...
	jsl.l LoadTeamLines				; copy team a2's lines from the team data into RAM
	jsr.w ClearEditLinesMenu		; line editor: erase the menu area
	jsl.l DrawEditLinesTop			; line editor: clear the top, the title and the line frame
	lda.w #$0000
.1x:								; return
	rts
