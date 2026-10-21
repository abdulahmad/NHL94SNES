; If a line change wants player X off, send him to the bench
; Takes: X = player object. Returns normally (rtl) when nothing happens; otherwise pops its own return
; address and ends the caller's routine: the player is sent to assbench (assignment $0C), or, for the same
; roster player, gets a new assignment from his new position (Setplass). Called from the assignments assdefd,
; assdefo, asswingd, asscenterd, asscentero, asswingo, assgoalietopuck and assbench.
check4bench:						; check whether a line change wants this player off
	lda.w pflags,x					; player flags
	bit.w #$4000					; bit $4000 = pf2pen (caused a penalty)
	bne .t1							; penalty: leave him
	lda.w newpos,x					; new position requested?
	bpl .1							; yes
	lda.w newpnum,x					; no position: is a new roster player requested?
	bmi .t1							; none: leave him
.1:									; something was requested
	lda.w newpnum,x					; requested roster player
	cmp.w pnum,x					; same roster player as now?
	beq .t2							; yes: just a position change
	lda.w asscur,x					; his current assignment
	cmp.w #$000C					; already going to the bench (assignment $0C)?
	beq .t1							; yes: leave him
	cpx.w puckc						; the puck carrier stays
	beq .t1
	sep #$20						; pop the jsl return address (the caller is abandoned)
	pla								; pop the jsl return address
	rep #$30						; 16-bit registers
	pla
	lda.w pflags,x					; player flags
	ora.w #$1000					; set pf2unav ($1000)
	sta.w pflags,x
	stz.w temp1,x					; clear temp1
	lda.w #$000C					; bench assignment
	sta.b d0						; d0 = $0C
	jml.l assreplace				; replace the assignment with d0

.t1:								; return
	rtl

.t2:								; same roster player: only change position
	sep #$20						; pop the jsl return address (the caller is abandoned)
	pla								; pop the jsl return address
	rep #$30						; 16-bit registers
	pla
	lda.w pflags,x					; player flags
	and.w #$EFFF					; clear pf2unav
	sta.w pflags,x					; store
	stz.w pfnc,x					; collisions on
	lda.w #$FFFF					; nothing requested any more
	sta.w newpnum,x					; newpnum
	sta.w newpos,x					; newpos
	lda.w position					; d0 = position
	sta.b d0
	jmp.w Setplass					; new assignment from the position
