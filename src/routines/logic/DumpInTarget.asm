; assdumpin: dumpinplayer = X; pick the dump-in target (dumpintarget) and passdir from where he is
DumpInTarget:						; called from assdumpin
	stx.w dumpinplayer
	lda.w position,x
	beq .t4
	lda.w pfgoal,x
	bne .t3
	lda.w Ypos,x
	cmp.w #-Blueline
	bmi .t2
.1:									; passdir = $0004, if Xpos,x negative go to .t1, ...
	lda.w #$0004
	sta.w passdir
	lda.w Xpos,x
	bmi .t1
	lda.w #$000A
	sta.w dumpintarget
	rtl

.t1:								; Xpos,x negative: dumpintarget = $0006, return
	lda.w #$0006
	sta.w dumpintarget
	rtl

.t2:								; Ypos,x + Blueline negative: passdir = puckdir+$1A - $0004 & $0007, du...
	lda.w puckdir+$1A
	sec
	sbc.w #$0004
	and.w #$0007
	sta.w passdir
	lda.w #$0008
	sta.w dumpintarget
	rtl

.t3:								; pfgoal,x != 0: if Ypos,x - Blueline >= 0 go to .t2x, ...
	lda.w Ypos,x
	cmp.w #Blueline
	bpl .t2x
	lda.w #$0000
	sta.w passdir
	lda.w Xpos,x
	bmi .t1x
	lda.w #$0016
	sta.w dumpintarget
	rtl

.t1x:								; Xpos,x negative: dumpintarget = $0012, return
	lda.w #$0012
	sta.w dumpintarget
	rtl

.t2x:								; Ypos,x - Blueline >= 0: passdir = puckdir+$18 - $0004 & $0007, dumpin...
	lda.w puckdir+$18
	sec
	sbc.w #$0004
	and.w #$0007
	sta.w passdir
	lda.w #$0014
	sta.w dumpintarget
	rtl

.t4:								; position,x = 0: dumpintarget = 0, passdir = 0, if pfgoal,x != 0 go to...
	stz.w dumpintarget
	stz.w passdir
	lda.w pfgoal,x
	bne .rtl
	lda.w #$000C
	sta.w dumpintarget
	lda.w #$0004
	sta.w passdir
.rtl:								; return
	rtl
