; OR the word A into X bytes at [p1]
MemOr:								; called from TitleScreen
	sta.b r3
	txy
	dey
	dey
.loop:								; loop: ora r3, [p1],y = A, Y - 1, ...
	lda.b [p1],y
	ora.b r3
	sta.b [p1],y
	dey
	dey
	bne .loop
	lda.b [p1]
	ora.b r3
	sta.b [p1]
	rtl

.t1:								; r3 = A, txy, Y - 1, ...
	sta.b r3
	txy
	dey
	dey
.loopx:								; loop: and r3, [p1],y = A, Y - 1, ...
	lda.b [p1],y
	and.b r3
	sta.b [p1],y
	dey
	dey
	bne .loopx
	lda.b [p1]
	and.b r3
	sta.b [p1]
	rtl
