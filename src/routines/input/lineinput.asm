; Pad input while the line change box is open
;
; Takes X = player, d1 = new presses. A reopen request (tmflags bit 0) redraws the box. Y, B and A (bits
; $4000, $8000, $0080) choose row 0, 1, 2 via lcfound; $2000 leaves the box and keeps the line;
; otherwise the player skates (doplayeracc). Called from doinput.
lineinput:							; pad input for the line change box
	lda.b d1						; save the new presses
	pha
	stz.b a2						; a2 = team of player X
	lda.w pfteam,x					; his team
	beq .1							; team 0
	inc.b a2						; team 1: a2 = 2
	inc.b a2
.1:									; if tmflags,y bits $0001 clear go to .2, ...
	ldy.b a2						; Y = team offset
	lda.w tmflags,y					; team flags
	bit.w #$0001					; redraw request (bit 0)?
	beq .2							; no
	and.w #$FFFE					; clear the request
	sta.w tmflags,y
	lda.w #$FFFF
	sta.w lcpad,y					; no pad owns the box
	jsl.l lcfound_close					; close the box
	jsl.l SetLCmode2				; and open it again
.2:									; d1 = pulled value, d2 = 0, if not zero go to .t3, ...
	pla								; restore the presses
	sta.b d1
	stz.b d2						; d2 = choice 0
	bit.w #$4000					; Y button?
	bne .t3							; choose row 0
	inc.b d2						; choice 1
	bit.w #$8000					; B button?
	bne .t3							; choose row 1
	inc.b d2						; choice 2
	bit.w #$0080					; A button?
	bne .t3							; choose row 2
	bit.w #$2000					; Select ($2000): leave the box?
	bne .t2							; yes
	lda.w pflags,x					; player flags
	bit.w #$0008					; bit 3 set (pad controlled)?
	beq .t1							; no
	lda.w pfalock,x					; animation locked?
	bne .t1							; yes
	jml.l doplayeracc				; skate

.t1:								; return
	rtl								; return

.t2:								; leave the box without changing lines
	lda.w pflags,x					; player flags
	ora.w #$0008					; set bit 3
	sta.w pflags,x
	jsl.l loadTeamStruct			; a2 = team of X
	ldy.b a2						; Y = team offset
	lda.w tmflags,y					; team flags
	and.w #$FFF7					; close the line change box (bit 3)
	sta.w tmflags,y
	lda.w #$FFFF					; no pad owns the box
	sta.w lcpad,y
	jmp.w lcfound_close					; redraw the scoreboard

.t3:								; row chosen
	jmp.w lcfound					; switch lines
