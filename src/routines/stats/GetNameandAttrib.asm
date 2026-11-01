; Print a player's number and name, then the attribute d4 through attribjmp (ratings first through CalcAttrib)
; Takes d0 = player, d4 = attribute to show, a2 = team, X preserved. Saves d0 to d9 and the pointers, prints
; the number and name with getname and print, then calls the handler for d4 from attribjmp
; (attributes from 3 on first set usehotcold and call CalcAttrib), and restores everything.
;
; Called from ShowRosterLine, PrintLinePlayerList and PrintShooterRows.
GetNameandAttrib:					; print player name and one attribute
	stx.b xsave						; keep X
	ldx.w #$0000
.loop:								; save d0 to d9 on the stack
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .loop
	ldx.b xsave
	lda.b a0						; save the pointers a0, a1 and r2
	pha
	lda.b a0+2
	pha
	lda.b a1
	pha
	lda.b a1+2
	pha
	lda.b r2
	pha
	jsl.l getname					; print the number and name
	jsl.l print
	pla
	sta.b r2
	lda.w #$0019					; column of the attribute
	sta.w printx
	lda.l pausesubmenu				; pause menu column differs by one
	bne .1
	inc.w printx
.1:									; attribute number
	lda.b d4
	cmp.w #$0003
	bcs .t1
	jmp.w .2

.t1:								; attributes 3 and up are calculated
	lda.w #$0001
	sta.l usehotcold
	jsl.l CalcAttrib				; overall rating of a player from his attributes and hot / cold values
.2:									; handler for the attribute from attribjmp
	lda.w #attribjmp>>16
	sta.b a0+2
	lda.w #attribjmp
	sta.b a0
	ldy.b d4						; d4 selects the routine
	lda.b [a0],y
	clc
	adc.b a0
	sta.b a0
	sta.w jmlvector+1				; patch the jump address
	lda.b a0+1
	sta.w jmlvector+2
	jsl.l jmlvector					; call the handler
	pla								; restore the pointers
	sta.b a1+2
	pla
	sta.b a1
	pla
	sta.b a0+2
	pla
	sta.b a0
	stx.b xsave						; keep X
	ldx.w #$0012
.loopx:								; restore d0 to d9
	pla
	sta.b d0,x
	dex
	dex
	bpl .loopx
	ldx.b xsave
	rtl
